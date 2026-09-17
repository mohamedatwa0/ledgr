import '../repositories/transaction_repository.dart';

class DeleteTransaction {
  const DeleteTransaction(this._transactions);

  final TransactionRepository _transactions;

  Future<void> call(int id) => _transactions.delete(id);
}
