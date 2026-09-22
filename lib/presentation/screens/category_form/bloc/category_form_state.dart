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
  final int? deletePromptCount;
  final String? errorMessage;
  final int? savedCategoryId;

  bool get canSave =>
      name.trim().isNotEmpty && !saving && !loading && !isDefault;

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
      saved: saved ?? this.saved,
      deleted: deleted ?? this.deleted,
      deletePromptCount: clearDeletePrompt
          ? null
          : (deletePromptCount ?? this.deletePromptCount),
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      savedCategoryId: savedCategoryId ?? this.savedCategoryId,
    );
  }
}
