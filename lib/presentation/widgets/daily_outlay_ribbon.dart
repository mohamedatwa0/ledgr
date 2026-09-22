import 'package:flutter/material.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../domain/date_utils.dart';
import '../../domain/models/transaction_entry.dart';
import '../../domain/models/transaction_type.dart';
import '../../l10n/l10n.dart';
import '../../theme/colors.dart';
import '../../theme/typography.dart';
import '../formatters/currencies.dart';
import '../formatters/money_format.dart';

class DailyOutlayRibbon extends StatelessWidget {
  const DailyOutlayRibbon({
    super.key,
    required this.entries,
    required this.month,
    required this.currencyCode,
  });

  final List<TransactionEntry> entries;
  final DateTime month;
  final String currencyCode;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final l10n = context.l10n;
    final bars = _dailyDebits(entries, month);
    final days = _daysElapsed(month);
    final totalDebits = entries
        .where((e) => e.transaction.type == TransactionType.expense)
        .fold<int>(0, (sum, e) => sum + e.transaction.amount);
    final average = days == 0 ? 0 : totalDebits ~/ days;
    final symbol = currencyByCode(currencyCode).symbol;
    final maxBar = bars.fold<int>(0, (m, v) => v > m ? v : m);

    return Padding(
      padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 0.h),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: colors.surfaceContainer,
          border: Border.all(color: colors.rule),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
          child: Row(
            children: [
              Container(
                width: 28.w,
                height: 28.h,
                decoration: BoxDecoration(
                  color: colors.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(4.r),
                ),
                child: Icon(
                  TablerIcons.chart_bar,
                  size: 16.r,
                  color: colors.primary,
                ),
              ),
              SizedBox(width: 8.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.dailyOutlayPace,
                      style: uiStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: colors.onSurface,
                      ),
                    ),
                    Text(
                      l10n.perDayAverage(symbol, formatSubtotal(average)),
                      style: uiStyle(fontSize: 12, color: colors.secondary),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 28.h,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    for (var i = 0; i < bars.length; i++) ...[
                      if (i > 0) SizedBox(width: 4.w),
                      _Bar(
                        value: bars[i],
                        max: maxBar,
                        highlight: i == bars.length - 1,
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Bar extends StatelessWidget {
  const _Bar({
    required this.value,
    required this.max,
    required this.highlight,
  });

  final int value;
  final int max;
  final bool highlight;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final t = max <= 0 ? 0.15 : (value / max).clamp(0.15, 1.0);
    return Container(
      width: 6.w,
      height: 28.h * t,
      decoration: BoxDecoration(
        color: highlight ? colors.primary : colors.secondaryContainer,
        borderRadius: BorderRadius.circular(1.r),
      ),
    );
  }
}

List<int> _dailyDebits(List<TransactionEntry> entries, DateTime month) {
  final start = monthStart(month);
  final today = dateOnly(DateTime.now());
  final end = isSameMonth(month, today)
      ? today
      : monthEndExclusive(month).subtract(const Duration(days: 1));
  final from = end.subtract(const Duration(days: 6));
  final first = from.isBefore(start) ? start : from;
  final totals = List<int>.filled(7, 0);
  for (final entry in entries) {
    if (entry.transaction.type != TransactionType.expense) continue;
    final day = dateOnly(entry.transaction.date);
    final index = day.difference(first).inDays;
    if (index >= 0 && index < 7) {
      totals[index] += entry.transaction.amount;
    }
  }
  return totals;
}

int _daysElapsed(DateTime month) {
  final today = dateOnly(DateTime.now());
  if (isSameMonth(month, today)) return today.day;
  return DateTime(month.year, month.month + 1, 0).day;
}
