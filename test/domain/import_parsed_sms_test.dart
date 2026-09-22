import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ledgr/data/db/app_database.dart';
import 'package:ledgr/data/repositories/category_repository_impl.dart';
import 'package:ledgr/data/repositories/sms_inbox_repository_impl.dart';
import 'package:ledgr/data/repositories/transaction_repository_impl.dart';
import 'package:ledgr/domain/repositories/sms_inbox_repository.dart';
import 'package:ledgr/domain/sms/sms_inbox_item.dart';
import 'package:ledgr/domain/sms/sms_inbox_status.dart';
import 'package:ledgr/domain/sms/sms_message.dart';
import 'package:ledgr/domain/usecases/create_transaction.dart';
import 'package:ledgr/domain/usecases/import_parsed_sms.dart';
import 'package:ledgr/domain/usecases/ingest_sms.dart';

const _cib = 'CIB: Purchase of EGP 250.00 at STARBUCKS using card ending 1234 '
    'on 15/09/2026. Available balance EGP 5,000.00';

class _FailingMarkImportedInbox implements SmsInboxRepository {
  _FailingMarkImportedInbox(this._inner);

  final SmsInboxRepository _inner;

  @override
  Stream<List<SmsInboxItem>> watchByStatus(SmsInboxStatus status) =>
      _inner.watchByStatus(status);

  @override
  Stream<int> watchReadyCount() => _inner.watchReadyCount();

  @override
  Future<SmsInboxItem?> getById(int id) => _inner.getById(id);

  @override
  Future<SmsInboxItem?> findByFingerprint(String fingerprint) =>
      _inner.findByFingerprint(fingerprint);

  @override
  Future<SmsInboxItem> insert(SmsInboxInsert row) => _inner.insert(row);

  @override
  Future<void> markImported({
    required int id,
    required int transactionId,
  }) {
    throw StateError('mark imported failed');
  }

  @override
  Future<void> markDismissed(int id) => _inner.markDismissed(id);

  @override
  Future<void> deleteAll() => _inner.deleteAll();
}

void main() {
  late AppDatabase db;

  setUp(() {
    db = AppDatabase.forTesting(NativeDatabase.memory());
  });

  tearDown(() async {
    await db.close();
  });

  test('failed markImported rolls back the ledger row', () async {
    final categories = CategoryRepositoryImpl(db);
    final inbox = SmsInboxRepositoryImpl(db);
    final transactions = TransactionRepositoryImpl(db);
    final ingest = IngestSms(inbox, categories);
    final importSms = ImportParsedSms(
      _FailingMarkImportedInbox(inbox),
      CreateTransaction(transactions, categories),
      db,
    );

    final ingested = await ingest(
      RawSms(
        sender: 'paste',
        body: _cib,
        receivedAt: DateTime(2026, 9, 15, 12),
      ),
    );

    await expectLater(
      importSms(
        inboxId: ingested.item.id,
        amount: ingested.item.amount!,
        type: ingested.item.type!,
        categoryId: ingested.item.suggestedCategoryId!,
        note: ingested.item.note,
        date: ingested.item.valueDate ?? DateTime(2026, 9, 15),
      ),
      throwsA(isA<StateError>()),
    );

    final remaining = await transactions.watchEntries().first;
    expect(remaining, isEmpty);
    final item = await inbox.getById(ingested.item.id);
    expect(item!.status, SmsInboxStatus.ready);
    expect(item.transactionId, isNull);
  });
}
