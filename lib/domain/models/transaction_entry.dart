import 'category.dart';
import 'ledger_transaction.dart';

class TransactionEntry {
  const TransactionEntry({
    required this.transaction,
    required this.category,
  });

  final LedgerTransaction transaction;
  final Category category;
}
