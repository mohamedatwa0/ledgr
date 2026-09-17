import 'transaction_source.dart';
import 'transaction_type.dart';

class LedgerTransaction {
  const LedgerTransaction({
    required this.id,
    required this.amount,
    required this.type,
    required this.categoryId,
    required this.date,
    required this.createdAt,
    this.note,
    this.source = TransactionSource.manual,
  });

  final int id;
  /// Amount in integer minor units (piasters/cents).
  final int amount;
  final TransactionType type;
  final int categoryId;
  final String? note;
  final DateTime date;
  final DateTime createdAt;
  final TransactionSource source;
}
