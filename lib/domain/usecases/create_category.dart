import '../exceptions.dart';
import '../models/category.dart';
import '../models/transaction_type.dart';
import '../repositories/category_repository.dart';

class CreateCategory {
  const CreateCategory(this._categories);

  final CategoryRepository _categories;

  Future<Category> call({
    required String name,
    required TransactionType type,
    required int iconCodePoint,
    required int colorValue,
  }) async {
    final trimmed = name.trim();
    if (trimmed.isEmpty) {
      throw const ValidationException('Enter a category name.');
    }
    final existing = await _categories.findByNameAndType(trimmed, type);
    if (existing != null) {
      throw const DuplicateCategoryException();
    }
    return _categories.create(
      name: trimmed,
      type: type,
      iconCodePoint: iconCodePoint,
      colorValue: colorValue,
    );
  }
}
