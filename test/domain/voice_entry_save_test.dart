import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ledgr/data/db/app_database.dart';
import 'package:ledgr/data/repositories/category_repository_impl.dart';
import 'package:ledgr/data/repositories/settings_repository_impl.dart';
import 'package:ledgr/data/repositories/transaction_repository_impl.dart';
import 'package:ledgr/domain/models/transaction_type.dart';
import 'package:ledgr/domain/usecases/create_category.dart';
import 'package:ledgr/domain/usecases/create_transaction.dart';
import 'package:ledgr/domain/usecases/delete_transaction.dart';
import 'package:ledgr/domain/usecases/update_transaction.dart';
import 'package:ledgr/domain/voice/parse_voice_entry.dart';
import 'package:ledgr/presentation/screens/add_transaction/bloc/add_transaction_bloc.dart';
import 'package:ledgr/presentation/screens/add_transaction/bloc/add_transaction_event.dart';

void main() {
  late AppDatabase db;
  late CategoryRepositoryImpl categories;
  late TransactionRepositoryImpl transactions;
  late SettingsRepositoryImpl settings;

  setUp(() {
    db = AppDatabase.forTesting(NativeDatabase.memory());
    categories = CategoryRepositoryImpl(db);
    transactions = TransactionRepositoryImpl(db);
    settings = SettingsRepositoryImpl(db);
  });

  tearDown(() async {
    await db.close();
  });

  Future<void> saveDraft(ParsedVoiceEntry draft) async {
    final bloc = AddTransactionBloc(
      transactions: transactions,
      categories: categories,
      settings: settings,
      createTransaction: CreateTransaction(transactions, categories),
      updateTransaction: UpdateTransaction(transactions, categories),
      deleteTransaction: DeleteTransaction(transactions),
      createCategory: CreateCategory(categories),
      voiceDraft: draft,
    )..add(const AddTransactionStarted());
    await bloc.stream.firstWhere(
      (state) =>
          !state.categoriesLoading &&
          (state.hasPendingCategory || state.categoryId != null) &&
          state.amountText.isNotEmpty,
    );
    bloc.add(const AddTransactionSaveRequested());
    await bloc.stream.firstWhere((state) => state.saved);
    await bloc.close();
  }

  test('voice draft creates a category and reuses it on the next save', () async {
    final draft = parseVoiceEntry('انا اشتريت علبه سجاير ب ١٠٠ جنيه');

    await saveDraft(draft);
    await saveDraft(draft);

    final created = await categories.findByNameAndType(
      'سجاير',
      TransactionType.expense,
    );
    expect(created, isNotNull);

    final sameName = await categories.watchByType(TransactionType.expense).first;
    expect(sameName.where((category) => category.name == 'سجاير').length, 1);

    final entries = await transactions.watchEntries().first;
    expect(entries.length, 2);
    expect(
      entries.every((entry) => entry.transaction.amount == 10000),
      isTrue,
    );
    expect(
      entries.every((entry) => entry.category.id == created!.id),
      isTrue,
    );
  });
}
