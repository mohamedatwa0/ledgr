import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:go_router/go_router.dart';

import '../../../domain/models/transaction_entry.dart';
import '../../../theme/colors.dart';
import '../../../theme/typography.dart';
import '../../formatters/date_labels.dart';
import '../../widgets/debit_credit_toggle.dart';
import '../../widgets/dialogs.dart';
import '../../widgets/ledgr_app_bar.dart';
import '../../widgets/ledgr_empty_state.dart';
import '../../widgets/ruled_transaction_row.dart';
import 'bloc/history_bloc.dart';
import 'bloc/history_event.dart';
import 'bloc/history_state.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: LedgrAppBar(
        title: 'History',
        leading: IconButton(
          tooltip: 'Back',
          onPressed: () => context.pop(),
          icon: const Icon(TablerIcons.chevron_left, color: paper, size: 20),
        ),
      ),
      body: BlocBuilder<HistoryBloc, HistoryState>(
        builder: (context, state) {
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
                child: FilterSegmentedControl(
                  labels: const ['All', 'Credit', 'Debit'],
                  selectedIndex: state.filter.index,
                  onSelected: (i) {
                    context.read<HistoryBloc>().add(
                          HistoryFilterChanged(HistoryFilter.values[i]),
                        );
                  },
                ),
              ),
              Expanded(
                child: state.loading
                    ? const Center(
                        child: CircularProgressIndicator(color: tealAccent),
                      )
                    : state.entries.isEmpty
                        ? const LedgrEmptyState(
                            message: 'No transactions in this view',
                          )
                        : ListView(
                            padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
                            children: _groupedRows(context, state.entries),
                          ),
              ),
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
          Dismissible(
            key: ValueKey(entry.transaction.id),
            direction: DismissDirection.endToStart,
            background: Container(
              alignment: Alignment.centerRight,
              color: ledgerRed,
              padding: const EdgeInsets.only(right: 16),
              child: const Icon(TablerIcons.trash, color: paper, size: 20),
            ),
            confirmDismiss: (_) {
              return showDeleteConfirmDialog(
                context: context,
                title: 'Delete entry',
                message: 'Remove this transaction from the ledger?',
              );
            },
            onDismissed: (_) {
              context
                  .read<HistoryBloc>()
                  .add(HistoryDeleteRequested(entry.transaction.id));
            },
            child: RuledTransactionRow(
              entry: entry,
              showDivider: i != group.items.length - 1,
              onTap: () => context.push('/transaction/${entry.transaction.id}'),
            ),
          ),
        );
      }
    }
    return widgets;
  }
}
