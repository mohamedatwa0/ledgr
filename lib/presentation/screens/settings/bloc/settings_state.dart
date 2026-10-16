import '../../../../domain/models/app_locale.dart';
import '../../../../domain/models/app_theme_mode.dart';
import '../../../../domain/models/transaction_type.dart';

class SettingsState {
  const SettingsState({
    required this.currencyCode,
    this.themeMode = AppThemeMode.system,
    this.defaultEntryType = TransactionType.expense,
    this.locale = AppLocale.en,
    this.biometricLockEnabled = false,
    this.readyCount = 0,
    this.loading = false,
  });

  final String currencyCode;
  final AppThemeMode themeMode;
  final TransactionType defaultEntryType;
  final AppLocale locale;
  final bool biometricLockEnabled;
  final int readyCount;
  final bool loading;

  static const initial = SettingsState(currencyCode: 'EGP', loading: true);

  SettingsState copyWith({
    String? currencyCode,
    AppThemeMode? themeMode,
    TransactionType? defaultEntryType,
    AppLocale? locale,
    bool? biometricLockEnabled,
    int? readyCount,
    bool? loading,
  }) {
    return SettingsState(
      currencyCode: currencyCode ?? this.currencyCode,
      themeMode: themeMode ?? this.themeMode,
      defaultEntryType: defaultEntryType ?? this.defaultEntryType,
      locale: locale ?? this.locale,
      biometricLockEnabled: biometricLockEnabled ?? this.biometricLockEnabled,
      readyCount: readyCount ?? this.readyCount,
      loading: loading ?? this.loading,
    );
  }
}
