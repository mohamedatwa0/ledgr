import '../date_utils.dart';
import '../repositories/category_repository.dart';
import '../repositories/sms_inbox_repository.dart';
import '../sms/keyword_categorizer.dart';
import '../sms/parsed_sms.dart';
import '../sms/sms_fingerprint.dart';
import '../sms/sms_inbox_item.dart';
import '../sms/sms_inbox_status.dart';
import '../sms/sms_message.dart';
import '../sms/sms_parser.dart';

class IngestResult {
  const IngestResult({required this.item, required this.duplicate});

  final SmsInboxItem item;
  final bool duplicate;
}

class IngestSms {
  IngestSms(
    this._inbox,
    this._categories, {
    SmsParser parser = const SmsParser(),
  }) : _parser = parser;

  final SmsInboxRepository _inbox;
  final CategoryRepository _categories;
  final SmsParser _parser;

  Future<IngestResult> call(RawSms sms) async {
    final fingerprint = smsFingerprint(sms);
    final existing = await _inbox.findByFingerprint(fingerprint);
    if (existing != null) {
      return IngestResult(item: existing, duplicate: true);
    }

    final parsed = _parser.parse(sms);
    final suggestedId =
        parsed == null ? null : await _suggestedCategoryId(sms, parsed);
    final valueDate = parsed?.valueDate;
    final item = await _inbox.insert(
      SmsInboxInsert(
        fingerprint: fingerprint,
        platformMessageId: sms.platformMessageId,
        sender: sms.sender,
        body: sms.body,
        receivedAt: sms.receivedAt,
        status:
            parsed == null ? SmsInboxStatus.unmatched : SmsInboxStatus.ready,
        bankId: parsed?.bankId,
        templateId: parsed?.templateId,
        amount: parsed?.amount,
        type: parsed?.type,
        suggestedCategoryId: suggestedId,
        note: parsed?.merchant,
        valueDate: valueDate == null ? null : dateOnly(valueDate),
        currencyCode: parsed?.currencyCode,
      ),
    );
    return IngestResult(item: item, duplicate: false);
  }

  Future<int?> _suggestedCategoryId(RawSms sms, ParsedSms parsed) async {
    final haystack = '${parsed.merchant ?? ''} ${sms.body}';
    final name = suggestCategoryName(
      haystack: haystack,
      type: parsed.type,
    );
    if (name != null) {
      final match = await _categories.findByNameAndType(name, parsed.type);
      if (match != null) return match.id;
    }
    final other = await _categories.findOther(parsed.type);
    return other?.id;
  }
}
