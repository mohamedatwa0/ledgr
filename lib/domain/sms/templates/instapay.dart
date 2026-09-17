import '../../models/transaction_type.dart';
import '../money_parse.dart';
import 'bank_id.dart';
import 'sms_template.dart';

const _instapaySenders = ['INSTAPAY', 'IPN'];

final instapayTemplates = <SmsTemplate>[
  SmsTemplate(
    id: 'instapay_sent_en',
    bankId: BankId.instapay,
    senderIds: _instapaySenders,
    type: TransactionType.expense,
    pattern: RegExp(
      r'you sent\s+'
      '$smsCurrencyGroup\\s+$smsAmountGroup'
      r'(?:\s+to\s+(?<merchant>.+?))?(?:\.|$)',
      caseSensitive: false,
      dotAll: true,
    ),
  ),
  SmsTemplate(
    id: 'instapay_received_en',
    bankId: BankId.instapay,
    senderIds: _instapaySenders,
    type: TransactionType.income,
    pattern: RegExp(
      r'you received\s+'
      '$smsCurrencyGroup\\s+$smsAmountGroup'
      r'(?:\s+from\s+(?<merchant>.+?))?(?:\.|$)',
      caseSensitive: false,
      dotAll: true,
    ),
  ),
  SmsTemplate(
    id: 'instapay_sent_ar',
    bankId: BankId.instapay,
    senderIds: _instapaySenders,
    type: TransactionType.expense,
    pattern: RegExp(
      r'(?:تم تحويل|حولت|قمت بتحويل)\s+'
      '$smsAmountGroup\\s*$smsCurrencyGroup?'
      r'(?:\s+إلى\s+(?<merchant>.+?))?(?:\.|$)',
      caseSensitive: false,
      dotAll: true,
    ),
  ),
  SmsTemplate(
    id: 'instapay_received_ar',
    bankId: BankId.instapay,
    senderIds: _instapaySenders,
    type: TransactionType.income,
    pattern: RegExp(
      r'(?:استلمت|تم استلام|حوالة واردة)\s+'
      '$smsAmountGroup\\s*$smsCurrencyGroup?'
      r'(?:\s+من\s+(?<merchant>.+?))?(?:\.|$)',
      caseSensitive: false,
      dotAll: true,
    ),
  ),
];
