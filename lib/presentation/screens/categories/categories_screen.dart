import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../domain/models/transaction_type.dart';
import '../../../l10n/l10n.dart';
import '../../../theme/colors.dart';
import '../../../theme/typography.dart';
import '../../widgets/category_card.dart';
import '../../widgets/debit_credit_toggle.dart';
import 'bloc/categories_bloc.dart';
import 'bloc/categories_event.dart';
import 'bloc/categories_state.dart';

class CategoriesScreen extends StatelessWidget {
  const CategoriesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return BlocBuilder<CategoriesBloc, CategoriesState>(
      builder: (context, state) {
        final debitSelected = state.type == TransactionType.expense;
        final l10n = context.l10n;
        return Column(
          children: [
            Container(
              width: double.infinity,
              color: colors.primary,
              padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 16.h),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          l10n.categoriesTitle,
                          style: amountStyle(
                              fontSize: 24, color: colors.onPrimary),
                        ),
                        Text(
                          l10n.ledgerNomenclature,
                          style: uiStyle(
                            fontSize: 10,
                            color: colors.onPrimary.withValues(alpha: 0.8),
                            letterSpacing: ltrLetterSpacing(context, 1.0),
                          ),
                        ),
                      ],
                    ),
                  ),
                  FilledButton.icon(
                    key: const Key('add-category-cell'),
                    onPressed: () => context.push(
                      '/categories/new?type=${state.type.name}',
                    ),
                    icon: Icon(TablerIcons.plus, size: 16.r),
                    label: Text(l10n.add),
                    style: FilledButton.styleFrom(
                      backgroundColor: colors.primaryContainer,
                      foregroundColor: colors.onPrimary,
                      visualDensity: VisualDensity.compact,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 8.h),
              child: FilterSegmentedControl(
                labels: [
                  l10n.debitCategories(
                    debitSelected ? '${state.categories.length}' : '…',
                  ),
                  l10n.creditCategories(
                    debitSelected ? '…' : '${state.categories.length}',
                  ),
                ],
                selectedIndex: debitSelected ? 0 : 1,
                onSelected: (i) {
                  context.read<CategoriesBloc>().add(
                        CategoriesTypeChanged(
                          i == 0
                              ? TransactionType.expense
                              : TransactionType.income,
                        ),
                      );
                },
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(16.w, 0.h, 16.w, 8.h),
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: colors.paperLight,
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: IntrinsicHeight(
                  child: Row(
                    children: [
                      Container(
                        width: 3.w,
                        decoration: BoxDecoration(
                          color: colors.ledgerRed,
                          borderRadius: BorderRadiusDirectional.only(
                            topStart: Radius.circular(8.r),
                            bottomStart: Radius.circular(8.r),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.fromLTRB(12.w, 10.h, 12.w, 10.h),
                          child: Row(
                            children: [
                              Icon(
                                TablerIcons.shield_check,
                                size: 18.r,
                                color: colors.ledgerRed,
                              ),
                              SizedBox(width: 8.w),
                              Expanded(
                                child: Text(
                                  l10n.defaultCategoriesProtected,
                                  style: uiStyle(
                                    fontSize: 12,
                                    color: colors.secondary,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Expanded(
              child: state.loading
                  ? Center(
                      child: CircularProgressIndicator(color: colors.primary))
                  : LayoutBuilder(
                      builder: (context, constraints) {
                        const gap = 10.0;
                        final width = (constraints.maxWidth - 32 - gap) / 2;
                        return SingleChildScrollView(
                          padding: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 96.h),
                          child: Wrap(
                            spacing: gap,
                            runSpacing: gap,
                            children: [
                              for (final category in state.categories)
                                SizedBox(
                                  width: width,
                                  child: CategoryCard(
                                    key: Key(
                                      'manage-category-${category.name}',
                                    ),
                                    category: category,
                                    onTap: category.isDefault
                                        ? null
                                        : () => context.push(
                                              '/categories/${category.id}',
                                            ),
                                  ),
                                ),
                            ],
                          ),
                        );
                      },
                    ),
            ),
          ],
        );
      },
    );
  }
}
