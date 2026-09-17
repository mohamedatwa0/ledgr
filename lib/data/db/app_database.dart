import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import '../../domain/models/transaction_source.dart';
import '../../domain/models/transaction_type.dart';
import '../../domain/sms/sms_inbox_status.dart';
import 'seed.dart';
import 'tables.dart';

part 'app_database.g.dart';

@DriftDatabase(
  tables: [CategoryRows, TransactionRows, SettingsRows, SmsInboxRows],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  AppDatabase.forTesting(super.e);

  @override
  int get schemaVersion => 3;

  @override
  MigrationStrategy get migration {
    return MigrationStrategy(
      onCreate: (m) async {
        await m.createAll();
        await _createTransactionIndexes(m);
        await _createSmsInboxIndexes(m);
        await seedDatabase(this);
      },
      onUpgrade: (m, from, to) async {
        if (from < 2) {
          await m.alterTable(
            TableMigration(
              transactionRows,
              columnTransformer: {
                transactionRows.amount: const CustomExpression<int>(
                  'CAST(ROUND(amount * 100) AS INTEGER)',
                ),
              },
            ),
          );
          await m.addColumn(categoryRows, categoryRows.isFallback);
          await customStatement(
            'UPDATE categories SET is_fallback = 1 WHERE name = \'Other\' AND is_default = 1',
          );
          await _createTransactionIndexes(m);
        }
        if (from < 3) {
          await m.addColumn(settingsRows, settingsRows.smsLastScanAt);
          await m.createTable(smsInboxRows);
          await _createSmsInboxIndexes(m);
        }
      },
    );
  }

  Future<void> _createTransactionIndexes(Migrator m) {
    return Future.wait([
      m.createIndex(
        Index(
          'idx_transactions_date',
          'CREATE INDEX IF NOT EXISTS idx_transactions_date '
              'ON transactions (date)',
        ),
      ),
      m.createIndex(
        Index(
          'idx_transactions_category_id',
          'CREATE INDEX IF NOT EXISTS idx_transactions_category_id '
              'ON transactions (category_id)',
        ),
      ),
    ]);
  }

  Future<void> _createSmsInboxIndexes(Migrator m) {
    return Future.wait([
      m.createIndex(
        Index(
          'idx_sms_inbox_status',
          'CREATE INDEX IF NOT EXISTS idx_sms_inbox_status '
              'ON sms_inbox (status)',
        ),
      ),
      m.createIndex(
        Index(
          'idx_sms_inbox_received_at',
          'CREATE INDEX IF NOT EXISTS idx_sms_inbox_received_at '
              'ON sms_inbox (received_at)',
        ),
      ),
    ]);
  }
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dir = await getApplicationDocumentsDirectory();
    final file = File(p.join(dir.path, 'ledgr.sqlite'));
    return NativeDatabase.createInBackground(file);
  });
}
