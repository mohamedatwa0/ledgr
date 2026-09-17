/// Parses an SMS amount into integer minor units (piasters/cents).
///
/// Accepts `1,250.50`, `1.250,50`, `1250.50`, `1250`, and Arabic separators.
int? parseSmsAmount(String raw) {
  var text = raw.trim().replaceAll(' ', '');
  if (text.isEmpty) return null;
  text = text.replaceAll('\u066c', ',').replaceAll('\u066b', '.');

  final lastComma = text.lastIndexOf(',');
  final lastDot = text.lastIndexOf('.');
  if (lastComma >= 0 && lastDot >= 0) {
    if (lastComma > lastDot) {
      text = text.replaceAll('.', '').replaceAll(',', '.');
    } else {
      text = text.replaceAll(',', '');
    }
  } else if (lastComma >= 0) {
    final fraction = text.length - lastComma - 1;
    text = fraction == 3 ? text.replaceAll(',', '') : text.replaceAll(',', '.');
  } else if (lastDot >= 0) {
    final fraction = text.length - lastDot - 1;
    if (fraction == 3) {
      text = text.replaceAll('.', '');
    }
  }

  final value = double.tryParse(text);
  if (value == null || value <= 0) return null;
  return (value * 100).round();
}

String? parseSmsCurrency(String? raw) {
  if (raw == null) return null;
  final value = raw.trim().toUpperCase();
  if (value.isEmpty) return null;
  if (value == 'E£' ||
      value == 'LE' ||
      value.contains('جنيه') ||
      value == 'EGP') {
    return 'EGP';
  }
  if (value == 'USD' || value == r'$') return 'USD';
  if (value == 'EUR' || value == '€') return 'EUR';
  if (value == 'GBP' || value == '£') return 'GBP';
  if (value == 'SAR') return 'SAR';
  if (value == 'AED') return 'AED';
  return value.length <= 4 ? value : null;
}

const smsAmountGroup =
    r'(?<amount>\d{1,3}(?:[.,]\d{3})+[.,]\d{1,2}|\d{1,3}(?:[.,]\d{3})+|\d+[.,]\d{1,2}|\d+)';

const smsCurrencyGroup =
    r'(?<currency>E£|EGP|USD|EUR|GBP|SAR|AED|LE|جنيه(?:\s*مصري)?)';

const smsMerchantGroup =
    r'(?<merchant>.+?)(?=\s+on\s+\d|\s+using|\s+بتاريخ|\s+Avl|\s+available|\s+Ref|\.|$)';
