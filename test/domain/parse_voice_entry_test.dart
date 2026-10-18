import 'package:flutter_test/flutter_test.dart';
import 'package:ledgr/domain/models/transaction_type.dart';
import 'package:ledgr/domain/voice/parse_voice_entry.dart';

void main() {
  test('bought cigarettes is a new expense category', () {
    final parsed = parseVoiceEntry('انا اشتريت علبه سجاير ب ١٠٠ جنيه');
    expect(parsed.type, TransactionType.expense);
    expect(parsed.amountMinor, 10000);
    expect(parsed.categoryName, 'سجاير');
    expect(parsed.createIfMissing, isTrue);
    expect(parsed.transcript, 'انا اشتريت علبه سجاير ب ١٠٠ جنيه');
  });

  test('cash withdrawal stays Other', () {
    final parsed = parseVoiceEntry('انا سحبت ٢٠٠٠ جنيه');
    expect(parsed.type, TransactionType.expense);
    expect(parsed.amountMinor, 200000);
    expect(parsed.categoryName, 'Other');
    expect(parsed.createIfMissing, isFalse);
  });

  test('sent transfer uses the saved expense Transfer', () {
    final parsed = parseVoiceEntry('انا حولت ٢٠ جنيه');
    expect(parsed.type, TransactionType.expense);
    expect(parsed.amountMinor, 2000);
    expect(parsed.categoryName, 'Transfer');
    expect(parsed.createIfMissing, isFalse);
  });

  test('salary landing is income with no amount', () {
    final parsed = parseVoiceEntry('المرتب نزل');
    expect(parsed.type, TransactionType.income);
    expect(parsed.amountMinor, isNull);
    expect(parsed.categoryName, 'Salary');
    expect(parsed.createIfMissing, isFalse);
  });

  test('received transfer uses the saved income Transfer', () {
    final parsed = parseVoiceEntry('اتحولي ٥٠٠٠');
    expect(parsed.type, TransactionType.income);
    expect(parsed.amountMinor, 500000);
    expect(parsed.categoryName, 'Transfer');
    expect(parsed.createIfMissing, isFalse);
  });

  test('حول لي is credit not debit', () {
    final parsed = parseVoiceEntry('محمد جمال حول لي 5000 جنيه');
    expect(parsed.type, TransactionType.income);
    expect(parsed.amountMinor, 500000);
    expect(parsed.categoryName, 'Transfer');
  });

  test('I transferred stays debit', () {
    final parsed = parseVoiceEntry('انا حولت ٢٠ جنيه');
    expect(parsed.type, TransactionType.expense);
    expect(parsed.categoryName, 'Transfer');
  });

  test('سجائر folds to سجاير', () {
    final parsed = parseVoiceEntry('اشتريت سجائر ب 50');
    expect(parsed.categoryName, 'سجاير');
    expect(parsed.createIfMissing, isTrue);
  });

  test('bare got is not income', () {
    expect(parseVoiceEntry('I got coffee for 20').type, isNot(TransactionType.income));
    expect(parseVoiceEntry('I got paid 20').type, TransactionType.income);
  });

  test('we is not treated as bills', () {
    expect(
      parseVoiceEntry('we bought lunch for 40').categoryName,
      'Food & Dining',
    );
    expect(
      parseVoiceEntry('we pay 80 for the internet').categoryName,
      'Bills & Utilities',
    );
  });

  test('english digits fill the amount', () {
    final parsed = parseVoiceEntry('I spent 50 pounds on uber');
    expect(parsed.type, TransactionType.expense);
    expect(parsed.amountMinor, 5000);
    expect(parsed.categoryName, 'Transport');
  });

  test('english number words fill the amount', () {
    final parsed = parseVoiceEntry('I bought coffee for fifty');
    expect(parsed.type, TransactionType.expense);
    expect(parsed.amountMinor, 5000);
    expect(parsed.categoryName, 'Food & Dining');
  });

  test('arabic number words fill the amount', () {
    final parsed = parseVoiceEntry('اشتريت قهوة بخمسين جنيه');
    expect(parsed.type, TransactionType.expense);
    expect(parsed.amountMinor, 5000);
    expect(parsed.categoryName, 'Food & Dining');
  });

  test('unknown english noun becomes a short new category', () {
    final parsed = parseVoiceEntry('I bought cigarettes for 100');
    expect(parsed.type, TransactionType.expense);
    expect(parsed.amountMinor, 10000);
    expect(parsed.categoryName, 'Cigarettes');
    expect(parsed.createIfMissing, isTrue);
    expect(parsed.transcript, 'I bought cigarettes for 100');
  });

  test('related speech selects a default category', () {
    expect(parseVoiceEntry('اشتريت غدا ب 80 جنيه').categoryName, 'Food & Dining');
    expect(parseVoiceEntry('I spent 50 on lunch').categoryName, 'Food & Dining');
    expect(
      parseVoiceEntry('I paid electricity 200').categoryName,
      'Bills & Utilities',
    );
    expect(parseVoiceEntry('دفعت فاتورة النت 300').categoryName, 'Bills & Utilities');
    expect(parseVoiceEntry('I took an uber for 40').categoryName, 'Transport');
  });

  test('unrelated speech creates a one or two word category and keeps the note', () {
    final parsed = parseVoiceEntry(
      'I bought a leather jacket yesterday for 200 pounds',
    );
    expect(parsed.categoryName, 'Leather Jacket');
    expect(parsed.createIfMissing, isTrue);
    expect(
      parsed.transcript,
      'I bought a leather jacket yesterday for 200 pounds',
    );
  });

  test('135 from eastern digits', () {
    expect(parseVoiceEntry('حولت ١٣٥ جنيه').amountMinor, 13500);
  });

  test('135 from split digits without currency', () {
    expect(parseVoiceEntry('حولت 1 35').amountMinor, 13500);
  });

  test('2 50 pounds is 2.50 when a currency word is adjacent', () {
    expect(parseVoiceEntry('I spent 2 50 pounds').amountMinor, 250);
    expect(parseVoiceEntry('حولت 1 35 جنيه').amountMinor, 135);
  });

  test('135 from hundred plus remainder', () {
    expect(parseVoiceEntry('حولت مية 35 جنيه').amountMinor, 13500);
  });

  test('135 from arabic compound', () {
    expect(parseVoiceEntry('حولت مية وخمسة وثلاثين جنيه').amountMinor, 13500);
  });

  test('20000 is twenty thousand not 20.00', () {
    expect(parseVoiceEntry('دفعت 20000 جنيه').amountMinor, 2000000);
    expect(parseVoiceEntry('دفعت 20,000 جنيه').amountMinor, 2000000);
    expect(parseVoiceEntry('دفعت 20.000 جنيه').amountMinor, 2000000);
    expect(parseVoiceEntry('دفعت 20 000 جنيه').amountMinor, 2000000);
    expect(parseVoiceEntry('I spent 20,000').amountMinor, 2000000);
    expect(parseVoiceEntry('دفعت ٢٠٠٠٠ جنيه').amountMinor, 2000000);
    expect(parseVoiceEntry('دفعت ٢٠٬٠٠٠ جنيه').amountMinor, 2000000);
  });

  test('decimal amounts are parsed', () {
    expect(parseVoiceEntry('دفعت 50.5 جنيه').amountMinor, 5050);
    expect(parseVoiceEntry('دفعت 50 . 5 جنيه').amountMinor, 5050);
    expect(parseVoiceEntry('I spent fifty point five').amountMinor, 5050);
    expect(parseVoiceEntry('دفعت خمسين فاصلة خمسة جنيه').amountMinor, 5050);
    expect(parseVoiceEntry('دفعت خمسين ونص جنيه').amountMinor, 5050);
  });
}
