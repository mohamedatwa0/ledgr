import '../../models/transaction_type.dart';
import '../money_parse.dart';
import '../sms_date_parse.dart';
import 'bank_id.dart';
import 'sms_template.dart';

const _qnbSenders = ['QNB', 'QNBALA'];

final qnbTemplates = <SmsTemplate>[
  SmsTemplate(
    id: 'qnb_purchase_en',
    bankId: BankId.qnb,
    senderIds: _qnbSenders,
    type: TransactionType.expense,
    pattern: RegExp(
      r'(?:purchase(?:d)?|POS|debited)\s+(?:of\s+)?'
      '$smsCurrencyGroup\\s+$smsAmountGroup'
      '(?:\\s+at\\s+$smsMerchantGroup)?'
      '(?:\\s+on\\s+$smsDateGroup)?',
      caseSensitive: false,
      dotAll: true,
    ),
  ),
  SmsTemplate(
    id: 'qnb_credit_en',
    bankId: BankId.qnb,
    senderIds: _qnbSenders,
    type: TransactionType.income,
    pattern: RegExp(
      r'(?:credited|received|deposit(?:ed)?)\s+'
      '$smsCurrencyGroup\\s+$smsAmountGroup'
      '(?:\\s+on\\s+$smsDateGroup)?',
      caseSensitive: false,
    ),
  ),
  SmsTemplate(
    id: 'qnb_debit_ar',
    bankId: BankId.qnb,
    senderIds: _qnbSenders,
    type: TransactionType.expense,
    pattern: RegExp(
      r'تم خصم\s+(?:مبلغ\s+)?'
      '$smsAmountGroup\\s*$smsCurrencyGroup?'
      '(?:\\s+(?:في|لدى)\\s+$smsMerchantGroup)?'
      '(?:\\s+بتاريخ\\s+$smsDateGroup)?',
      caseSensitive: false,
      dotAll: true,
    ),
  ),
  SmsTemplate(
    id: 'qnb_credit_ar',
    bankId: BankId.qnb,
    senderIds: _qnbSenders,
    type: TransactionType.income,
    pattern: RegExp(
      r'تم (?:ايداع|إيداع)\s+'
      '$smsAmountGroup\\s*$smsCurrencyGroup?'
      '(?:\\s+بتاريخ\\s+$smsDateGroup)?',
      caseSensitive: false,
    ),
  ),
];
