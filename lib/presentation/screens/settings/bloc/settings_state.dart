class SettingsState {
  const SettingsState({
    required this.currencyCode,
    this.readyCount = 0,
    this.loading = false,
  });

  final String currencyCode;
  final int readyCount;
  final bool loading;

  static const initial = SettingsState(currencyCode: 'EGP', loading: true);

  SettingsState copyWith({
    String? currencyCode,
    int? readyCount,
    bool? loading,
  }) {
    return SettingsState(
      currencyCode: currencyCode ?? this.currencyCode,
      readyCount: readyCount ?? this.readyCount,
      loading: loading ?? this.loading,
    );
  }
}
