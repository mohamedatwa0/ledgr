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

class SettingsCurrencyUpdated extends SettingsEvent {
  const SettingsCurrencyUpdated(this.currencyCode);

  final String currencyCode;
}

class SettingsReadyCountUpdated extends SettingsEvent {
  const SettingsReadyCountUpdated(this.readyCount);

  final int readyCount;
}
