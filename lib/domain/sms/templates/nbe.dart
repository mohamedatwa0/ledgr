import '../../models/transaction_type.dart';
import '../money_parse.dart';
import '../sms_date_parse.dart';
import 'bank_id.dart';
import 'sms_template.dart';

const _nbeSenders = ['NBE', 'BANQUENBE'];

final nbeTemplates = <SmsTemplate>[
  SmsTemplate(
    id: 'nbe_withdraw_en',
    bankId: BankId.nbe,
    senderIds: _nbeSenders,
    type: TransactionType.expense,
    pattern: RegExp(
      '$smsCurrencyGroup\\s+$smsAmountGroup\\s+'
      r'(?:withdrawn|debited)'
      r'(?:\s+from\s+(?:acct|account|card)\s*\**\d+)?'
      '(?:\\s+on\\s+$smsDateGroup)?',
      caseSensitive: false,
    ),
  ),
  SmsTemplate(
    id: 'nbe_purchase_en',
    bankId: BankId.nbe,
    senderIds: _nbeSenders,
    type: TransactionType.expense,
    pattern: RegExp(
      r'(?:purchase(?:d)?|payment)\s+(?:of\s+)?'
      '$smsCurrencyGroup\\s+$smsAmountGroup'
      '(?:\\s+at\\s+$smsMerchantGroup)?'
      '(?:\\s+on\\s+$smsDateGroup)?',
      caseSensitive: false,
      dotAll: true,
    ),
  ),
  SmsTemplate(
    id: 'nbe_credit_en',
    bankId: BankId.nbe,
    senderIds: _nbeSenders,
    type: TransactionType.income,
    pattern: RegExp(
      '$smsCurrencyGroup\\s+$smsAmountGroup\\s+'
      r'(?:deposited|credited|received)'
      '(?:\\s+on\\s+$smsDateGroup)?',
      caseSensitive: false,
    ),
  ),
  SmsTemplate(
    id: 'nbe_debit_ar',
    bankId: BankId.nbe,
    senderIds: _nbeSenders,
    type: TransactionType.expense,
    pattern: RegExp(
      r'تم سحب\s+'
      '$smsAmountGroup\\s*$smsCurrencyGroup?'
      '(?:\\s+بتاريخ\\s+$smsDateGroup)?',
      caseSensitive: false,
    ),
  ),
  SmsTemplate(
    id: 'nbe_credit_ar',
    bankId: BankId.nbe,
    senderIds: _nbeSenders,
    type: TransactionType.income,
    pattern: RegExp(
      r'تم (?:ايداع|إيداع)\s+'
      '$smsAmountGroup\\s*$smsCurrencyGroup?'
      '(?:\\s+بتاريخ\\s+$smsDateGroup)?',
      caseSensitive: false,
    ),
  ),
];
