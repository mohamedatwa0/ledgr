class SupportedCurrency {
  const SupportedCurrency({
    required this.code,
    required this.symbol,
    required this.label,
  });

  final String code;
  final String symbol;
  final String label;
}

const supportedCurrencies = <SupportedCurrency>[
  SupportedCurrency(code: 'EGP', symbol: 'E£', label: 'Egyptian Pound'),
  SupportedCurrency(code: 'USD', symbol: r'$', label: 'US Dollar'),
  SupportedCurrency(code: 'EUR', symbol: '€', label: 'Euro'),
  SupportedCurrency(code: 'GBP', symbol: '£', label: 'British Pound'),
  SupportedCurrency(code: 'SAR', symbol: 'SAR', label: 'Saudi Riyal'),
  SupportedCurrency(code: 'AED', symbol: 'AED', label: 'UAE Dirham'),
];

SupportedCurrency currencyByCode(String code) {
  return supportedCurrencies.firstWhere(
    (c) => c.code == code,
    orElse: () => supportedCurrencies.first,
  );
}
