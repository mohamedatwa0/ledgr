import '../../../../domain/date_utils.dart';
import '../../../../domain/models/category.dart';
import '../../../../domain/models/transaction_type.dart';

class AddTransactionState {
  const AddTransactionState({
    required this.amountText,
    required this.type,
    required this.note,
    required this.date,
    required this.currencyCode,
    required this.categories,
    this.categoryId,
    this.loading = false,
    this.saving = false,
    this.categoriesLoading = false,
    this.saved = false,
    this.errorMessage,
  });

  final String amountText;
  final TransactionType type;
  final int? categoryId;
  final String note;
  final DateTime date;
  final bool loading;
  final bool saving;
  final String currencyCode;
  final List<Category> categories;
  final bool categoriesLoading;
  final bool saved;
  final String? errorMessage;

  bool get missingRequiredFields {
    final amount = parseMinorUnits(amountText) ?? 0;
    return amount <= 0 || categoryId == null;
  }

  bool get canSave => missingRequiredFields == false && !saving && !loading;

  AddTransactionState copyWith({
    String? amountText,
    TransactionType? type,
    int? categoryId,
    String? note,
    DateTime? date,
    bool? loading,
    bool? saving,
    String? currencyCode,
    List<Category>? categories,
    bool? categoriesLoading,
    bool? saved,
    String? errorMessage,
    bool clearCategory = false,
    bool clearError = false,
  }) {
    return AddTransactionState(
      amountText: amountText ?? this.amountText,
      type: type ?? this.type,
      categoryId: clearCategory ? null : (categoryId ?? this.categoryId),
      note: note ?? this.note,
      date: date ?? this.date,
      loading: loading ?? this.loading,
      saving: saving ?? this.saving,
      currencyCode: currencyCode ?? this.currencyCode,
      categories: categories ?? this.categories,
      categoriesLoading: categoriesLoading ?? this.categoriesLoading,
      saved: saved ?? this.saved,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }
}
