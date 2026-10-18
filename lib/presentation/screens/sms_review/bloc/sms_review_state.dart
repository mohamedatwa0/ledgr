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
    this.notFound = false,
    this.errorMessage,
    this.baselineAmountText = '',
    this.baselineType = TransactionType.expense,
    this.baselineCategoryId,
    this.baselineNote = '',
    this.baselineDate,
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
  final bool notFound;
  final String? errorMessage;
  final String baselineAmountText;
  final TransactionType baselineType;
  final int? baselineCategoryId;
  final String baselineNote;
  final DateTime? baselineDate;

  bool get missingRequiredFields {
    final amount = parseMinorUnits(amountText) ?? 0;
    return amount <= 0 || categoryId == null;
  }

  bool get canSave =>
      !missingRequiredFields && !saving && !loading && !notFound;

  bool get isDirty {
    if (saved || dismissed || notFound || loading) return false;
    final baseline = baselineDate ?? date;
    return amountText.trim() != baselineAmountText.trim() ||
        type != baselineType ||
        categoryId != baselineCategoryId ||
        note.trim() != baselineNote.trim() ||
        dateOnly(date) != dateOnly(baseline);
  }

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
    bool? notFound,
    String? errorMessage,
    String? baselineAmountText,
    TransactionType? baselineType,
    int? baselineCategoryId,
    String? baselineNote,
    DateTime? baselineDate,
    bool clearCategory = false,
    bool clearError = false,
    bool clearBaselineCategory = false,
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
      notFound: notFound ?? this.notFound,
      errorMessage: clearError ? null : errorMessage,
      baselineAmountText: baselineAmountText ?? this.baselineAmountText,
      baselineType: baselineType ?? this.baselineType,
      baselineCategoryId: clearBaselineCategory
          ? null
          : (baselineCategoryId ?? this.baselineCategoryId),
      baselineNote: baselineNote ?? this.baselineNote,
      baselineDate: baselineDate ?? this.baselineDate,
    );
  }
}
