import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:go_router/go_router.dart';

import '../../../domain/models/transaction_type.dart';
import '../../../theme/colors.dart';
import '../../icons/tabler_icon.dart';
import '../../widgets/category_circle.dart';
import '../../widgets/debit_credit_toggle.dart';
import '../../widgets/ledgr_app_bar.dart';
import 'bloc/categories_bloc.dart';
import 'bloc/categories_event.dart';
import 'bloc/categories_state.dart';

class CategoriesScreen extends StatelessWidget {
  const CategoriesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: LedgrAppBar(
        title: 'Categories',
        leading: IconButton(
          tooltip: 'Back',
          onPressed: () => context.pop(),
          icon: const Icon(TablerIcons.chevron_left, color: paper, size: 20),
        ),
      ),
      body: BlocBuilder<CategoriesBloc, CategoriesState>(
        builder: (context, state) {
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
                child: DebitCreditToggle(
                  expenseSelected: state.type == TransactionType.expense,
                  onChanged: (expense) {
                    context.read<CategoriesBloc>().add(
                          CategoriesTypeChanged(
                            expense
                                ? TransactionType.expense
                                : TransactionType.income,
                          ),
                        );
                  },
                ),
              ),
              Expanded(
                child: state.loading
                    ? const Center(
                        child: CircularProgressIndicator(color: tealAccent),
                      )
                    : GridView.builder(
                        padding: const EdgeInsets.fromLTRB(20, 12, 20, 32),
                        itemCount: state.categories.length + 1,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          mainAxisSpacing: 16,
                          crossAxisSpacing: 16,
                          childAspectRatio: 0.85,
                        ),
                        itemBuilder: (context, index) {
                          if (index == state.categories.length) {
                            return CategoryCircle(
                              key: const Key('add-category-cell'),
                              icon: TablerIcons.plus,
                              label: 'Add category',
                              onTap: () => context.push(
                                '/categories/new?type=${state.type.name}',
                              ),
                            );
                          }
                          final category = state.categories[index];
                          return CategoryCircle(
                            key: Key('manage-category-${category.name}'),
                            icon: tablerIcon(category.iconCodePoint),
                            label: category.name,
                            iconColor: Color(category.colorValue),
                            onTap: category.isDefault
                                ? null
                                : () =>
                                    context.push('/categories/${category.id}'),
                          );
                        },
                      ),
              ),
            ],
          );
        },
      ),
    );
  }
}
