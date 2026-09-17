import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:go_router/go_router.dart';

import '../../../domain/models/transaction_type.dart';
import '../../../theme/colors.dart';
import '../../../theme/typography.dart';
import '../../widgets/category_choices.dart';
import '../../widgets/category_circle.dart';
import '../../widgets/debit_credit_toggle.dart';
import '../../widgets/dialogs.dart';
import '../../widgets/ledgr_app_bar.dart';
import '../../widgets/ledgr_primary_button.dart';
import 'bloc/category_form_bloc.dart';
import 'bloc/category_form_event.dart';
import 'bloc/category_form_state.dart';

class CategoryFormScreen extends StatefulWidget {
  const CategoryFormScreen({
    super.key,
    this.categoryId,
    this.type = TransactionType.expense,
  });

  final int? categoryId;
  final TransactionType type;

  @override
  State<CategoryFormScreen> createState() => _CategoryFormScreenState();
}

class _CategoryFormScreenState extends State<CategoryFormScreen> {
  late final TextEditingController _name;
  var _hydrated = false;

  @override
  void initState() {
    super.initState();
    _name = TextEditingController();
  }

  @override
  void dispose() {
    _name.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CategoryFormBloc, CategoryFormState>(
      listenWhen: (previous, current) {
        return current.saved ||
            current.deleted ||
            current.errorMessage != previous.errorMessage ||
            (current.deletePromptCount != null &&
                previous.deletePromptCount == null) ||
            (previous.loading && !current.loading && !_hydrated);
      },
      listener: (context, state) async {
        if (!_hydrated && !state.loading && state.name.isNotEmpty) {
          _hydrated = true;
          _name.text = state.name;
        }
        if (state.saved || state.deleted) {
          context.pop(state.savedCategoryId);
          return;
        }
        if (state.errorMessage != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.errorMessage!)),
          );
        }
        final count = state.deletePromptCount;
        if (count == null) return;
        final confirmed = await showDeleteConfirmDialog(
          context: context,
          title: 'Delete category',
          message: count == 0
              ? 'Delete this category?'
              : '$count ${count == 1 ? 'entry' : 'entries'} will move to Other.',
        );
        if (!context.mounted) return;
        final bloc = context.read<CategoryFormBloc>();
        if (confirmed) {
          bloc.add(const CategoryFormDeleteConfirmed());
        } else {
          bloc.add(const CategoryFormDeleteDismissed());
        }
      },
      builder: (context, state) {
        final bloc = context.read<CategoryFormBloc>();
        return Scaffold(
          appBar: LedgrAppBar(
            title: widget.categoryId == null ? 'New category' : 'Edit category',
            leading: IconButton(
              tooltip: 'Close',
              onPressed: () => context.pop(),
              icon: const Icon(TablerIcons.x, color: paper, size: 19),
            ),
          ),
          body: state.loading
              ? const Center(
                  child: CircularProgressIndicator(color: tealAccent),
                )
              : Column(
                  children: [
                    Expanded(
                      child: ListView(
                        padding: const EdgeInsets.fromLTRB(20, 24, 20, 16),
                        children: [
                          if (widget.categoryId == null)
                            DebitCreditToggle(
                              expenseSelected:
                                  state.type == TransactionType.expense,
                              onChanged: (expense) => bloc.add(
                                CategoryFormTypeChanged(
                                  expense
                                      ? TransactionType.expense
                                      : TransactionType.income,
                                ),
                              ),
                            ),
                          if (widget.categoryId == null)
                            const SizedBox(height: 24),
                          TextField(
                            key: const Key('category-name-field'),
                            controller: _name,
                            enabled: !state.isDefault,
                            style: uiStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                            cursorColor: tealAccent,
                            decoration: InputDecoration(
                              hintText: 'Name',
                              hintStyle: uiStyle(fontSize: 16, color: mutedInk),
                              border: InputBorder.none,
                            ),
                            onChanged: (value) =>
                                bloc.add(CategoryFormNameChanged(value)),
                          ),
                          const Divider(color: ruleColor, height: 1),
                          const SizedBox(height: 20),
                          Text(
                            'Icon',
                            style: uiStyle(fontSize: 13, color: mutedInk),
                          ),
                          const SizedBox(height: 12),
                          GridView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: categoryIconChoices.length,
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 6,
                              mainAxisSpacing: 10,
                              crossAxisSpacing: 10,
                            ),
                            itemBuilder: (context, index) {
                              final icon = categoryIconChoices[index];
                              final selected =
                                  state.iconCodePoint == icon.codePoint;
                              return GestureDetector(
                                onTap: state.isDefault
                                    ? null
                                    : () => bloc.add(
                                          CategoryFormIconChanged(
                                            icon.codePoint,
                                          ),
                                        ),
                                child: Container(
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: categoryCircleFill,
                                    border: selected
                                        ? Border.all(
                                            color: tealAccent,
                                            width: 2,
                                          )
                                        : null,
                                  ),
                                  child: Icon(icon, size: 20, color: inkNavy),
                                ),
                              );
                            },
                          ),
                          const SizedBox(height: 20),
                          Text(
                            'Color',
                            style: uiStyle(fontSize: 13, color: mutedInk),
                          ),
                          const SizedBox(height: 12),
                          Wrap(
                            spacing: 12,
                            runSpacing: 12,
                            children: [
                              for (final color in categoryColorChoices)
                                GestureDetector(
                                  onTap: state.isDefault
                                      ? null
                                      : () => bloc.add(
                                            CategoryFormColorChanged(color),
                                          ),
                                  child: Container(
                                    width: 28,
                                    height: 28,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Color(color),
                                      border: state.colorValue == color
                                          ? Border.all(
                                              color: tealAccent,
                                              width: 2,
                                            )
                                          : null,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                          const SizedBox(height: 28),
                          Center(
                            child: CategoryCircle(
                              icon: IconData(
                                state.iconCodePoint,
                                fontFamily: 'tabler-icons',
                                fontPackage: 'flutter_tabler_icons',
                              ),
                              label:
                                  state.name.isEmpty ? 'Preview' : state.name,
                              iconColor: Color(state.colorValue),
                              selected: true,
                            ),
                          ),
                          if (widget.categoryId != null && !state.isDefault) ...[
                            const SizedBox(height: 12),
                            TextButton(
                              key: const Key('delete-category'),
                              onPressed: () => bloc.add(
                                const CategoryFormDeletePressed(),
                              ),
                              child: Text(
                                'Delete category',
                                style: uiStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: ledgerRed,
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                    SafeArea(
                      top: false,
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
                        child: LedgrPrimaryButton(
                          key: const Key('save-category'),
                          label: 'Save category',
                          onPressed: state.canSave
                              ? () => bloc.add(
                                    const CategoryFormSaveRequested(),
                                  )
                              : null,
                        ),
                      ),
                    ),
                  ],
                ),
        );
      },
    );
  }
}
