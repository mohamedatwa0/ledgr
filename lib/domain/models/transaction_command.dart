import '../models/transaction_source.dart';
import '../models/transaction_type.dart';

class TransactionCommand {
  const TransactionCommand({
    required this.amount,
    required this.type,
    required this.categoryId,
    required this.date,
    this.note,
    this.source = TransactionSource.manual,
  });

  /// Amount in integer minor units (piasters/cents).
  final int amount;
  final TransactionType type;
  final int categoryId;
  final String? note;
  final DateTime date;
  final TransactionSource source;
}
