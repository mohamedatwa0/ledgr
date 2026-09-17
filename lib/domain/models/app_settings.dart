class AppSettings {
  const AppSettings({required this.currencyCode});

  final String currencyCode;

  static const initial = AppSettings(currencyCode: 'EGP');
}
