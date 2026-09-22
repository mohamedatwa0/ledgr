import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../domain/models/transaction_type.dart';
import '../../../l10n/l10n.dart';
import '../../../theme/colors.dart';
import '../../../theme/typography.dart';
import '../../formatters/error_labels.dart';
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
    this.asSheet = false,
  });

  final int? categoryId;
  final TransactionType type;
  final bool asSheet;

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
    final colors = context.colors;
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
        if (state.errorMessage != null && !state.notFound) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                localizedLedgrErrorMessage(context.l10n, state.errorMessage!),
              ),
            ),
          );
        }
        final count = state.deletePromptCount;
        if (count == null) return;
        final l10n = context.l10n;
        final confirmed = await showDeleteConfirmDialog(
          context: context,
          title: l10n.deleteCategory,
          message: count == 0
              ? l10n.deleteThisCategory
              : l10n.entriesWillMoveToOther(count),
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
        final form = _form(context, state, colors);
        if (widget.asSheet) {
          return Padding(
            padding: EdgeInsets.only(
              bottom: MediaQuery.viewInsetsOf(context).bottom,
            ),
            child: SizedBox(
              height: MediaQuery.sizeOf(context).height * 0.85,
              child: Material(
                color: colors.paperLight,
                borderRadius: BorderRadius.vertical(top: Radius.circular(16.r)),
                child: form,
              ),
            ),
          );
        }
        return Scaffold(
          appBar: LedgrAppBar(
            title: widget.categoryId == null
                ? context.l10n.newCategory
                : context.l10n.editCategory,
            leading: IconButton(
              tooltip: context.l10n.close,
              onPressed: () => context.pop(),
              icon: Icon(TablerIcons.x, color: colors.onSurface, size: 19.r),
            ),
          ),
          body: form,
        );
      },
    );
  }

  Widget _form(
      BuildContext context, CategoryFormState state, LedgrColors colors) {
    final bloc = context.read<CategoryFormBloc>();
    final l10n = context.l10n;
    if (state.loading) {
      return Center(child: CircularProgressIndicator(color: colors.primary));
    }
    if (state.notFound) {
      return Center(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          child: Text(
            l10n.categoryNotFound,
            textAlign: TextAlign.center,
            style: uiStyle(fontSize: 14, color: colors.secondary),
          ),
        ),
      );
    }
    return Column(
      children: [
        if (widget.asSheet)
          Padding(
            padding: EdgeInsets.fromLTRB(16.w, 12.h, 8.w, 0.h),
            child: Row(
              children: [
                Text(
                  widget.categoryId == null
                      ? l10n.addCategory
                      : l10n.editCategoryTitle,
                  style: amountStyle(fontSize: 20, color: colors.onSurface),
                ),
                const Spacer(),
                IconButton(
                  tooltip: l10n.close,
                  onPressed: () => context.pop(),
                  icon: Icon(TablerIcons.x, color: colors.secondary),
                ),
              ],
            ),
          ),
        Expanded(
          child: ListView(
            padding: EdgeInsets.fromLTRB(20.w, 16.h, 20.w, 16.h),
            children: [
              if (widget.categoryId == null)
                DebitCreditToggle(
                  expenseSelected: state.type == TransactionType.expense,
                  onChanged: (expense) => bloc.add(
                    CategoryFormTypeChanged(
                      expense
                          ? TransactionType.expense
                          : TransactionType.income,
                    ),
                  ),
                ),
              if (widget.categoryId == null) SizedBox(height: 20.h),
              TextField(
                key: const Key('category-name-field'),
                controller: _name,
                enabled: !state.isDefault,
                style: uiStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: colors.onSurface,
                ),
                cursorColor: colors.primary,
                decoration: InputDecoration(
                  hintText: l10n.nameHint,
                  hintStyle: uiStyle(fontSize: 16, color: colors.secondary),
                  border: InputBorder.none,
                ),
                onChanged: (value) => bloc.add(CategoryFormNameChanged(value)),
              ),
              Divider(color: colors.rule, height: 1.h),
              SizedBox(height: 20.h),
              Text(l10n.icon,
                  style: uiStyle(fontSize: 13, color: colors.secondary)),
              SizedBox(height: 12.h),
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: categoryIconChoices.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 6,
                  mainAxisSpacing: 10.h,
                  crossAxisSpacing: 10.w,
                ),
                itemBuilder: (context, index) {
                  final icon = categoryIconChoices[index];
                  final selected = state.iconCodePoint == icon.codePoint;
                  return GestureDetector(
                    onTap: state.isDefault
                        ? null
                        : () =>
                            bloc.add(CategoryFormIconChanged(icon.codePoint)),
                    child: Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: colors.categoryCircleFill,
                        border: selected
                            ? Border.all(color: colors.primary, width: 2.w)
                            : null,
                      ),
                      child: Icon(icon, size: 20.r, color: colors.onSurface),
                    ),
                  );
                },
              ),
              SizedBox(height: 20.h),
              Text(l10n.color,
                  style: uiStyle(fontSize: 13, color: colors.secondary)),
              SizedBox(height: 12.h),
              Wrap(
                spacing: 12.w,
                runSpacing: 12.h,
                children: [
                  for (final color in categoryColorChoices)
                    GestureDetector(
                      onTap: state.isDefault
                          ? null
                          : () => bloc.add(CategoryFormColorChanged(color)),
                      child: Container(
                        width: 28.w,
                        height: 28.h,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Color(color),
                          border: state.colorValue == color
                              ? Border.all(color: colors.primary, width: 2.w)
                              : null,
                        ),
                      ),
                    ),
                ],
              ),
              SizedBox(height: 28.h),
              Center(
                child: CategoryCircle(
                  icon: IconData(
                    state.iconCodePoint,
                    fontFamily: 'tabler-icons',
                    fontPackage: 'flutter_tabler_icons',
                  ),
                  label: state.name.isEmpty ? l10n.preview : state.name,
                  iconColor: Color(state.colorValue),
                  selected: true,
                ),
              ),
              if (widget.categoryId != null && !state.isDefault) ...[
                SizedBox(height: 12.h),
                TextButton(
                  key: const Key('delete-category'),
                  onPressed: () => bloc.add(const CategoryFormDeletePressed()),
                  child: Text(
                    l10n.deleteCategory,
                    style: uiStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: colors.ledgerRed,
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
            padding: EdgeInsets.fromLTRB(20.w, 8.h, 20.w, 20.h),
            child: LedgrPrimaryButton(
              key: const Key('save-category'),
              label: l10n.saveCategory,
              onPressed: state.canSave
                  ? () => bloc.add(const CategoryFormSaveRequested())
                  : null,
            ),
          ),
        ),
      ],
    );
  }
}
