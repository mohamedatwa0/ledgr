import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ledgr/data/db/app_database.dart';
import 'package:ledgr/data/repositories/category_repository_impl.dart';
import 'package:ledgr/data/repositories/transaction_repository_impl.dart';
import 'package:ledgr/domain/exceptions.dart';
import 'package:ledgr/domain/models/transaction_command.dart';
import 'package:ledgr/domain/models/transaction_type.dart';
import 'package:ledgr/domain/usecases/update_transaction.dart';

void main() {
  late AppDatabase db;
  late UpdateTransaction updateTransaction;
  late CategoryRepositoryImpl categories;

  setUp(() {
    db = AppDatabase.forTesting(NativeDatabase.memory());
    categories = CategoryRepositoryImpl(db);
    updateTransaction = UpdateTransaction(
      TransactionRepositoryImpl(db),
      categories,
    );
  });

  tearDown(() async {
    await db.close();
  });

  test('UpdateTransaction throws when the row is gone', () async {
    final food =
        await categories.findByNameAndType('Food & Dining', TransactionType.expense);
    expect(
      () => updateTransaction(
        999,
        TransactionCommand(
          amount: 4500,
          type: TransactionType.expense,
          categoryId: food!.id,
          date: DateTime(2026, 9, 15),
        ),
      ),
      throwsA(isA<TransactionNotFoundException>()),
    );
  });
}
