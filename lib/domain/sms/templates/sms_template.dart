import '../../models/transaction_type.dart';
import '../money_parse.dart';
import '../parsed_sms.dart';
import '../sms_date_parse.dart';

class SmsTemplate {
  const SmsTemplate({
    required this.id,
    required this.bankId,
    required this.senderIds,
    required this.type,
    required this.pattern,
  });

  final String id;
  final String bankId;
  final List<String> senderIds;
  final TransactionType type;
  final RegExp pattern;

  ParsedSms? tryParse(String body) {
    final match = pattern.firstMatch(body);
    if (match == null) return null;
    final amountRaw = match.namedGroup('amount');
    if (amountRaw == null) return null;
    final amount = parseSmsAmount(amountRaw);
    if (amount == null || amount <= 0) return null;
    String? merchant;
    try {
      merchant = _cleanMerchant(match.namedGroup('merchant'));
    } on ArgumentError {
      merchant = null;
    }
    String? dateRaw;
    try {
      dateRaw = match.namedGroup('date');
    } on ArgumentError {
      dateRaw = null;
    }
    String? currencyRaw;
    try {
      currencyRaw = match.namedGroup('currency');
    } on ArgumentError {
      currencyRaw = null;
    }
    return ParsedSms(
      bankId: bankId,
      templateId: id,
      amount: amount,
      type: type,
      merchant: merchant,
      valueDate: parseSmsDate(dateRaw ?? '') ?? firstSmsDateIn(body),
      currencyCode: parseSmsCurrency(currencyRaw) ?? 'EGP',
    );
  }
}

String? _cleanMerchant(String? raw) {
  if (raw == null) return null;
  var text = raw.trim();
  text = text.replaceAll(
    RegExp(
      r'\s+(using(?: your)? card.*|avl(?:ailable)?\s+bal.*|available balance.*|'
      r'رصيد.*)$',
      caseSensitive: false,
    ),
    '',
  );
  text = text.replaceAll(RegExp(r'[\s.;,]+$'), '');
  text = text.trim();
  if (text.isEmpty) return null;
  if (text.length > 80) text = text.substring(0, 80).trim();
  return text;
}
