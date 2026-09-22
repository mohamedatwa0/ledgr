import '../../l10n/app_localizations.dart';

String localizedCategoryName(AppLocalizations l10n, String name) {
  switch (name) {
    case 'Food & Dining':
      return l10n.categoryFoodDining;
    case 'Transport':
      return l10n.categoryTransport;
    case 'Shopping':
      return l10n.categoryShopping;
    case 'Bills & Utilities':
      return l10n.categoryBillsUtilities;
    case 'Health':
      return l10n.categoryHealth;
    case 'Entertainment':
      return l10n.categoryEntertainment;
    case 'Transfer':
      return l10n.categoryTransfer;
    case 'Other':
      return l10n.categoryOther;
    case 'Salary':
      return l10n.categorySalary;
    case 'Freelance':
      return l10n.categoryFreelance;
    default:
      return name;
  }
}
