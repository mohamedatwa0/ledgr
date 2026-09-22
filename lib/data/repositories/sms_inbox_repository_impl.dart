import 'package:drift/drift.dart';

import '../../domain/repositories/sms_inbox_repository.dart';
import '../../domain/sms/sms_inbox_item.dart';
import '../../domain/sms/sms_inbox_status.dart';
import '../db/app_database.dart';
import '../mappers.dart';

class SmsInboxRepositoryImpl implements SmsInboxRepository {
  SmsInboxRepositoryImpl(this._db);

  final AppDatabase _db;

  @override
  Stream<List<SmsInboxItem>> watchByStatus(SmsInboxStatus status) {
    final query = _db.select(_db.smsInboxRows)
      ..where((t) => t.status.equalsValue(status))
      ..orderBy([
        (t) => OrderingTerm.desc(t.receivedAt),
        (t) => OrderingTerm.desc(t.id),
      ]);
    return query.watch().map((rows) => rows.map(smsInboxFromRow).toList());
  }

  @override
  Stream<int> watchReadyCount() {
    final count = _db.smsInboxRows.id.count();
    final query = _db.selectOnly(_db.smsInboxRows)
      ..addColumns([count])
      ..where(
        _db.smsInboxRows.status.equalsValue(SmsInboxStatus.ready),
      );
    return query.watchSingle().map((row) => row.read(count) ?? 0);
  }

  @override
  Future<SmsInboxItem?> getById(int id) async {
    final row = await (_db.select(_db.smsInboxRows)
          ..where((t) => t.id.equals(id)))
        .getSingleOrNull();
    return row == null ? null : smsInboxFromRow(row);
  }

  @override
  Future<SmsInboxItem?> findByFingerprint(String fingerprint) async {
    final row = await (_db.select(_db.smsInboxRows)
          ..where((t) => t.fingerprint.equals(fingerprint)))
        .getSingleOrNull();
    return row == null ? null : smsInboxFromRow(row);
  }

  @override
  Future<SmsInboxItem> insert(SmsInboxInsert row) async {
    final id = await _db.into(_db.smsInboxRows).insert(
          SmsInboxRowsCompanion.insert(
            fingerprint: row.fingerprint,
            platformMessageId: Value(row.platformMessageId),
            sender: row.sender,
            body: row.body,
            receivedAt: row.receivedAt,
            createdAt: DateTime.now(),
            status: row.status,
            bankId: Value(row.bankId),
            templateId: Value(row.templateId),
            amount: Value(row.amount),
            type: Value(row.type),
            suggestedCategoryId: Value(row.suggestedCategoryId),
            note: Value(row.note),
            valueDate: Value(row.valueDate),
            currencyCode: Value(row.currencyCode),
          ),
        );
    final created = await getById(id);
    return created!;
  }

  @override
  Future<void> markImported({
    required int id,
    required int transactionId,
  }) {
    return (_db.update(_db.smsInboxRows)..where((t) => t.id.equals(id))).write(
      SmsInboxRowsCompanion(
        status: const Value(SmsInboxStatus.imported),
        transactionId: Value(transactionId),
      ),
    );
  }

  @override
  Future<void> markDismissed(int id) {
    return (_db.update(_db.smsInboxRows)..where((t) => t.id.equals(id))).write(
      const SmsInboxRowsCompanion(status: Value(SmsInboxStatus.dismissed)),
    );
  }

  @override
  Future<void> deleteAll() {
    return _db.delete(_db.smsInboxRows).go();
  }
}