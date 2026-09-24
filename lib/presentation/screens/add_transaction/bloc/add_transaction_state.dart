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
    this.deleted = false,
    this.notFound = false,
    this.errorMessage,
    this.requestedCategoryName,
    this.createIfMissing = false,
    this.pendingCategoryName,
    this.userPickedCategory = false,
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
  final bool deleted;
  final bool notFound;
  final String? errorMessage;
  final String? requestedCategoryName;
  final bool createIfMissing;
  final String? pendingCategoryName;
  final bool userPickedCategory;

  bool get hasPendingCategory =>
      pendingCategoryName != null && pendingCategoryName!.isNotEmpty;

  bool get missingRequiredFields {
    final amount = parseMinorUnits(amountText) ?? 0;
    return amount <= 0 || (categoryId == null && !hasPendingCategory);
  }

  bool get canSave =>
      missingRequiredFields == false && !saving && !loading && !notFound;

  bool get isDirty => amountText.trim().isNotEmpty || note.trim().isNotEmpty;

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
    bool? deleted,
    bool? notFound,
    String? errorMessage,
    String? requestedCategoryName,
    bool? createIfMissing,
    String? pendingCategoryName,
    bool? userPickedCategory,
    bool clearCategory = false,
    bool clearError = false,
    bool clearPending = false,
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
      saved: saved ?? false,
      deleted: deleted ?? false,
      notFound: notFound ?? this.notFound,
      errorMessage: clearError ? null : errorMessage,
      requestedCategoryName: requestedCategoryName ?? this.requestedCategoryName,
      createIfMissing: createIfMissing ?? this.createIfMissing,
      pendingCategoryName:
          clearPending ? null : (pendingCategoryName ?? this.pendingCategoryName),
      userPickedCategory: userPickedCategory ?? this.userPickedCategory,
    );
  }
}
