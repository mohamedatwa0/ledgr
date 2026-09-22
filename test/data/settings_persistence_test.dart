import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ledgr/data/db/app_database.dart';
import 'package:ledgr/data/repositories/settings_repository_impl.dart';
import 'package:ledgr/data/repositories/sms_inbox_repository_impl.dart';
import 'package:ledgr/data/repositories/transaction_repository_impl.dart';
import 'package:ledgr/domain/models/app_locale.dart';
import 'package:ledgr/domain/models/app_theme_mode.dart';
import 'package:ledgr/domain/models/transaction_type.dart';
import 'package:ledgr/domain/sms/sms_inbox_item.dart';
import 'package:ledgr/domain/sms/sms_inbox_status.dart';
import 'package:ledgr/domain/usecases/reset_ledger.dart';

void main() {
  late AppDatabase db;
  late SettingsRepositoryImpl settings;

  setUp(() async {
    db = AppDatabase.forTesting(NativeDatabase.memory());
    settings = SettingsRepositoryImpl(db);
    await db.customSelect('select 1 from app_settings').get();
  });

  tearDown(() async {
    await db.close();
  });

  test('persists theme mode, locale, and default entry type', () async {
    await settings.setThemeMode(AppThemeMode.dark);
    await settings.setDefaultEntryType(TransactionType.income);
    await settings.setLocale(AppLocale.ar);

    final stored = await settings.get();
    expect(stored.themeMode, AppThemeMode.dark);
    expect(stored.defaultEntryType, TransactionType.income);
    expect(stored.locale, AppLocale.ar);
  });

  test('reset wipes transactions and sms inbox', () async {
    final transactions = TransactionRepositoryImpl(db);
    final sms = SmsInboxRepositoryImpl(db);
    await transactions.create(
      amount: 2500,
      type: TransactionType.expense,
      categoryId: 1,
      date: DateTime(2026, 9, 1),
    );
    await sms.insert(
      SmsInboxInsert(
        fingerprint: 'reset-test',
        sender: 'CIB',
        body: 'Purchase of EGP 10.00',
        receivedAt: DateTime(2026, 9, 1),
        status: SmsInboxStatus.ready,
      ),
    );

    final reset = ResetLedger(transactions: transactions, smsInbox: sms);
    await reset();

    final remaining = await transactions.watchEntries().first;
    expect(remaining, isEmpty);
    final inbox = await sms.watchByStatus(SmsInboxStatus.ready).first;
    expect(inbox, isEmpty);
    final settingsAfter = await settings.get();
    expect(settingsAfter.currencyCode, 'EGP');
    expect(settingsAfter.themeMode, AppThemeMode.system);
    expect(settingsAfter.locale, AppLocale.en);
  });
}
