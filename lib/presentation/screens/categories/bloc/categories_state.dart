import '../../../../domain/models/category.dart';
import '../../../../domain/models/transaction_type.dart';

class CategoriesState {
  const CategoriesState({
    required this.type,
    required this.categories,
    this.loading = false,
  });

  final TransactionType type;
  final List<Category> categories;
  final bool loading;

  static const initial = CategoriesState(
    type: TransactionType.expense,
    categories: [],
    loading: true,
  );

  CategoriesState copyWith({
    TransactionType? type,
    List<Category>? categories,
    bool? loading,
  }) {
    return CategoriesState(
      type: type ?? this.type,
      categories: categories ?? this.categories,
      loading: loading ?? this.loading,
    );
  }
}
