import '../../models/transaction_type.dart';
import '../money_parse.dart';
import '../sms_date_parse.dart';
import 'bank_id.dart';
import 'sms_template.dart';

const _cibSenders = ['CIB', 'CIBEGY'];

final cibTemplates = <SmsTemplate>[
  SmsTemplate(
    id: 'cib_purchase_en',
    bankId: BankId.cib,
    senderIds: _cibSenders,
    type: TransactionType.expense,
    pattern: RegExp(
      r'(?:purchase(?:d)?(?:\s+of)?|used for)\s+'
      '$smsCurrencyGroup\\s+$smsAmountGroup'
      '(?:\\s+at\\s+$smsMerchantGroup)?'
      '(?:\\s+on\\s+$smsDateGroup)?',
      caseSensitive: false,
      dotAll: true,
    ),
  ),
  SmsTemplate(
    id: 'cib_atm_en',
    bankId: BankId.cib,
    senderIds: _cibSenders,
    type: TransactionType.expense,
    pattern: RegExp(
      r'ATM\s+withdrawal\s+of\s+'
      '$smsCurrencyGroup\\s+$smsAmountGroup'
      '(?:\\s+on\\s+$smsDateGroup)?',
      caseSensitive: false,
    ),
  ),
  SmsTemplate(
    id: 'cib_credit_en',
    bankId: BankId.cib,
    senderIds: _cibSenders,
    type: TransactionType.income,
    pattern: RegExp(
      r'(?:credited|received|deposit(?:ed)?)\s+(?:with\s+)?'
      '$smsCurrencyGroup\\s+$smsAmountGroup'
      '(?:\\s+on\\s+$smsDateGroup)?',
      caseSensitive: false,
    ),
  ),
  SmsTemplate(
    id: 'cib_debit_ar',
    bankId: BankId.cib,
    senderIds: _cibSenders,
    type: TransactionType.expense,
    pattern: RegExp(
      r'تم خصم(?:\s+مبلغ)?\s+'
      '$smsAmountGroup\\s*$smsCurrencyGroup?'
      r'(?:\s*(?:من بطاقتك|من حسابك))?'
      '(?:\\s+(?:في|لدى)\\s+$smsMerchantGroup)?'
      '(?:\\s+بتاريخ\\s+$smsDateGroup)?',
      caseSensitive: false,
      dotAll: true,
    ),
  ),
  SmsTemplate(
    id: 'cib_credit_ar',
    bankId: BankId.cib,
    senderIds: _cibSenders,
    type: TransactionType.income,
    pattern: RegExp(
      r'تم (?:ايداع|إيداع|إضافة)\s+(?:مبلغ\s+)?'
      '$smsAmountGroup\\s*$smsCurrencyGroup?'
      '(?:\\s+بتاريخ\\s+$smsDateGroup)?',
      caseSensitive: false,
    ),
  ),
];
