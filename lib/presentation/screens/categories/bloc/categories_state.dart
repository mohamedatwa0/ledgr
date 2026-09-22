import '../../../../domain/models/category.dart';
import '../../../../domain/models/transaction_type.dart';

class CategoriesState {
  const CategoriesState({
    required this.type,
    required this.all,
    this.loading = false,
  });

  final TransactionType type;
  final List<Category> all;
  final bool loading;

  List<Category> get categories =>
      all.where((category) => category.type == type).toList();

  int get expenseCount =>
      all.where((category) => category.type == TransactionType.expense).length;

  int get incomeCount =>
      all.where((category) => category.type == TransactionType.income).length;

  static const initial = CategoriesState(
    type: TransactionType.expense,
    all: [],
    loading: true,
  );

  CategoriesState copyWith({
    TransactionType? type,
    List<Category>? all,
    bool? loading,
  }) {
    return CategoriesState(
      type: type ?? this.type,
      all: all ?? this.all,
      loading: loading ?? this.loading,
    );
  }
}
