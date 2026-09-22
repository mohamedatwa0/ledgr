import 'package:intl/intl.dart';

import '../../domain/date_utils.dart';
import '../../l10n/app_localizations.dart';

String dateGroupLabel(
  DateTime date, {
  DateTime? now,
  required AppLocalizations l10n,
}) {
  final day = dateOnly(date);
  final today = dateOnly(now ?? DateTime.now());
  final yesterday = today.subtract(const Duration(days: 1));
  if (day == today) return l10n.today;
  if (day == yesterday) return l10n.yesterday;
  if (day.year == today.year) {
    return DateFormat('MMM d', l10n.localeName).format(day);
  }
  return DateFormat('MMM d, y', l10n.localeName).format(day);
}

String formatLedgerDate(
  DateTime date, {
  DateTime? now,
  required AppLocalizations l10n,
}) {
  final day = dateOnly(date);
  final today = dateOnly(now ?? DateTime.now());
  final formatted = DateFormat('MMM d', l10n.localeName).format(day);
  if (day == today) return l10n.todayWithDate(formatted);
  final yesterday = today.subtract(const Duration(days: 1));
  if (day == yesterday) return l10n.yesterdayWithDate(formatted);
  return DateFormat('MMM d, y', l10n.localeName).format(day);
}

String monthPageLabel(
  DateTime month, {
  DateTime? now,
  required AppLocalizations l10n,
}) {
  final current = monthStart(now ?? DateTime.now());
  final page = monthStart(month);
  if (isSameMonth(page, current)) return l10n.thisMonthLabel;
  return DateFormat('MMM y', l10n.localeName).format(page);
}

List<DateGrouped<T>> groupByDate<T>(
  List<T> items,
  DateTime Function(T item) dateOf, {
  DateTime? now,
  required AppLocalizations l10n,
}) {
  final groups = <DateTime, List<T>>{};
  final order = <DateTime>[];
  for (final item in items) {
    final key = dateOnly(dateOf(item));
    if (!groups.containsKey(key)) {
      order.add(key);
      groups[key] = [];
    }
    groups[key]!.add(item);
  }
  return [
    for (final key in order)
      DateGrouped(
        label: dateGroupLabel(key, now: now, l10n: l10n),
        items: groups[key]!,
      ),
  ];
}

class DateGrouped<T> {
  const DateGrouped({required this.label, required this.items});

  final String label;
  final List<T> items;
}
