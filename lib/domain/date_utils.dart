DateTime dateOnly(DateTime date) => DateTime(date.year, date.month, date.day);

DateTime monthStart(DateTime date) => DateTime(date.year, date.month);

DateTime monthEndExclusive(DateTime date) => DateTime(date.year, date.month + 1);

bool isSameMonth(DateTime a, DateTime b) =>
    a.year == b.year && a.month == b.month;

/// Parses a user-typed amount (`45`, `45.00`, `45,00`) into integer minor units.
///
/// Uses half-away-from-zero rounding: `45.005` → `4501`.
int? parseMinorUnits(String text) {
  final normalized = text.trim().replaceAll(',', '.');
  if (normalized.isEmpty) return null;
  final value = double.tryParse(normalized);
  if (value == null) return null;
  return (value * 100).round();
}

double minorToDecimal(int minor) => minor / 100.0;

String minorToInput(int minor) => minorToDecimal(minor).toStringAsFixed(2);
