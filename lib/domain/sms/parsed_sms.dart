import '../models/transaction_type.dart';

class ParsedSms {
  const ParsedSms({
    required this.bankId,
    required this.templateId,
    required this.amount,
    required this.type,
    this.merchant,
    this.valueDate,
    this.currencyCode,
  });

  final String bankId;
  final String templateId;
  final int amount;
  final TransactionType type;
  final String? merchant;
  final DateTime? valueDate;
  final String? currencyCode;
}
