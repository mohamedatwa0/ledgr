import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get navDashboard => 'Dashboard';

  @override
  String get navTransactions => 'Transactions';

  @override
  String get navCategories => 'Categories';

  @override
  String get navSettings => 'Settings';

  @override
  String get newEntryTooltip => 'New entry';

  @override
  String get ledgerBook => 'LEDGER BOOK';

  @override
  String get thisMonth => 'THIS MONTH';

  @override
  String get thisMonthLabel => 'This month';

  @override
  String get credits => 'Credits';

  @override
  String get debits => 'Debits';

  @override
  String get previousMonth => 'Previous month';

  @override
  String get nextMonth => 'Next month';

  @override
  String depositCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count deposits',
      one: '$count deposit',
    );
    return '$_temp0';
  }

  @override
  String postingCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count postings',
      one: '$count posting',
    );
    return '$_temp0';
  }

  @override
  String hiddenDebitsLookup(String amount) {
    return 'Debits $amount';
  }

  @override
  String get dailyOutlayPace => 'Daily Outlay Pace';

  @override
  String perDayAverage(String symbol, String amount) {
    return '$symbol$amount / day average';
  }

  @override
  String get ledgerEntries => 'LEDGER ENTRIES';

  @override
  String postingsCount(int count) {
    return 'POSTINGS • $count';
  }

  @override
  String get emptyHomeTransactions => 'No transactions yet — tap + to add your first one';

  @override
  String get searchHint => 'Search by merchant, note, or amount...';

  @override
  String get filterAllRecords => 'All Records';

  @override
  String get filterDebitsOut => 'Debits (Out)';

  @override
  String get filterCreditsIn => 'Credits (In)';

  @override
  String entriesCount(int count) {
    return '$count ENTRIES';
  }

  @override
  String get emptyHistory => 'No transactions in this view';

  @override
  String postItemsCount(int count) {
    return '$count post items';
  }

  @override
  String get deleteEntry => 'Delete entry';

  @override
  String get deleteEntryMessage => 'Remove this transaction from the ledger?';

  @override
  String get categoriesTitle => 'Categories';

  @override
  String get ledgerNomenclature => 'LEDGER NOMENCLATURE';

  @override
  String get add => 'Add';

  @override
  String debitCategories(String count) {
    return 'Debit Categories ($count)';
  }

  @override
  String creditCategories(String count) {
    return 'Credit Categories ($count)';
  }

  @override
  String get defaultCategoriesProtected => 'Default categories with recorded ledger entries are protected from deletion.';

  @override
  String get defaultBadge => 'DEFAULT';

  @override
  String get newCategory => 'New category';

  @override
  String get editCategory => 'Edit category';

  @override
  String get addCategory => 'Add Category';

  @override
  String get editCategoryTitle => 'Edit Category';

  @override
  String get close => 'Close';

  @override
  String get back => 'Back';

  @override
  String get nameHint => 'Name';

  @override
  String get icon => 'Icon';

  @override
  String get color => 'Color';

  @override
  String get preview => 'Preview';

  @override
  String get deleteCategory => 'Delete category';

  @override
  String get deleteThisCategory => 'Delete this category?';

  @override
  String entriesWillMoveToOther(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count entries will move to Other.',
      one: '$count entry will move to Other.',
    );
    return '$_temp0';
  }

  @override
  String get saveCategory => 'Save category';

  @override
  String get newEntry => 'New Entry';

  @override
  String get editEntry => 'Edit Entry';

  @override
  String get entryValue => 'ENTRY VALUE';

  @override
  String get ledgerAccount => 'LEDGER ACCOUNT';

  @override
  String categoriesCount(int count) {
    return '$count Categories';
  }

  @override
  String get addNew => 'Add new';

  @override
  String get bookkeeperMemo => 'BOOKKEEPER MEMO';

  @override
  String get noteHint => 'Add note or counterparty (optional)...';

  @override
  String get transactionDate => 'TRANSACTION DATE';

  @override
  String get change => 'Change';

  @override
  String get missingAmountAndCategory => 'Enter an amount and choose a category';

  @override
  String get saveEntry => 'Save entry';

  @override
  String get offlineEntryNote => 'Offline deterministic entry • No cloud sync';

  @override
  String get debit => 'Debit';

  @override
  String get credit => 'Credit';

  @override
  String get debitExpense => 'Debit (Expense)';

  @override
  String get creditIncome => 'Credit (Income)';

  @override
  String get today => 'Today';

  @override
  String get yesterday => 'Yesterday';

  @override
  String todayWithDate(String date) {
    return 'Today, $date';
  }

  @override
  String yesterdayWithDate(String date) {
    return 'Yesterday, $date';
  }

  @override
  String get language => 'Language';

  @override
  String get languageSubtitle => 'English or Arabic interface';

  @override
  String get localeEn => 'EN';

  @override
  String get localeAr => 'ع';

  @override
  String get ledgrJournal => 'Ledgr Journal';

  @override
  String get journal => 'JOURNAL';

  @override
  String get physicalDriftStorage => 'Physical drift SQLite storage';

  @override
  String get offlineChip => '100% Offline';

  @override
  String get zeroAiChip => 'Zero AI / Cloud';

  @override
  String get activeConfiguration => 'Active Configuration';

  @override
  String get localVerified => 'LOCAL VERIFIED';

  @override
  String get baseCurrency => 'Base Currency';

  @override
  String get baseCurrencySubtitle => 'Deterministic single currency standard';

  @override
  String get defaultEntryType => 'Default Entry Type';

  @override
  String get defaultEntryTypeSubtitle => 'Primary recording column';

  @override
  String get appearance => 'Appearance';

  @override
  String get appearanceSubtitle => 'System, light, or nocturnal ledger';

  @override
  String get dataSovereignty => 'Data & Sovereignty';

  @override
  String get dataSovereigntySubtitle => 'SQLite file on this device';

  @override
  String get export => 'Export';

  @override
  String get bankSmsImport => 'Bank SMS Import';

  @override
  String get bankSmsImportSubtitle => 'Deterministic regex parser. No AI/NLP.';

  @override
  String readyToReview(int count) {
    return '$count to review';
  }

  @override
  String get upcomingModules => 'Upcoming Ledger Modules';

  @override
  String get phase2Plus => 'PHASE 2+';

  @override
  String get categoryBudgets => 'Category Budgets';

  @override
  String get categoryBudgetsSubtitle => 'Monthly allocation limits';

  @override
  String get phase3 => 'Phase 3';

  @override
  String get multiCurrency => 'Multi-Currency Ledger';

  @override
  String get multiCurrencySubtitle => 'Manual conversion ratios';

  @override
  String get phase4 => 'Phase 4';

  @override
  String get vaults => 'Vaults & Sovereign Net Worth';

  @override
  String get vaultsSubtitle => 'Aggregated accounts and assets';

  @override
  String get phase5 => 'Phase 5';

  @override
  String get resetLocalLedger => 'Reset Local Ledger Journal';

  @override
  String get settingsFooter => 'Architected for absolute manual agency and sovereign accounting. Zero cloud dependencies.';

  @override
  String get displayCurrency => 'Display currency';

  @override
  String get currencySymbolOnly => 'Changes the symbol only — amounts are not converted.';

  @override
  String get noLedgerFile => 'No ledger file to export yet';

  @override
  String get exportSubject => 'Ledgr journal export';

  @override
  String couldNotExport(String error) {
    return 'Could not export: $error';
  }

  @override
  String get resetLedgerTitle => 'Reset local ledger?';

  @override
  String get resetLedgerMessage => 'This deletes all transactions and SMS inbox items. Categories and settings stay.';

  @override
  String get reset => 'Reset';

  @override
  String get themeSystem => 'System';

  @override
  String get themeLight => 'Light';

  @override
  String get themeDark => 'Dark';

  @override
  String get currencyEgp => 'Egyptian Pound';

  @override
  String get currencyUsd => 'US Dollar';

  @override
  String get currencyEur => 'Euro';

  @override
  String get currencyGbp => 'British Pound';

  @override
  String get currencySar => 'Saudi Riyal';

  @override
  String get currencyAed => 'UAE Dirham';

  @override
  String get categoryFoodDining => 'Food & Dining';

  @override
  String get categoryTransport => 'Transport';

  @override
  String get categoryShopping => 'Shopping';

  @override
  String get categoryBillsUtilities => 'Bills & Utilities';

  @override
  String get categoryHealth => 'Health';

  @override
  String get categoryEntertainment => 'Entertainment';

  @override
  String get categoryTransfer => 'Transfer';

  @override
  String get categoryOther => 'Other';

  @override
  String get categorySalary => 'Salary';

  @override
  String get categoryFreelance => 'Freelance';

  @override
  String get bankSms => 'Bank SMS';

  @override
  String get smsInboxSupported => 'Ledgr reads only known bank senders. SMS access is for personal/sideload use — Google Play restricts this permission for expense apps.';

  @override
  String get smsInboxUnsupported => 'Inbox reading isn’t available on this device. Paste a bank SMS below.';

  @override
  String get pasteBankSms => 'Paste a bank SMS';

  @override
  String get parse => 'Parse';

  @override
  String get parsing => 'Parsing…';

  @override
  String get toReview => 'To review';

  @override
  String get unmatched => 'Unmatched';

  @override
  String get imported => 'Imported';

  @override
  String get emptyToReview => 'Nothing to review — paste a bank SMS or scan the inbox';

  @override
  String get emptyUnmatched => 'No unmatched messages';

  @override
  String get emptyImported => 'No imported SMS yet';

  @override
  String get skipSmsTitle => 'Skip this SMS?';

  @override
  String get skipSmsMessage => 'It will not be added to the ledger.';

  @override
  String get skip => 'Skip';

  @override
  String get inboxAccessGranted => 'Inbox access granted';

  @override
  String get allowSmsAccess => 'Allow SMS access to scan bank messages';

  @override
  String get scanInbox => 'Scan inbox';

  @override
  String get scanning => 'Scanning…';

  @override
  String get request => 'Request';

  @override
  String get confirmEntry => 'Confirm entry';

  @override
  String smsCurrencyMismatch(String code) {
    return 'SMS currency $code — stored as display currency, not converted.';
  }

  @override
  String get noteOptional => 'Note (optional)';

  @override
  String get alreadyInInbox => 'Already in the inbox';

  @override
  String get noNewBankMessages => 'No new bank messages';

  @override
  String foundMessagesToReview(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Found $count messages to review',
      one: 'Found $count message to review',
    );
    return '$_temp0';
  }

  @override
  String get cancel => 'Cancel';

  @override
  String get delete => 'Delete';

  @override
  String get discardEntryTitle => 'Discard this entry?';

  @override
  String get discardEntryMessage => 'The amount you entered will be lost.';

  @override
  String get discard => 'Discard';

  @override
  String get duplicateCategory => 'A category with that name already exists.';

  @override
  String get defaultCategoryProtected => 'Default categories cannot be changed or deleted.';

  @override
  String get smsNotFound => 'That SMS is no longer in the inbox.';

  @override
  String get smsAlreadyImported => 'This SMS has already been added to the ledger.';

  @override
  String get transactionNotFound => 'This entry is no longer in the ledger.';

  @override
  String get categoryNotFound => 'This category is no longer available.';

  @override
  String get enterCategoryName => 'Enter a category name.';

  @override
  String get amountMustBePositive => 'Amount must be greater than 0.';

  @override
  String get categoryTypeMismatch => 'Category does not match Debit/Credit.';

  @override
  String get otherCategoryMissing => 'The Other category is missing.';

  @override
  String get scanFailed => 'Could not scan the inbox.';
}
