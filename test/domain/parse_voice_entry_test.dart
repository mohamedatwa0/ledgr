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

  test('سجائر folds to سجاير', () {
    final parsed = parseVoiceEntry('اشتريت سجائر ب 50');
    expect(parsed.categoryName, 'سجاير');
    expect(parsed.createIfMissing, isTrue);
  });
}
