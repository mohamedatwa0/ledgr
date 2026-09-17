import 'parsed_sms.dart';
import 'sms_message.dart';
import 'sms_normalize.dart';
import 'templates/generic.dart';
import 'templates/template_registry.dart';

class SmsParser {
  const SmsParser();

  ParsedSms? parse(RawSms sms) {
    final body = normalizeSmsText(sms.body);
    if (body.isEmpty || looksLikeOtp(body)) return null;

    final sender = normalizeSender(sms.sender);
    for (final template in templatesForSender(sender)) {
      final parsed = template.tryParse(body);
      if (parsed != null) return parsed;
    }
    return parseGenericSms(body);
  }
}
