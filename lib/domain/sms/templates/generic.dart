import '../../models/transaction_type.dart';
import '../money_parse.dart';
import '../parsed_sms.dart';
import '../sms_date_parse.dart';
import 'bank_id.dart';

final _expenseKeyword = RegExp(
  r'(debit(?:ed)?|purchased?|withdrawn|withdrawal|paid|payment to|sent to|'
  r'credit\s*cards?|'
  r'خصم|مشتريات|سحب|مدفوع|تحويل إلى|تم تحويل)',
  caseSensitive: false,
);

final _incomeKeyword = RegExp(
  r'(credit(?:ed)?|received|deposit(?:ed)?|salary|payroll|'
  r'ايداع|إيداع|استلام|واردة|راتب)',
  caseSensitive: false,
);

final _strongExpense = RegExp(
  r'(debit(?:ed)?|purchased?|withdrawn|withdrawal|\bpaid\b|credit\s*cards?|'
  r'خصم|مشتريات|سحب)',
  caseSensitive: false,
);

final _strongIncome = RegExp(
  r'(credited|\breceived\b|deposit(?:ed)?|salary|payroll|'
  r'ايداع|إيداع|راتب)',
  caseSensitive: false,
);

final _currencyThenAmount = RegExp(
  r'(?<currency>E£|EGP|USD|EUR|GBP|SAR|AED|LE|جنيه(?:\s*مصري)?)\s*'
  r'(?<amount>\d{1,3}(?:[.,]\d{3})+[.,]\d{1,2}|\d{1,3}(?:[.,]\d{3})+|\d+[.,]\d{1,2}|\d+)',
  caseSensitive: false,
);

final _amountThenCurrency = RegExp(
  r'(?<amount>\d{1,3}(?:[.,]\d{3})+[.,]\d{1,2}|\d{1,3}(?:[.,]\d{3})+|\d+[.,]\d{1,2}|\d+)\s*'
  r'(?<currency>E£|EGP|USD|EUR|GBP|SAR|AED|LE|جنيه(?:\s*مصري)?)',
  caseSensitive: false,
);

final _dateAnywhere = RegExp(
  r'(\d{4}-\d{1,2}-\d{1,2}|\d{1,2}[/-]\d{1,2}[/-]\d{2,4})',
);

bool _isBalanceContext(String body, int start) {
  final from = start - 28 < 0 ? 0 : start - 28;
  final before = body.substring(from, start).toLowerCase();
  return before.contains('bal') ||
      before.contains('balance') ||
      before.contains('رصيد');
}

ParsedSms? parseGenericSms(String body) {
  final forIncome = body.replaceAll(
    RegExp(r'credit\s*cards?', caseSensitive: false),
    ' ',
  );
  var expense = _expenseKeyword.hasMatch(body);
  var income = _incomeKeyword.hasMatch(forIncome);
  if (expense && income) {
    if (RegExp(r'credit\s*cards?', caseSensitive: false).hasMatch(body)) {
      income = false;
    } else {
      final strongExpense = _strongExpense.hasMatch(body);
      final strongIncome = _strongIncome.hasMatch(forIncome);
      if (strongExpense && !strongIncome) {
        income = false;
      } else if (strongIncome && !strongExpense) {
        expense = false;
      } else {
        return null;
      }
    }
  }
  if (expense == income) return null;

  final matches = [
    ..._currencyThenAmount.allMatches(body),
    ..._amountThenCurrency.allMatches(body),
  ]..sort((a, b) => a.start.compareTo(b.start));

  for (final match in matches) {
    if (_isBalanceContext(body, match.start)) continue;
    final amount = parseSmsAmount(match.namedGroup('amount')!);
    if (amount == null || amount <= 0) continue;
    final dateMatch = _dateAnywhere.firstMatch(body);
    return ParsedSms(
      bankId: BankId.generic,
      templateId: expense ? 'generic_expense' : 'generic_income',
      amount: amount,
      type: expense ? TransactionType.expense : TransactionType.income,
      merchant: null,
      valueDate: dateMatch == null ? null : parseSmsDate(dateMatch.group(1)!),
      currencyCode: parseSmsCurrency(match.namedGroup('currency')) ?? 'EGP',
    );
  }
  return null;
}
