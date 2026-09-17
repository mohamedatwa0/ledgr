import '../../domain/models/transaction_type.dart';

extension TransactionTypeUi on TransactionType {
  String get ledgerLabel =>
      this == TransactionType.expense ? 'Debit' : 'Credit';
}
