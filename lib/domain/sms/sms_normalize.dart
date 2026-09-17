import 'numeral.dart';

String normalizeSmsText(String input) {
  var text = easternToWesternDigits(input);
  text = text.replaceAll('\u00a0', ' ');
  text = text.replaceAll('\u066c', ','); // Arabic thousands
  text = text.replaceAll('\u066b', '.'); // Arabic decimal
  text = text.replaceAll('\u060c', ',');
  text = text.replaceAll('\r\n', '\n');
  text = text.replaceAll(RegExp(r'[ \t]+'), ' ');
  return text.trim();
}

String normalizeSender(String sender) {
  return normalizeSmsText(sender)
      .toUpperCase()
      .replaceAll(RegExp(r'[\s\-_.]+'), '');
}

bool senderMatchesAllowlist(String sender, Iterable<String> senderIds) {
  final normalized = normalizeSender(sender);
  if (normalized.isEmpty) return false;
  for (final id in senderIds) {
    final token = normalizeSender(id);
    if (token.isEmpty) continue;
    if (normalized.contains(token) || token.contains(normalized)) {
      return true;
    }
  }
  return false;
}

bool looksLikeOtp(String body) {
  return RegExp(
    r'(otp|one[-\s]?time(?:\s+password|\s+code)?|verification code|passcode|'
    r'رمز التحقق|رمز التأكيد|كلمة السر لمرة|رمز سري)',
    caseSensitive: false,
  ).hasMatch(body);
}
