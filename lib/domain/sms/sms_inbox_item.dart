import '../models/transaction_type.dart';
import 'sms_inbox_status.dart';

class SmsInboxItem {
  const SmsInboxItem({
    required this.id,
    required this.fingerprint,
    required this.sender,
    required this.body,
    required this.receivedAt,
    required this.createdAt,
    required this.status,
    this.platformMessageId,
    this.bankId,
    this.templateId,
    this.amount,
    this.type,
    this.suggestedCategoryId,
    this.note,
    this.valueDate,
    this.currencyCode,
    this.transactionId,
  });

  final int id;
  final String fingerprint;
  final String? platformMessageId;
  final String sender;
  final String body;
  final DateTime receivedAt;
  final DateTime createdAt;
  final SmsInboxStatus status;
  final String? bankId;
  final String? templateId;
  final int? amount;
  final TransactionType? type;
  final int? suggestedCategoryId;
  final String? note;
  final DateTime? valueDate;
  final String? currencyCode;
  final int? transactionId;
}

class SmsInboxInsert {
  const SmsInboxInsert({
    required this.fingerprint,
    required this.sender,
    required this.body,
    required this.receivedAt,
    required this.status,
    this.platformMessageId,
    this.bankId,
    this.templateId,
    this.amount,
    this.type,
    this.suggestedCategoryId,
    this.note,
    this.valueDate,
    this.currencyCode,
  });

  final String fingerprint;
  final String? platformMessageId;
  final String sender;
  final String body;
  final DateTime receivedAt;
  final SmsInboxStatus status;
  final String? bankId;
  final String? templateId;
  final int? amount;
  final TransactionType? type;
  final int? suggestedCategoryId;
  final String? note;
  final DateTime? valueDate;
  final String? currencyCode;
}
