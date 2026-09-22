import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:go_router/go_router.dart';

import '../../../domain/models/transaction_type.dart';
import '../../../l10n/l10n.dart';
import '../../../theme/colors.dart';
import '../../../theme/typography.dart';
import '../../formatters/error_labels.dart';
import '../../widgets/category_choices.dart';
import '../../widgets/dialogs.dart';
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
    final colors = context.colors;
    final media = MediaQuery.of(context);
    final sheetHeight = (media.size.height - media.viewInsets.bottom) * 0.9;
    return Padding(
      padding: EdgeInsets.only(bottom: media.viewInsets.bottom),
      child: Align(
        alignment: Alignment.bottomCenter,
        child: ClipRRect(
          borderRadius: BorderRadius.vertical(top: Radius.circular(28.r)),
          child: SizedBox(
            height: sheetHeight,
            child: ScaffoldMessenger(
              child: Scaffold(
                backgroundColor: colors.paperLight,
                body: BlocConsumer<CategoryFormBloc, CategoryFormState>(
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
                            localizedLedgrErrorMessage(
                                context.l10n, state.errorMessage!),
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
                  builder: (context, state) => _form(context, state, colors),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _form(
    BuildContext context,
    CategoryFormState state,
    LedgrColors colors,
  ) {
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
    final creating = widget.categoryId == null;
    final iconLabel = categoryIconLabel(state.iconCodePoint);
    return Column(
      children: [
        SizedBox(height: 10.h),
        Container(
          width: 40.w,
          height: 4.h,
          decoration: BoxDecoration(
            color: colors.rule,
            borderRadius: BorderRadius.circular(99.r),
          ),
        ),
        Padding(
          padding: EdgeInsets.fromLTRB(20.w, 12.h, 8.w, 4.h),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  creating ? l10n.newCategory : l10n.editCategoryTitle,
                  style: amountStyle(fontSize: 26, color: colors.onSurface),
                ),
              ),
              IconButton(
                tooltip: l10n.close,
                onPressed: () => context.pop(),
                icon: Icon(TablerIcons.x, color: colors.secondary, size: 22.r),
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView(
            padding: EdgeInsets.fromLTRB(20.w, 8.h, 20.w, 16.h),
            children: [
              if (creating) ...[
                _SectionLabel(l10n.accountType),
                SizedBox(height: 10.h),
                _AccountTypeToggle(
                  expenseSelected: state.type == TransactionType.expense,
                  onChanged: (expense) => bloc.add(
                    CategoryFormTypeChanged(
                      expense
                          ? TransactionType.expense
                          : TransactionType.income,
                    ),
                  ),
                ),
                SizedBox(height: 22.h),
              ],
              _SectionLabel(l10n.categoryName),
              SizedBox(height: 10.h),
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
                  hintStyle: uiStyle(fontSize: 15, color: colors.secondary),
                  filled: true,
                  fillColor: colors.surfaceContainerLowest,
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 16.w,
                    vertical: 14.h,
                  ),
                  border: _nameBorder(colors.rule),
                  enabledBorder: _nameBorder(colors.rule),
                  focusedBorder: _nameBorder(colors.primary),
                  disabledBorder: _nameBorder(colors.rule),
                ),
                onChanged: (value) => bloc.add(CategoryFormNameChanged(value)),
              ),
              SizedBox(height: 22.h),
              Row(
                children: [
                  Expanded(child: _SectionLabel(l10n.categoryIcon)),
                  if (iconLabel != null)
                    Text(
                      iconLabel,
                      style: uiStyle(fontSize: 13, color: colors.secondary),
                    ),
                ],
              ),
              SizedBox(height: 12.h),
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: categoryIconChoices.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 5,
                  mainAxisSpacing: 12.h,
                  crossAxisSpacing: 12.w,
                ),
                itemBuilder: (context, index) {
                  final choice = categoryIconChoices[index];
                  final selected = state.iconCodePoint == choice.icon.codePoint;
                  return GestureDetector(
                    onTap: state.isDefault
                        ? null
                        : () => bloc.add(
                              CategoryFormIconChanged(choice.icon.codePoint),
                            ),
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: selected
                            ? colors.primary
                            : colors.surfaceContainerLowest,
                        border: selected
                            ? null
                            : Border.all(color: colors.rule, width: 1.w),
                      ),
                      child: Icon(
                        choice.icon,
                        size: 22.r,
                        color: selected ? colors.onPrimary : colors.secondary,
                      ),
                    ),
                  );
                },
              ),
              SizedBox(height: 22.h),
              _SectionLabel(l10n.colorTone),
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
                        width: 36.r,
                        height: 36.r,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Color(color),
                        ),
                        child: state.colorValue == color
                            ? Icon(
                                TablerIcons.check,
                                size: 18.r,
                                color: Colors.white,
                              )
                            : null,
                      ),
                    ),
                ],
              ),
              if (widget.categoryId != null && !state.isDefault) ...[
                SizedBox(height: 8.h),
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
            padding: EdgeInsets.fromLTRB(20.w, 8.h, 20.w, 16.h),
            child: SizedBox(
              width: double.infinity,
              height: 52.h,
              child: FilledButton.icon(
                key: const Key('save-category'),
                onPressed: state.canSave
                    ? () => bloc.add(const CategoryFormSaveRequested())
                    : null,
                style: FilledButton.styleFrom(
                  backgroundColor: colors.primary,
                  disabledBackgroundColor:
                      colors.primary.withValues(alpha: 0.4),
                  foregroundColor: colors.onPrimary,
                  disabledForegroundColor:
                      colors.onPrimary.withValues(alpha: 0.8),
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14.r),
                  ),
                ),
                icon: Icon(TablerIcons.plus, size: 18.r),
                label: Text(
                  creating ? l10n.addCategory : l10n.saveCategory,
                  style: uiStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: colors.onPrimary,
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  OutlineInputBorder _nameBorder(Color color) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(14.r),
      borderSide: BorderSide(color: color),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  const _SectionLabel(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text.toUpperCase(),
      style: uiStyle(
        fontSize: 11,
        fontWeight: FontWeight.w600,
        color: context.colors.secondary,
        letterSpacing: ltrLetterSpacing(context, 1.1),
      ),
    );
  }
}

class _AccountTypeToggle extends StatelessWidget {
  const _AccountTypeToggle({
    required this.expenseSelected,
    required this.onChanged,
  });

  final bool expenseSelected;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final l10n = context.l10n;
    return Container(
      padding: EdgeInsets.all(4.r),
      decoration: BoxDecoration(
        color: colors.surfaceContainerHigh,
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Row(
        children: [
          Expanded(
            child: _TypeChip(
              selected: expenseSelected,
              icon: TablerIcons.arrow_down,
              accent: colors.ledgerRed,
              label: l10n.expenseDebit,
              onTap: () => onChanged(true),
            ),
          ),
          Expanded(
            child: _TypeChip(
              selected: !expenseSelected,
              icon: TablerIcons.arrow_up,
              accent: colors.ledgerGreen,
              label: l10n.incomeCredit,
              onTap: () => onChanged(false),
            ),
          ),
        ],
      ),
    );
  }
}

class _TypeChip extends StatelessWidget {
  const _TypeChip({
    required this.selected,
    required this.icon,
    required this.accent,
    required this.label,
    required this.onTap,
  });

  final bool selected;
  final IconData icon;
  final Color accent;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: EdgeInsets.symmetric(vertical: 12.h),
        decoration: BoxDecoration(
          color: selected ? colors.surfaceContainerLowest : Colors.transparent,
          borderRadius: BorderRadius.circular(12.r),
          boxShadow: selected
              ? [
                  BoxShadow(
                    color: colors.onSurface.withValues(alpha: 0.06),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ]
              : null,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 16.r, color: selected ? accent : colors.secondary),
            SizedBox(width: 6.w),
            Flexible(
              child: Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: uiStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: selected ? accent : colors.secondary,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
