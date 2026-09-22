import '../../l10n/app_localizations.dart';

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

String localizedCurrencyLabel(AppLocalizations l10n, String code) {
  switch (code) {
    case 'EGP':
      return l10n.currencyEgp;
    case 'USD':
      return l10n.currencyUsd;
    case 'EUR':
      return l10n.currencyEur;
    case 'GBP':
      return l10n.currencyGbp;
    case 'SAR':
      return l10n.currencySar;
    case 'AED':
      return l10n.currencyAed;
    default:
      return currencyByCode(code).label;
  }
}
