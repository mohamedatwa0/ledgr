import '../models/ledger_transaction.dart';
import '../models/transaction_entry.dart';
import '../models/transaction_source.dart';
import '../models/transaction_type.dart';

abstract class TransactionRepository {
  Stream<List<TransactionEntry>> watchEntries({
    DateTime? from,
    DateTime? toExclusive,
    TransactionType? type,
  });

  Future<LedgerTransaction?> getById(int id);

  Future<int> countForCategory(int categoryId);

  Future<LedgerTransaction> create({
    required int amount,
    required TransactionType type,
    required int categoryId,
    String? note,
    required DateTime date,
    TransactionSource source = TransactionSource.manual,
  });

  Future<void> update(LedgerTransaction transaction);

  Future<void> delete(int id);
}
