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

class SettingsUpdated extends SettingsEvent {
  const SettingsUpdated(this.currencyCode);

  final String currencyCode;
}
