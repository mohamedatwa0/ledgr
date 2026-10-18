import '../sms_normalize.dart';
import 'banque_du_caire.dart';
import 'banque_misr.dart';
import 'cib.dart';
import 'instapay.dart';
import 'nbe.dart';
import 'qnb.dart';
import 'sms_template.dart';

const smsPlaceholderSenders = {'', 'SHARE', 'PASTE', 'MESSAGES', 'SMS'};

final List<SmsTemplate> allSmsTemplates = [
  ...cibTemplates,
  ...nbeTemplates,
  ...banqueMisrTemplates,
  ...qnbTemplates,
  ...banqueDuCaireTemplates,
  ...instapayTemplates,
];

Set<String> smsSenderAllowlist() {
  return {
    for (final template in allSmsTemplates) ...template.senderIds,
  };
}

List<SmsTemplate> templatesForSender(String normalizedSender) {
  if (normalizedSender.isEmpty ||
      smsPlaceholderSenders.contains(normalizedSender)) {
    return allSmsTemplates;
  }
  return [
    for (final template in allSmsTemplates)
      if (template.senderIds.any((id) {
        return senderTokenMatches(normalizedSender, normalizeSender(id));
      }))
        template,
  ];
}
