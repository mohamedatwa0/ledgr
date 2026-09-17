import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:go_router/go_router.dart';

import '../../../domain/models/transaction_entry.dart';
import '../../../theme/colors.dart';
import '../../../theme/typography.dart';
import '../../formatters/date_labels.dart';
import '../../widgets/balance_card.dart';
import '../../widgets/ledgr_app_bar.dart';
import '../../widgets/ledgr_empty_state.dart';
import '../../widgets/ruled_transaction_row.dart';
import 'bloc/home_bloc.dart';
import 'bloc/home_event.dart';
import 'bloc/home_state.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: LedgrAppBar(
        title: 'Ledgr',
        serifTitle: true,
        actions: [
          IconButton(
            key: const Key('settings-button'),
            tooltip: 'Settings',
            onPressed: () => context.push('/settings'),
            icon: const Icon(TablerIcons.settings, color: paper, size: 19),
          ),
        ],
      ),
      floatingActionButton: SizedBox(
        width: 52,
        height: 52,
        child: FloatingActionButton(
          key: const Key('add-transaction-fab'),
          tooltip: 'New entry',
          onPressed: () => context.push('/transaction/new'),
          child: const Icon(TablerIcons.plus, size: 22),
        ),
      ),
      body: BlocBuilder<HomeBloc, HomeState>(
        builder: (context, state) {
          if (state.loading) {
            return const Center(
              child: CircularProgressIndicator(color: tealAccent),
            );
          }
          final items = state.entries;
          return ListView(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 88),
            children: [
              BalanceCard(
                balance: state.summary.balance,
                credits: state.summary.credits,
                debits: state.summary.debits,
                currencyCode: state.currencyCode,
                month: state.month,
                canGoForward: !state.isCurrentMonth,
                onPreviousMonth: () {
                  context.read<HomeBloc>().add(
                        HomeMonthChanged(
                          DateTime(state.month.year, state.month.month - 1),
                        ),
                      );
                },
                onNextMonth: () {
                  context.read<HomeBloc>().add(
                        HomeMonthChanged(
                          DateTime(state.month.year, state.month.month + 1),
                        ),
                      );
                },
              ),
              if (items.isEmpty)
                const LedgrEmptyState(
                  message: 'No transactions yet — tap + to add your first one',
                )
              else ...[
                Row(
                  children: [
                    const Spacer(),
                    TextButton(
                      key: const Key('see-all'),
                      onPressed: () => context.push('/history'),
                      child: Text(
                        'See all',
                        style: uiStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          color: tealAccent,
                        ),
                      ),
                    ),
                  ],
                ),
                ..._groupedRows(context, items),
              ],
            ],
          );
        },
      ),
    );
  }

  List<Widget> _groupedRows(
    BuildContext context,
    List<TransactionEntry> items,
  ) {
    final groups = groupByDate(items, (e) => e.transaction.date);
    final widgets = <Widget>[];
    for (final group in groups) {
      widgets.add(
        Padding(
          padding: EdgeInsets.only(bottom: 8, top: widgets.isEmpty ? 0 : 14),
          child: Text(group.label, style: uiStyle(fontSize: 13, color: mutedInk)),
        ),
      );
      for (var i = 0; i < group.items.length; i++) {
        final entry = group.items[i];
        widgets.add(
          RuledTransactionRow(
            entry: entry,
            showDivider: i != group.items.length - 1,
            onTap: () => context.push('/transaction/${entry.transaction.id}'),
          ),
        );
      }
    }
    return widgets;
  }
}
