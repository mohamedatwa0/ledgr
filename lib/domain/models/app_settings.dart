class AppSettings {
  const AppSettings({
    required this.currencyCode,
    this.smsLastScanAt,
  });

  final String currencyCode;
  final DateTime? smsLastScanAt;

  static const initial = AppSettings(currencyCode: 'EGP');
}
