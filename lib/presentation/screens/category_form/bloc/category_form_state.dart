import '../../../../domain/models/transaction_type.dart';

class CategoryFormState {
  const CategoryFormState({
    required this.name,
    required this.type,
    required this.iconCodePoint,
    required this.colorValue,
    this.isDefault = false,
    this.loading = false,
    this.saving = false,
    this.saved = false,
    this.deleted = false,
    this.notFound = false,
    this.deletePromptCount,
    this.errorMessage,
    this.savedCategoryId,
  });

  final String name;
  final TransactionType type;
  final int iconCodePoint;
  final int colorValue;
  final bool isDefault;
  final bool loading;
  final bool saving;
  final bool saved;
  final bool deleted;
  final bool notFound;
  final int? deletePromptCount;
  final String? errorMessage;
  final int? savedCategoryId;

  bool get canSave =>
      name.trim().isNotEmpty &&
      !saving &&
      !loading &&
      !isDefault &&
      !notFound;

  CategoryFormState copyWith({
    String? name,
    TransactionType? type,
    int? iconCodePoint,
    int? colorValue,
    bool? isDefault,
    bool? loading,
    bool? saving,
    bool? saved,
    bool? deleted,
    bool? notFound,
    int? deletePromptCount,
    String? errorMessage,
    int? savedCategoryId,
    bool clearDeletePrompt = false,
    bool clearError = false,
  }) {
    return CategoryFormState(
      name: name ?? this.name,
      type: type ?? this.type,
      iconCodePoint: iconCodePoint ?? this.iconCodePoint,
      colorValue: colorValue ?? this.colorValue,
      isDefault: isDefault ?? this.isDefault,
      loading: loading ?? this.loading,
      saving: saving ?? this.saving,
      saved: saved ?? false,
      deleted: deleted ?? false,
      notFound: notFound ?? this.notFound,
      deletePromptCount: clearDeletePrompt
          ? null
          : (deletePromptCount ?? this.deletePromptCount),
      errorMessage: clearError ? null : errorMessage,
      savedCategoryId: savedCategoryId ?? this.savedCategoryId,
    );
  }
}
