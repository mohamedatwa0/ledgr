import 'package:flutter_test/flutter_test.dart';
import 'package:ledgr/domain/models/ledger_transaction.dart';
import 'package:ledgr/domain/models/transaction_type.dart';
import 'package:ledgr/domain/usecases/get_monthly_summary.dart';

void main() {
  const summary = GetMonthlySummary();
  final day = DateTime(2026, 9, 15);

  LedgerTransaction tx({
    required int id,
    required int amount,
    required TransactionType type,
  }) {
    return LedgerTransaction(
      id: id,
      amount: amount,
      type: type,
      categoryId: 1,
      date: day,
      createdAt: day,
    );
  }

  test('sums credits, debits, and balance in minor units', () {
    final result = summary([
      tx(id: 1, amount: 10000, type: TransactionType.income),
      tx(id: 2, amount: 4500, type: TransactionType.expense),
      tx(id: 3, amount: 500, type: TransactionType.expense),
    ]);

    expect(result.credits, 10000);
    expect(result.debits, 5000);
    expect(result.balance, 5000);
  });

  test('empty list is zero', () {
    expect(summary(const []).credits, 0);
    expect(summary(const []).debits, 0);
    expect(summary(const []).balance, 0);
  });
}
