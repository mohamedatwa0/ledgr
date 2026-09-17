import 'package:intl/intl.dart';

import '../../domain/date_utils.dart';

String dateGroupLabel(DateTime date, {DateTime? now}) {
  final day = dateOnly(date);
  final today = dateOnly(now ?? DateTime.now());
  final yesterday = today.subtract(const Duration(days: 1));
  if (day == today) return 'Today';
  if (day == yesterday) return 'Yesterday';
  if (day.year == today.year) return DateFormat('MMM d').format(day);
  return DateFormat('MMM d, y').format(day);
}

String formatLedgerDate(DateTime date, {DateTime? now}) {
  final day = dateOnly(date);
  final today = dateOnly(now ?? DateTime.now());
  final formatted = DateFormat('MMM d').format(day);
  if (day == today) return 'Today, $formatted';
  final yesterday = today.subtract(const Duration(days: 1));
  if (day == yesterday) return 'Yesterday, $formatted';
  return DateFormat('MMM d, y').format(day);
}

String monthPageLabel(DateTime month, {DateTime? now}) {
  final current = monthStart(now ?? DateTime.now());
  final page = monthStart(month);
  if (isSameMonth(page, current)) return 'This month';
  return DateFormat('MMM y').format(page);
}

List<DateGrouped<T>> groupByDate<T>(
  List<T> items,
  DateTime Function(T item) dateOf, {
  DateTime? now,
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
        label: dateGroupLabel(key, now: now),
        items: groups[key]!,
      ),
  ];
}

class DateGrouped<T> {
  const DateGrouped({required this.label, required this.items});

  final String label;
  final List<T> items;
}
