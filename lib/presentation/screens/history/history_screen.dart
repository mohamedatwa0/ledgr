import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../domain/models/transaction_entry.dart';
import '../../../l10n/l10n.dart';
import '../../../theme/colors.dart';
import '../../../theme/typography.dart';
import '../../formatters/date_labels.dart';
import '../../widgets/debit_credit_toggle.dart';
import '../../widgets/directional_icon.dart';
import '../../widgets/entry_deleted_snackbar.dart';
import '../../widgets/ledgr_empty_state.dart';
import '../../widgets/ruled_transaction_row.dart';
import 'bloc/history_bloc.dart';
import 'bloc/history_event.dart';
import 'bloc/history_state.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return BlocConsumer<HistoryBloc, HistoryState>(
      listenWhen: (previous, current) =>
          current.undoEntry != previous.undoEntry ||
          current.errorMessage != previous.errorMessage,
      listener: (context, state) {
        if (state.errorMessage != null) {
          showLedgerErrorSnackBar(context, state.errorMessage!);
        }
        if (state.undoEntry != null) {
          showEntryDeletedSnackBar(
            context,
            onUndo: () => context
                .read<HistoryBloc>()
                .add(const HistoryUndoDeleteRequested()),
          );
        }
      },
      builder: (context, state) {
        final visible = state.visibleFor(context.l10n);
        final l10n = context.l10n;
        final groups =
            groupByDate(visible, (e) => e.transaction.date, l10n: l10n);
        final rows = <Object>[];
        for (final group in groups) {
          rows.add(group);
          rows.addAll(group.items);
        }
        return Column(
          children: [
            Container(
              color: colors.surfaceContainerLow,
              padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 12.h),
              child: Column(
                children: [
                  TextField(
                    key: const Key('history-search'),
                    onChanged: (value) => context
                        .read<HistoryBloc>()
                        .add(HistoryQueryChanged(value)),
                    style: uiStyle(fontSize: 14, color: colors.onSurface),
                    cursorColor: colors.primary,
                    decoration: InputDecoration(
                      hintText: l10n.searchHint,
                      hintStyle: uiStyle(fontSize: 12, color: colors.outline),
                      prefixIcon: Icon(
                        TablerIcons.search,
                        size: 20.r,
                        color: colors.secondary,
                      ),
                      filled: true,
                      fillColor: colors.paperLight,
                      contentPadding: EdgeInsets.symmetric(horizontal: 12.w),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.r),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                  SizedBox(height: 10.h),
                  FilterSegmentedControl(
                    labels: [
                      l10n.filterAllRecords,
                      l10n.filterDebitsOut,
                      l10n.filterCreditsIn,
                    ],
                    selectedIndex: _filterIndex(state.filter),
                    onSelected: (i) {
                      context.read<HistoryBloc>().add(
                            HistoryFilterChanged(_filterFromIndex(i)),
                          );
                    },
                  ),
                ],
              ),
            ),
            Container(
              color: colors.paperLight,
              padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 6.h),
              child: Row(
                children: [
                  IconButton(
                    key: const Key('history-previous-month'),
                    tooltip: l10n.previousMonth,
                    visualDensity: VisualDensity.compact,
                    onPressed: () {
                      context.read<HistoryBloc>().add(
                            HistoryMonthChanged(
                              DateTime(
                                state.month.year,
                                state.month.month - 1,
                              ),
                            ),
                          );
                    },
                    icon: DirectionalIcon(
                      TablerIcons.chevron_left,
                      size: 16.r,
                      color: colors.secondary,
                    ),
                  ),
                  Icon(
                    TablerIcons.calendar,
                    size: 20.r,
                    color: colors.primaryContainer,
                  ),
                  SizedBox(width: 6.w),
                  Expanded(
                    child: Text(
                      DateFormat('MMMM y', l10n.localeName).format(state.month),
                      key: const Key('history-month-label'),
                      style: uiStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: colors.onSurface,
                      ),
                    ),
                  ),
                  Text(
                    l10n.entriesCount(visible.length),
                    style: uiStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                      color: colors.secondary,
                      letterSpacing: ltrLetterSpacing(context, 0.8),
                    ),
                  ),
                  IconButton(
                    key: const Key('history-next-month'),
                    tooltip: l10n.nextMonth,
                    visualDensity: VisualDensity.compact,
                    onPressed: state.isCurrentMonth
                        ? null
                        : () {
                            context.read<HistoryBloc>().add(
                                  HistoryMonthChanged(
                                    DateTime(
                                      state.month.year,
                                      state.month.month + 1,
                                    ),
                                  ),
                                );
                          },
                    icon: DirectionalIcon(
                      TablerIcons.chevron_right,
                      size: 16.r,
                      color: state.isCurrentMonth
                          ? colors.secondary.withValues(alpha: 0.35)
                          : colors.secondary,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: state.loading
                  ? Center(
                      child: CircularProgressIndicator(color: colors.primary),
                    )
                  : visible.isEmpty
                      ? LedgrEmptyState(
                          message: l10n.emptyHistory,
                        )
                      : Stack(
                          children: [
                            PositionedDirectional(
                              start: 24,
                              top: 0,
                              bottom: 0,
                              child: Container(
                                width: 3.w,
                                color: colors.ledgerRed.withValues(alpha: 0.9),
                              ),
                            ),
                            ListView.builder(
                              key: const Key('history-scroll'),
                              padding: EdgeInsets.fromLTRB(0.w, 0.h, 0.w, 96.h),
                              itemCount: rows.length,
                              itemBuilder: (context, index) =>
                                  _historyRow(context, rows[index]),
                            ),
                          ],
                        ),
            ),
          ],
        );
      },
    );
  }

  int _filterIndex(HistoryFilter filter) {
    switch (filter) {
      case HistoryFilter.all:
        return 0;
      case HistoryFilter.debit:
        return 1;
      case HistoryFilter.credit:
        return 2;
    }
  }

  HistoryFilter _filterFromIndex(int index) {
    switch (index) {
      case 1:
        return HistoryFilter.debit;
      case 2:
        return HistoryFilter.credit;
      default:
        return HistoryFilter.all;
    }
  }

  Widget _historyRow(BuildContext context, Object row) {
    final colors = context.colors;
    final l10n = context.l10n;
    if (row is DateGrouped<TransactionEntry>) {
      return Container(
        padding: EdgeInsetsDirectional.fromSTEB(40.w, 8.h, 16.w, 8.h),
        color: colors.surfaceContainerLow.withValues(alpha: 0.6),
        child: Row(
          children: [
            Text(
              latinUppercase(context, row.label),
              style: uiStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: colors.secondary,
                letterSpacing: ltrLetterSpacing(context, 1.2),
              ),
            ),
            const Spacer(),
            Text(
              l10n.postItemsCount(row.items.length),
              style: uiStyle(fontSize: 10, color: colors.outline),
            ),
          ],
        ),
      );
    }
    final entry = row as TransactionEntry;
    return RuledTransactionRow(
      entry: entry,
      showDivider: true,
      leadingInset: 24,
      onTap: () => context.push('/transaction/${entry.transaction.id}'),
      onDelete: () {
        context
            .read<HistoryBloc>()
            .add(HistoryDeleteRequested(entry.transaction.id));
      },
    );
  }
}
