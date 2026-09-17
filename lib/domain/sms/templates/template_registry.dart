import 'banque_du_caire.dart';
import 'banque_misr.dart';
import 'cib.dart';
import 'instapay.dart';
import 'nbe.dart';
import 'qnb.dart';
import 'sms_template.dart';

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
  if (normalizedSender.isEmpty) return allSmsTemplates;
  final matching = <SmsTemplate>[];
  final rest = <SmsTemplate>[];
  for (final template in allSmsTemplates) {
    final hits = template.senderIds.any((id) {
      final token = id.toUpperCase().replaceAll(RegExp(r'[\s\-_.]+'), '');
      return normalizedSender.contains(token) || token.contains(normalizedSender);
    });
    if (hits) {
      matching.add(template);
    } else {
      rest.add(template);
    }
  }
  return [...matching, ...rest];
}
