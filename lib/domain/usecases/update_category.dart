import '../exceptions.dart';
import '../models/category.dart';
import '../repositories/category_repository.dart';

class UpdateCategory {
  const UpdateCategory(this._categories);

  final CategoryRepository _categories;

  Future<void> call(Category category) async {
    if (category.isDefault) {
      throw const DefaultCategoryException();
    }
    final trimmed = category.name.trim();
    if (trimmed.isEmpty) {
      throw const ValidationException('Enter a category name.');
    }
    final existing = await _categories.findByNameAndType(trimmed, category.type);
    if (existing != null && existing.id != category.id) {
      throw const DuplicateCategoryException();
    }
    await _categories.update(
      Category(
        id: category.id,
        name: trimmed,
        type: category.type,
        iconCodePoint: category.iconCodePoint,
        colorValue: category.colorValue,
        isDefault: false,
        isFallback: category.isFallback,
      ),
    );
  }
}
