import '../exceptions.dart';
import '../repositories/category_repository.dart';

class DeleteCategory {
  const DeleteCategory(this._categories);

  final CategoryRepository _categories;

  Future<void> call(int id) async {
    final category = await _categories.getById(id);
    if (category == null) {
      throw const CategoryNotFoundException();
    }
    if (category.isDefault) {
      throw const DefaultCategoryException();
    }
    final other = await _categories.findOther(category.type);
    if (other == null) {
      throw const LedgrException('The Other category is missing.');
    }
    await _categories.reassignAndDelete(fromId: id, toId: other.id);
  }
}
