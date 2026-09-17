class SettingsState {
  const SettingsState({required this.currencyCode, this.loading = false});

  final String currencyCode;
  final bool loading;

  static const initial = SettingsState(currencyCode: 'EGP', loading: true);

  SettingsState copyWith({String? currencyCode, bool? loading}) {
    return SettingsState(
      currencyCode: currencyCode ?? this.currencyCode,
      loading: loading ?? this.loading,
    );
  }
}
