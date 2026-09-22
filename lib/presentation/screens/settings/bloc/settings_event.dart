import '../../../../domain/models/app_locale.dart';
import '../../../../domain/models/app_settings.dart';
import '../../../../domain/models/app_theme_mode.dart';
import '../../../../domain/models/transaction_type.dart';

abstract class SettingsEvent {
  const SettingsEvent();
}

class SettingsStarted extends SettingsEvent {
  const SettingsStarted();
}

class SettingsCurrencySelected extends SettingsEvent {
  const SettingsCurrencySelected(this.currencyCode);

  final String currencyCode;
}

class SettingsThemeModeSelected extends SettingsEvent {
  const SettingsThemeModeSelected(this.themeMode);

  final AppThemeMode themeMode;
}

class SettingsDefaultTypeSelected extends SettingsEvent {
  const SettingsDefaultTypeSelected(this.type);

  final TransactionType type;
}

class SettingsLocaleSelected extends SettingsEvent {
  const SettingsLocaleSelected(this.locale);

  final AppLocale locale;
}

class SettingsResetRequested extends SettingsEvent {
  const SettingsResetRequested();
}

class SettingsUpdated extends SettingsEvent {
  const SettingsUpdated(this.settings);

  final AppSettings settings;
}

class SettingsReadyCountUpdated extends SettingsEvent {
  const SettingsReadyCountUpdated(this.readyCount);

  final int readyCount;
}
