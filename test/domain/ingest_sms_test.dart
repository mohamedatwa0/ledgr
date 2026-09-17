import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ledgr/data/db/app_database.dart';
import 'package:ledgr/data/repositories/category_repository_impl.dart';
import 'package:ledgr/data/repositories/sms_inbox_repository_impl.dart';
import 'package:ledgr/data/repositories/transaction_repository_impl.dart';
import 'package:ledgr/domain/models/transaction_source.dart';
import 'package:ledgr/domain/sms/sms_inbox_status.dart';
import 'package:ledgr/domain/sms/sms_message.dart';
import 'package:ledgr/domain/usecases/create_transaction.dart';
import 'package:ledgr/domain/usecases/import_parsed_sms.dart';
import 'package:ledgr/domain/usecases/ingest_sms.dart';

const _cib = 'CIB: Purchase of EGP 250.00 at STARBUCKS using card ending 1234 '
    'on 15/09/2026. Available balance EGP 5,000.00';

void main() {
  late AppDatabase db;
  late IngestSms ingest;
  late ImportParsedSms importSms;

  setUp(() {
    db = AppDatabase.forTesting(NativeDatabase.memory());
    final categories = CategoryRepositoryImpl(db);
    final inbox = SmsInboxRepositoryImpl(db);
    final transactions = TransactionRepositoryImpl(db);
    ingest = IngestSms(inbox, categories);
    importSms = ImportParsedSms(
      inbox,
      CreateTransaction(transactions, categories),
    );
  });

  tearDown(() async {
    await db.close();
  });

  RawSms paste() => RawSms(
        sender: 'paste',
        body: _cib,
        receivedAt: DateTime(2026, 9, 15, 12),
      );

  test('duplicate fingerprint is skipped', () async {
    final first = await ingest(paste());
    final second = await ingest(paste());
    expect(first.duplicate, isFalse);
    expect(second.duplicate, isTrue);
    expect(second.item.id, first.item.id);
    expect(first.item.status, SmsInboxStatus.ready);
  });

  test('ImportParsedSms writes CreateTransaction with source sms', () async {
    final ingested = await ingest(paste());
    final created = await importSms(
      inboxId: ingested.item.id,
      amount: ingested.item.amount!,
      type: ingested.item.type!,
      categoryId: ingested.item.suggestedCategoryId!,
      note: ingested.item.note,
      date: ingested.item.valueDate ?? DateTime(2026, 9, 15),
    );
    expect(created.source, TransactionSource.sms);
    expect(created.amount, 25000);

    final marked = await SmsInboxRepositoryImpl(db).getById(ingested.item.id);
    expect(marked!.status, SmsInboxStatus.imported);
    expect(marked.transactionId, created.id);
  });
}
