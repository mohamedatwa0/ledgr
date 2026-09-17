import '../models/app_settings.dart';

abstract class SettingsRepository {
  Stream<AppSettings> watch();
  Future<AppSettings> get();
  Future<void> setCurrencyCode(String currencyCode);
  Future<void> setSmsLastScanAt(DateTime scannedAt);
}
