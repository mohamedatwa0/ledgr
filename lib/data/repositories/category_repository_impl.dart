import 'package:drift/drift.dart';

import '../../domain/models/category.dart';
import '../../domain/models/transaction_type.dart';
import '../../domain/repositories/category_repository.dart';
import '../db/app_database.dart';
import '../mappers.dart';

class CategoryRepositoryImpl implements CategoryRepository {
  CategoryRepositoryImpl(this._db);

  final AppDatabase _db;

  @override
  Stream<List<Category>> watchAll() {
    return (_db.select(_db.categoryRows)
          ..orderBy([(c) => OrderingTerm.asc(c.id)]))
        .watch()
        .map((rows) => rows.map(categoryFromRow).toList());
  }

  @override
  Stream<List<Category>> watchByType(TransactionType type) {
    return (_db.select(_db.categoryRows)
          ..where((c) => c.type.equalsValue(type))
          ..orderBy([(c) => OrderingTerm.asc(c.id)]))
        .watch()
        .map((rows) => rows.map(categoryFromRow).toList());
  }

  @override
  Future<Category?> getById(int id) async {
    final row = await (_db.select(_db.categoryRows)
          ..where((c) => c.id.equals(id)))
        .getSingleOrNull();
    return row == null ? null : categoryFromRow(row);
  }

  @override
  Future<Category?> findByNameAndType(
    String name,
    TransactionType type,
  ) async {
    final needle = name.trim().toLowerCase();
    final row = await (_db.select(_db.categoryRows)
          ..where(
            (c) => c.name.lower().equals(needle) & c.type.equalsValue(type),
          ))
        .getSingleOrNull();
    return row == null ? null : categoryFromRow(row);
  }

  @override
  Future<Category?> findOther(TransactionType type) async {
    final row = await (_db.select(_db.categoryRows)
          ..where(
            (c) => c.isFallback.equals(true) & c.type.equalsValue(type),
          ))
        .getSingleOrNull();
    return row == null ? null : categoryFromRow(row);
  }

  @override
  Future<Category> create({
    required String name,
    required TransactionType type,
    required int iconCodePoint,
    required int colorValue,
  }) async {
    final id = await _db.into(_db.categoryRows).insert(
          CategoryRowsCompanion.insert(
            name: name,
            type: type,
            iconCodePoint: iconCodePoint,
            colorValue: colorValue,
            isDefault: const Value(false),
            isFallback: const Value(false),
          ),
        );
    final created = await getById(id);
    return created!;
  }

  @override
  Future<void> update(Category category) {
    return _db.update(_db.categoryRows).replace(
          CategoryRow(
            id: category.id,
            name: category.name,
            type: category.type,
            iconCodePoint: category.iconCodePoint,
            colorValue: category.colorValue,
            isDefault: category.isDefault,
            isFallback: category.isFallback,
          ),
        );
  }

  @override
  Future<void> deleteById(int id) {
    return (_db.delete(_db.categoryRows)..where((c) => c.id.equals(id))).go();
  }

  @override
  Future<void> reassignAndDelete({required int fromId, required int toId}) {
    return _db.transaction(() async {
      await (_db.update(_db.transactionRows)
            ..where((t) => t.categoryId.equals(fromId)))
          .write(TransactionRowsCompanion(categoryId: Value(toId)));
      await (_db.delete(_db.categoryRows)..where((c) => c.id.equals(fromId)))
          .go();
    });
  }
}
