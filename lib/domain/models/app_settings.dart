import 'app_locale.dart';
import 'app_theme_mode.dart';
import 'transaction_type.dart';

class AppSettings {
  const AppSettings({
    required this.currencyCode,
    this.smsLastScanAt,
    this.themeMode = AppThemeMode.system,
    this.defaultEntryType = TransactionType.expense,
    this.locale = AppLocale.en,
  });

  final String currencyCode;
  final DateTime? smsLastScanAt;
  final AppThemeMode themeMode;
  final TransactionType defaultEntryType;
  final AppLocale locale;

  static const initial = AppSettings(currencyCode: 'EGP');
}
