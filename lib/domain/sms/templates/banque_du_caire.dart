import '../../models/transaction_type.dart';
import '../money_parse.dart';
import '../sms_date_parse.dart';
import 'bank_id.dart';
import 'sms_template.dart';

const _bdcSenders = ['BDC', 'BANQUEDUCAIRE'];

final banqueDuCaireTemplates = <SmsTemplate>[
  SmsTemplate(
    id: 'bdc_purchase_en',
    bankId: BankId.banqueDuCaire,
    senderIds: _bdcSenders,
    type: TransactionType.expense,
    pattern: RegExp(
      r'(?:purchase(?:d)?|withdrawn|debited)\s+(?:of\s+)?'
      '$smsCurrencyGroup\\s+$smsAmountGroup'
      '(?:\\s+at\\s+$smsMerchantGroup)?'
      '(?:\\s+on\\s+$smsDateGroup)?',
      caseSensitive: false,
      dotAll: true,
    ),
  ),
  SmsTemplate(
    id: 'bdc_credit_en',
    bankId: BankId.banqueDuCaire,
    senderIds: _bdcSenders,
    type: TransactionType.income,
    pattern: RegExp(
      r'(?:credited|received|deposit(?:ed)?)\s+'
      '$smsCurrencyGroup\\s+$smsAmountGroup'
      '(?:\\s+on\\s+$smsDateGroup)?',
      caseSensitive: false,
    ),
  ),
  SmsTemplate(
    id: 'bdc_debit_ar',
    bankId: BankId.banqueDuCaire,
    senderIds: _bdcSenders,
    type: TransactionType.expense,
    pattern: RegExp(
      r'تم (?:خصم|سحب)\s+(?:مبلغ\s+)?'
      '$smsAmountGroup\\s*$smsCurrencyGroup?'
      '(?:\\s+بتاريخ\\s+$smsDateGroup)?',
      caseSensitive: false,
    ),
  ),
  SmsTemplate(
    id: 'bdc_credit_ar',
    bankId: BankId.banqueDuCaire,
    senderIds: _bdcSenders,
    type: TransactionType.income,
    pattern: RegExp(
      r'تم (?:ايداع|إيداع)\s+'
      '$smsAmountGroup\\s*$smsCurrencyGroup?'
      '(?:\\s+بتاريخ\\s+$smsDateGroup)?',
      caseSensitive: false,
    ),
  ),
];
