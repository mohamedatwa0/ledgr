import '../../domain/exceptions.dart';
import '../../l10n/app_localizations.dart';

String localizedLedgrError(AppLocalizations l10n, Object error) {
  if (error is DuplicateCategoryException) return l10n.duplicateCategory;
  if (error is DefaultCategoryException) return l10n.defaultCategoryProtected;
  if (error is SmsNotFoundException) return l10n.smsNotFound;
  if (error is SmsAlreadyImportedException) return l10n.smsAlreadyImported;
  if (error is TransactionNotFoundException) return l10n.transactionNotFound;
  if (error is CategoryNotFoundException) return l10n.categoryNotFound;
  if (error is LedgrException) {
    return localizedLedgrErrorMessage(l10n, error.message);
  }
  return localizedLedgrErrorMessage(l10n, error.toString());
}

String localizedLedgrErrorMessage(AppLocalizations l10n, String message) {
  switch (message) {
    case 'A category with that name already exists.':
      return l10n.duplicateCategory;
    case 'Default categories cannot be changed or deleted.':
      return l10n.defaultCategoryProtected;
    case 'That SMS is no longer in the inbox.':
      return l10n.smsNotFound;
    case 'This SMS has already been added to the ledger.':
      return l10n.smsAlreadyImported;
    case 'This entry is no longer in the ledger.':
    case 'Transaction not found.':
      return l10n.transactionNotFound;
    case 'This category is no longer available.':
    case 'Category not found.':
      return l10n.categoryNotFound;
    case 'Enter a category name.':
      return l10n.enterCategoryName;
    case 'Amount must be greater than 0.':
      return l10n.amountMustBePositive;
    case 'Choose a category.':
      return l10n.missingAmountAndCategory;
    case 'Category does not match Debit/Credit.':
      return l10n.categoryTypeMismatch;
    case 'The Other category is missing.':
      return l10n.otherCategoryMissing;
    case 'SMS not found.':
      return l10n.smsNotFound;
    default:
      return message;
  }
}
