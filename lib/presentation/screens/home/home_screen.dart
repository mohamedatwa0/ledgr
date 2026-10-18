import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../domain/models/transaction_entry.dart';
import '../../../l10n/l10n.dart';
import '../../../theme/colors.dart';
import '../../../theme/typography.dart';
import '../../formatters/date_labels.dart';
import '../../widgets/balance_card.dart';
import '../../widgets/daily_outlay_ribbon.dart';
import '../../widgets/entry_deleted_snackbar.dart';
import '../../widgets/ledgr_empty_state.dart';
import '../../widgets/ruled_transaction_row.dart';
import 'bloc/home_bloc.dart';
import 'bloc/home_event.dart';
import 'bloc/home_state.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return BlocConsumer<HomeBloc, HomeState>(
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
                .read<HomeBloc>()
                .add(const HomeUndoDeleteRequested()),
          );
        }
      },
      builder: (context, state) {
        if (state.loading) {
          return Center(
            child: CircularProgressIndicator(color: colors.primary),
          );
        }
        final items = state.entries;
        final l10n = context.l10n;
        final groups =
            groupByDate(items, (e) => e.transaction.date, l10n: l10n);
        final rows = <Object>[];
        for (final group in groups) {
          rows.add(group);
          rows.addAll(group.items);
        }
        final prefix = items.isEmpty ? 4 : 4;
        return ListView.builder(
          padding: EdgeInsets.fromLTRB(0.w, 16.h, 0.w, 96.h),
          itemCount: prefix + (items.isEmpty ? 0 : rows.length),
          itemBuilder: (context, index) {
            if (index == 0) {
              return BalanceCard(
                balance: state.summary.balance,
                credits: state.summary.credits,
                debits: state.summary.debits,
                creditCount: state.summary.creditCount,
                debitCount: state.summary.debitCount,
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
              );
            }
            if (index == 1) {
              return DailyOutlayRibbon(
                entries: items,
                month: state.month,
                currencyCode: state.currencyCode,
              );
            }
            if (index == 2) return SizedBox(height: 24.h);
            if (index == 3) {
              if (items.isEmpty) {
                return Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  child: LedgrEmptyState(
                    message: l10n.emptyHomeTransactions,
                  ),
                );
              }
              return Container(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
                color: colors.surfaceContainerHigh,
                child: Row(
                  children: [
                    Text(
                      l10n.ledgerEntries,
                      style: uiStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: colors.secondary,
                        letterSpacing: ltrLetterSpacing(context, 1.0),
                      ),
                    ),
                    const Spacer(),
                    Text(
                      l10n.postingsCount(items.length),
                      style: uiStyle(
                        fontSize: 10,
                        color: colors.secondary,
                        letterSpacing: ltrLetterSpacing(context, 1.0),
                      ),
                    ),
                  ],
                ),
              );
            }
            final item = rows[index - prefix];
            if (item is DateGrouped<TransactionEntry>) {
              final stamp = DateFormat('MMM d', l10n.localeName)
                  .format(item.items.first.transaction.date);
              return Container(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                color: colors.surfaceContainerLow,
                child: Row(
                  children: [
                    Text(
                      item.label,
                      style: uiStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: colors.onSurface,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      latinUppercase(context, stamp),
                      style: uiStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w500,
                        color: colors.secondary,
                        letterSpacing: ltrLetterSpacing(context, 0.8),
                      ),
                    ),
                  ],
                ),
              );
            }
            final entry = item as TransactionEntry;
            return RuledTransactionRow(
              entry: entry,
              showDivider: true,
              showTime: false,
              onTap: () => context.push('/transaction/${entry.transaction.id}'),
              onDelete: () {
                context
                    .read<HomeBloc>()
                    .add(HomeDeleteRequested(entry.transaction.id));
              },
            );
          },
        );
      },
    );
  }
}
