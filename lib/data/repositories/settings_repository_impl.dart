import 'package:drift/drift.dart';

import '../../domain/models/app_settings.dart';
import '../../domain/repositories/settings_repository.dart';
import '../db/app_database.dart';
import '../mappers.dart';

class SettingsRepositoryImpl implements SettingsRepository {
  SettingsRepositoryImpl(this._db);

  final AppDatabase _db;

  @override
  Stream<AppSettings> watch() {
    return (_db.select(_db.settingsRows)..where((s) => s.id.equals(1)))
        .watchSingle()
        .map(settingsFromRow);
  }

  @override
  Future<AppSettings> get() async {
    final row = await (_db.select(_db.settingsRows)
          ..where((s) => s.id.equals(1)))
        .getSingle();
    return settingsFromRow(row);
  }

  @override
  Future<void> setCurrencyCode(String currencyCode) {
    return (_db.update(_db.settingsRows)..where((s) => s.id.equals(1))).write(
      SettingsRowsCompanion(currencyCode: Value(currencyCode)),
    );
  }

  @override
  Future<void> setSmsLastScanAt(DateTime scannedAt) {
    return (_db.update(_db.settingsRows)..where((s) => s.id.equals(1))).write(
      SettingsRowsCompanion(smsLastScanAt: Value(scannedAt)),
    );
  }
}
