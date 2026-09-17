import '../date_utils.dart';

/// Parses `dd/MM/yyyy`, `dd-MM-yyyy`, and `yyyy-MM-dd`. Returns date-only.
DateTime? parseSmsDate(String raw) {
  final text = raw.trim();
  final iso = RegExp(r'^(\d{4})-(\d{1,2})-(\d{1,2})$').firstMatch(text);
  if (iso != null) {
    return _ymd(iso.group(1)!, iso.group(2)!, iso.group(3)!);
  }
  final dmy = RegExp(r'^(\d{1,2})[/-](\d{1,2})[/-](\d{2,4})$').firstMatch(text);
  if (dmy != null) {
    return _ymd(dmy.group(3)!, dmy.group(2)!, dmy.group(1)!);
  }
  return null;
}

DateTime? _ymd(String yearRaw, String monthRaw, String dayRaw) {
  var year = int.tryParse(yearRaw);
  final month = int.tryParse(monthRaw);
  final day = int.tryParse(dayRaw);
  if (year == null || month == null || day == null) return null;
  if (year < 100) year += 2000;
  if (month < 1 || month > 12 || day < 1 || day > 31) return null;
  try {
    return dateOnly(DateTime(year, month, day));
  } on ArgumentError {
    return null;
  }
}

const smsDateGroup =
    r'(?<date>\d{4}-\d{1,2}-\d{1,2}|\d{1,2}[/-]\d{1,2}[/-]\d{2,4})';

final _dateAnywhere = RegExp(
  r'(\d{4}-\d{1,2}-\d{1,2}|\d{1,2}[/-]\d{1,2}[/-]\d{2,4})',
);

DateTime? firstSmsDateIn(String body) {
  final match = _dateAnywhere.firstMatch(body);
  if (match == null) return null;
  return parseSmsDate(match.group(1)!);
}
