import '../../../../domain/date_utils.dart';
import '../../../../domain/models/category.dart';
import '../../../../domain/models/transaction_type.dart';

class SmsReviewState {
  const SmsReviewState({
    required this.amountText,
    required this.type,
    required this.note,
    required this.date,
    required this.currencyCode,
    required this.categories,
    required this.body,
    this.smsCurrencyCode,
    this.categoryId,
    this.loading = false,
    this.saving = false,
    this.categoriesLoading = false,
    this.saved = false,
    this.dismissed = false,
    this.errorMessage,
  });

  final String amountText;
  final TransactionType type;
  final int? categoryId;
  final String note;
  final DateTime date;
  final String currencyCode;
  final String? smsCurrencyCode;
  final List<Category> categories;
  final String body;
  final bool loading;
  final bool saving;
  final bool categoriesLoading;
  final bool saved;
  final bool dismissed;
  final String? errorMessage;

  bool get missingRequiredFields {
    final amount = parseMinorUnits(amountText) ?? 0;
    return amount <= 0 || categoryId == null;
  }

  bool get canSave => !missingRequiredFields && !saving && !loading;

  bool get currencyMismatch =>
      smsCurrencyCode != null &&
      smsCurrencyCode!.isNotEmpty &&
      smsCurrencyCode != currencyCode;

  SmsReviewState copyWith({
    String? amountText,
    TransactionType? type,
    int? categoryId,
    String? note,
    DateTime? date,
    String? currencyCode,
    String? smsCurrencyCode,
    List<Category>? categories,
    String? body,
    bool? loading,
    bool? saving,
    bool? categoriesLoading,
    bool? saved,
    bool? dismissed,
    String? errorMessage,
    bool clearCategory = false,
    bool clearError = false,
  }) {
    return SmsReviewState(
      amountText: amountText ?? this.amountText,
      type: type ?? this.type,
      categoryId: clearCategory ? null : (categoryId ?? this.categoryId),
      note: note ?? this.note,
      date: date ?? this.date,
      currencyCode: currencyCode ?? this.currencyCode,
      smsCurrencyCode: smsCurrencyCode ?? this.smsCurrencyCode,
      categories: categories ?? this.categories,
      body: body ?? this.body,
      loading: loading ?? this.loading,
      saving: saving ?? this.saving,
      categoriesLoading: categoriesLoading ?? this.categoriesLoading,
      saved: saved ?? false,
      dismissed: dismissed ?? false,
      errorMessage: clearError ? null : errorMessage,
    );
  }
}
