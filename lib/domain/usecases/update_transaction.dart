import '../date_utils.dart';
import '../exceptions.dart';
import '../models/ledger_transaction.dart';
import '../models/transaction_command.dart';
import '../repositories/category_repository.dart';
import '../repositories/transaction_repository.dart';
import 'create_transaction.dart';

class UpdateTransaction {
  const UpdateTransaction(this._transactions, this._categories);

  final TransactionRepository _transactions;
  final CategoryRepository _categories;

  Future<void> call(int id, TransactionCommand command) async {
    await validateTransactionCommand(command, _categories);
    final existing = await _transactions.getById(id);
    if (existing == null) {
      throw const TransactionNotFoundException();
    }
    await _transactions.update(
      LedgerTransaction(
        id: id,
        amount: command.amount,
        type: command.type,
        categoryId: command.categoryId,
        note: normalizedNote(command.note),
        date: dateOnly(command.date),
        createdAt: existing.createdAt,
        source: existing.source,
      ),
    );
  }
}
