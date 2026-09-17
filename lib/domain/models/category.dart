import 'transaction_type.dart';

class Category {
  const Category({
    required this.id,
    required this.name,
    required this.type,
    required this.iconCodePoint,
    required this.colorValue,
    required this.isDefault,
    this.isFallback = false,
  });

  final int id;
  final String name;
  final TransactionType type;
  final int iconCodePoint;
  final int colorValue;
  final bool isDefault;
  final bool isFallback;
}
