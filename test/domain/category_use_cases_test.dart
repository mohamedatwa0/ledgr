import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ledgr/data/db/app_database.dart';
import 'package:ledgr/data/repositories/category_repository_impl.dart';
import 'package:ledgr/data/repositories/transaction_repository_impl.dart';
import 'package:ledgr/domain/exceptions.dart';
import 'package:ledgr/domain/models/transaction_type.dart';
import 'package:ledgr/domain/usecases/create_category.dart';
import 'package:ledgr/domain/usecases/delete_category.dart';

void main() {
  late AppDatabase db;
  late CategoryRepositoryImpl categories;
  late TransactionRepositoryImpl transactions;
  late CreateCategory createCategory;
  late DeleteCategory deleteCategory;

  setUp(() {
    db = AppDatabase.forTesting(NativeDatabase.memory());
    categories = CategoryRepositoryImpl(db);
    transactions = TransactionRepositoryImpl(db);
    createCategory = CreateCategory(categories);
    deleteCategory = DeleteCategory(categories);
  });

  tearDown(() async {
    await db.close();
  });

  test('CreateCategory rejects a case-insensitive duplicate', () async {
    await createCategory(
      name: 'Pets',
      type: TransactionType.expense,
      iconCodePoint: 1,
      colorValue: 0xFF1C2B3A,
    );

    expect(
      () => createCategory(
        name: 'pets',
        type: TransactionType.expense,
        iconCodePoint: 1,
        colorValue: 0xFF1C2B3A,
      ),
      throwsA(isA<DuplicateCategoryException>()),
    );
  });

  test('DeleteCategory reassigns entries to fallback Other', () async {
    final custom = await createCategory(
      name: 'Pets',
      type: TransactionType.expense,
      iconCodePoint: 1,
      colorValue: 0xFF1C2B3A,
    );
    final other = await categories.findOther(TransactionType.expense);
    expect(other, isNotNull);
    expect(other!.isFallback, isTrue);

    await transactions.create(
      amount: 4500,
      type: TransactionType.expense,
      categoryId: custom.id,
      date: DateTime(2026, 9, 15),
    );

    await deleteCategory(custom.id);

    expect(await categories.getById(custom.id), isNull);
    expect(await transactions.countForCategory(other.id), 1);
  });

  test('DeleteCategory refuses default categories', () async {
    final other = await categories.findOther(TransactionType.expense);
    expect(other, isNotNull);

    expect(
      () => deleteCategory(other!.id),
      throwsA(isA<DefaultCategoryException>()),
    );
  });
}
