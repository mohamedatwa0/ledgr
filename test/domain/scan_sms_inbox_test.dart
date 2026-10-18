import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ledgr/data/db/app_database.dart';
import 'package:ledgr/data/repositories/category_repository_impl.dart';
import 'package:ledgr/data/repositories/settings_repository_impl.dart';
import 'package:ledgr/data/repositories/sms_inbox_repository_impl.dart';
import 'package:ledgr/domain/sms/sms_gateway.dart';
import 'package:ledgr/domain/sms/sms_message.dart';
import 'package:ledgr/domain/usecases/ingest_sms.dart';
import 'package:ledgr/domain/usecases/scan_sms_inbox.dart';

const _cib = 'CIB: Purchase of EGP 250.00 at STARBUCKS using card ending 1234 '
    'on 15/09/2026. Available balance EGP 5,000.00';

class _FakeGateway implements SmsGateway {
  List<RawSms> messages = const [];
  var throwOnRead = false;
  final acknowledged = <String>[];

  @override
  bool get inboxSupported => true;

  @override
  bool get shareImport => false;

  @override
  Future<bool> hasPermission() async => true;

  @override
  Future<bool> requestPermission() async => true;

  @override
  Future<List<RawSms>> readSince(DateTime? since, Set<String> senders) {
    if (throwOnRead) throw StateError('scan failed');
    return Future.value([
      for (final message in messages)
        if (since == null || message.receivedAt.isAfter(since)) message,
    ]);
  }

  @override
  Future<void> acknowledge(List<String> queueIds) async {
    acknowledged.addAll(queueIds);
  }

  @override
  Future<void> clearPending() async {}

  @override
  Future<bool> openImportSetup() async => false;

  @override
  Stream<RawSms> get incoming => const Stream.empty();

  @override
  Stream<String> get sharedText => const Stream.empty();

  @override
  Future<String?> takeInitialSharedText() async => null;
}

void main() {
  late AppDatabase db;
  late SettingsRepositoryImpl settings;
  late _FakeGateway gateway;
  late ScanSmsInbox scan;

  setUp(() {
    db = AppDatabase.forTesting(NativeDatabase.memory());
    settings = SettingsRepositoryImpl(db);
    gateway = _FakeGateway();
    scan = ScanSmsInbox(
      gateway,
      settings,
      IngestSms(SmsInboxRepositoryImpl(db), CategoryRepositoryImpl(db)),
    );
  });

  tearDown(() async {
    await db.close();
  });

  test('advances the cursor to the latest handled message', () async {
    gateway.messages = [
      RawSms(
        sender: 'Mom',
        body: 'See you at 7',
        receivedAt: DateTime(2026, 9, 1, 10),
      ),
      RawSms(
        sender: 'CIB',
        body: _cib,
        receivedAt: DateTime(2026, 9, 2, 12),
      ),
    ];

    final result = await scan();
    expect(result.failed, isFalse);
    expect(result.added, 1);
    expect((await settings.get()).smsLastScanAt, DateTime(2026, 9, 2, 12));
  });

  test('does not move the cursor when readSince throws', () async {
    await settings.setSmsLastScanAt(DateTime(2026, 8, 1));
    gateway.throwOnRead = true;

    final result = await scan();
    expect(result.failed, isTrue);
    expect(result.added, 0);
    expect((await settings.get()).smsLastScanAt, DateTime(2026, 8, 1));
  });

  test('skipped non-bank texts still advance the cursor', () async {
    gateway.messages = [
      RawSms(
        sender: 'Mom',
        body: 'Can you send me 50 EGP?',
        receivedAt: DateTime(2026, 9, 3, 8),
      ),
    ];

    final result = await scan();
    expect(result.failed, isFalse);
    expect(result.added, 0);
    expect((await settings.get()).smsLastScanAt, DateTime(2026, 9, 3, 8));
  });
}
