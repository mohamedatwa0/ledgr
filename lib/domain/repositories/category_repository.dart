import '../models/category.dart';
import '../models/transaction_type.dart';

abstract class CategoryRepository {
  Stream<List<Category>> watchByType(TransactionType type);
  Stream<List<Category>> watchAll();
  Future<Category?> getById(int id);
  Future<Category?> findByNameAndType(String name, TransactionType type);
  Future<Category?> findOther(TransactionType type);
  Future<Category> create({
    required String name,
    required TransactionType type,
    required int iconCodePoint,
    required int colorValue,
  });
  Future<void> update(Category category);
  Future<void> deleteById(int id);
  Future<void> reassignAndDelete({required int fromId, required int toId});
}
