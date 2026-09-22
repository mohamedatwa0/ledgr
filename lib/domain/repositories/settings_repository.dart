import '../models/app_locale.dart';
import '../models/app_settings.dart';
import '../models/app_theme_mode.dart';
import '../models/transaction_type.dart';

abstract class SettingsRepository {
  Stream<AppSettings> watch();
  Future<AppSettings> get();
  Future<void> setCurrencyCode(String currencyCode);
  Future<void> setSmsLastScanAt(DateTime scannedAt);
  Future<void> setThemeMode(AppThemeMode themeMode);
  Future<void> setDefaultEntryType(TransactionType type);
  Future<void> setLocale(AppLocale locale);
}
