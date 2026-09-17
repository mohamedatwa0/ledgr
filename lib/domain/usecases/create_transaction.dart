import '../date_utils.dart';
import '../exceptions.dart';
import '../models/ledger_transaction.dart';
import '../models/transaction_command.dart';
import '../repositories/category_repository.dart';
import '../repositories/transaction_repository.dart';

class CreateTransaction {
  const CreateTransaction(this._transactions, this._categories);

  final TransactionRepository _transactions;
  final CategoryRepository _categories;

  Future<LedgerTransaction> call(TransactionCommand command) async {
    await validateTransactionCommand(command, _categories);
    return _transactions.create(
      amount: command.amount,
      type: command.type,
      categoryId: command.categoryId,
      note: normalizedNote(command.note),
      date: dateOnly(command.date),
      source: command.source,
    );
  }
}

Future<void> validateTransactionCommand(
  TransactionCommand command,
  CategoryRepository categories,
) async {
  if (command.amount <= 0) {
    throw const ValidationException('Amount must be greater than 0.');
  }
  final category = await categories.getById(command.categoryId);
  if (category == null) {
    throw const ValidationException('Choose a category.');
  }
  if (category.type != command.type) {
    throw const ValidationException('Category does not match Debit/Credit.');
  }
}

String? normalizedNote(String? note) {
  final trimmed = note?.trim();
  if (trimmed == null || trimmed.isEmpty) return null;
  return trimmed;
}
