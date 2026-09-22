import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale) : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ar'),
    Locale('en')
  ];

  /// No description provided for @navDashboard.
  ///
  /// In en, this message translates to:
  /// **'Dashboard'**
  String get navDashboard;

  /// No description provided for @navTransactions.
  ///
  /// In en, this message translates to:
  /// **'Transactions'**
  String get navTransactions;

  /// No description provided for @navCategories.
  ///
  /// In en, this message translates to:
  /// **'Categories'**
  String get navCategories;

  /// No description provided for @navSettings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get navSettings;

  /// No description provided for @newEntryTooltip.
  ///
  /// In en, this message translates to:
  /// **'New entry'**
  String get newEntryTooltip;

  /// No description provided for @ledgerBook.
  ///
  /// In en, this message translates to:
  /// **'LEDGER BOOK'**
  String get ledgerBook;

  /// No description provided for @thisMonth.
  ///
  /// In en, this message translates to:
  /// **'THIS MONTH'**
  String get thisMonth;

  /// No description provided for @thisMonthLabel.
  ///
  /// In en, this message translates to:
  /// **'This month'**
  String get thisMonthLabel;

  /// No description provided for @credits.
  ///
  /// In en, this message translates to:
  /// **'Credits'**
  String get credits;

  /// No description provided for @debits.
  ///
  /// In en, this message translates to:
  /// **'Debits'**
  String get debits;

  /// No description provided for @previousMonth.
  ///
  /// In en, this message translates to:
  /// **'Previous month'**
  String get previousMonth;

  /// No description provided for @nextMonth.
  ///
  /// In en, this message translates to:
  /// **'Next month'**
  String get nextMonth;

  /// No description provided for @depositCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{{count} deposit} other{{count} deposits}}'**
  String depositCount(int count);

  /// No description provided for @postingCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{{count} posting} other{{count} postings}}'**
  String postingCount(int count);

  /// No description provided for @hiddenDebitsLookup.
  ///
  /// In en, this message translates to:
  /// **'Debits {amount}'**
  String hiddenDebitsLookup(String amount);

  /// No description provided for @dailyOutlayPace.
  ///
  /// In en, this message translates to:
  /// **'Daily Outlay Pace'**
  String get dailyOutlayPace;

  /// No description provided for @perDayAverage.
  ///
  /// In en, this message translates to:
  /// **'{symbol}{amount} / day average'**
  String perDayAverage(String symbol, String amount);

  /// No description provided for @ledgerEntries.
  ///
  /// In en, this message translates to:
  /// **'LEDGER ENTRIES'**
  String get ledgerEntries;

  /// No description provided for @postingsCount.
  ///
  /// In en, this message translates to:
  /// **'POSTINGS • {count}'**
  String postingsCount(int count);

  /// No description provided for @emptyHomeTransactions.
  ///
  /// In en, this message translates to:
  /// **'No transactions yet — tap + to add your first one'**
  String get emptyHomeTransactions;

  /// No description provided for @searchHint.
  ///
  /// In en, this message translates to:
  /// **'Search by merchant, note, or amount...'**
  String get searchHint;

  /// No description provided for @filterAllRecords.
  ///
  /// In en, this message translates to:
  /// **'All Records'**
  String get filterAllRecords;

  /// No description provided for @filterDebitsOut.
  ///
  /// In en, this message translates to:
  /// **'Debits (Out)'**
  String get filterDebitsOut;

  /// No description provided for @filterCreditsIn.
  ///
  /// In en, this message translates to:
  /// **'Credits (In)'**
  String get filterCreditsIn;

  /// No description provided for @entriesCount.
  ///
  /// In en, this message translates to:
  /// **'{count} ENTRIES'**
  String entriesCount(int count);

  /// No description provided for @emptyHistory.
  ///
  /// In en, this message translates to:
  /// **'No transactions in this view'**
  String get emptyHistory;

  /// No description provided for @postItemsCount.
  ///
  /// In en, this message translates to:
  /// **'{count} post items'**
  String postItemsCount(int count);

  /// No description provided for @deleteEntry.
  ///
  /// In en, this message translates to:
  /// **'Delete entry'**
  String get deleteEntry;

  /// No description provided for @deleteEntryMessage.
  ///
  /// In en, this message translates to:
  /// **'Remove this transaction from the ledger?'**
  String get deleteEntryMessage;

  /// No description provided for @categoriesTitle.
  ///
  /// In en, this message translates to:
  /// **'Categories'**
  String get categoriesTitle;

  /// No description provided for @ledgerNomenclature.
  ///
  /// In en, this message translates to:
  /// **'LEDGER NOMENCLATURE'**
  String get ledgerNomenclature;

  /// No description provided for @add.
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get add;

  /// No description provided for @debitCategories.
  ///
  /// In en, this message translates to:
  /// **'Debit Categories ({count})'**
  String debitCategories(String count);

  /// No description provided for @creditCategories.
  ///
  /// In en, this message translates to:
  /// **'Credit Categories ({count})'**
  String creditCategories(String count);

  /// No description provided for @defaultCategoriesProtected.
  ///
  /// In en, this message translates to:
  /// **'Default categories with recorded ledger entries are protected from deletion.'**
  String get defaultCategoriesProtected;

  /// No description provided for @defaultBadge.
  ///
  /// In en, this message translates to:
  /// **'DEFAULT'**
  String get defaultBadge;

  /// No description provided for @newCategory.
  ///
  /// In en, this message translates to:
  /// **'New Category'**
  String get newCategory;

  /// No description provided for @accountType.
  ///
  /// In en, this message translates to:
  /// **'Account type'**
  String get accountType;

  /// No description provided for @categoryName.
  ///
  /// In en, this message translates to:
  /// **'Category name'**
  String get categoryName;

  /// No description provided for @categoryIcon.
  ///
  /// In en, this message translates to:
  /// **'Category icon'**
  String get categoryIcon;

  /// No description provided for @colorTone.
  ///
  /// In en, this message translates to:
  /// **'Color tone'**
  String get colorTone;

  /// No description provided for @expenseDebit.
  ///
  /// In en, this message translates to:
  /// **'Expense (Debit)'**
  String get expenseDebit;

  /// No description provided for @incomeCredit.
  ///
  /// In en, this message translates to:
  /// **'Income (Credit)'**
  String get incomeCredit;

  /// No description provided for @editCategory.
  ///
  /// In en, this message translates to:
  /// **'Edit category'**
  String get editCategory;

  /// No description provided for @addCategory.
  ///
  /// In en, this message translates to:
  /// **'Add Category'**
  String get addCategory;

  /// No description provided for @editCategoryTitle.
  ///
  /// In en, this message translates to:
  /// **'Edit Category'**
  String get editCategoryTitle;

  /// No description provided for @close.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get close;

  /// No description provided for @back.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get back;

  /// No description provided for @nameHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. Coffee, Freelance, Books'**
  String get nameHint;

  /// No description provided for @icon.
  ///
  /// In en, this message translates to:
  /// **'Icon'**
  String get icon;

  /// No description provided for @color.
  ///
  /// In en, this message translates to:
  /// **'Color'**
  String get color;

  /// No description provided for @preview.
  ///
  /// In en, this message translates to:
  /// **'Preview'**
  String get preview;

  /// No description provided for @deleteCategory.
  ///
  /// In en, this message translates to:
  /// **'Delete category'**
  String get deleteCategory;

  /// No description provided for @deleteThisCategory.
  ///
  /// In en, this message translates to:
  /// **'Delete this category?'**
  String get deleteThisCategory;

  /// No description provided for @entriesWillMoveToOther.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{{count} entry will move to Other.} other{{count} entries will move to Other.}}'**
  String entriesWillMoveToOther(int count);

  /// No description provided for @saveCategory.
  ///
  /// In en, this message translates to:
  /// **'Save category'**
  String get saveCategory;

  /// No description provided for @newEntry.
  ///
  /// In en, this message translates to:
  /// **'New Entry'**
  String get newEntry;

  /// No description provided for @editEntry.
  ///
  /// In en, this message translates to:
  /// **'Edit Entry'**
  String get editEntry;

  /// No description provided for @entryValue.
  ///
  /// In en, this message translates to:
  /// **'ENTRY VALUE'**
  String get entryValue;

  /// No description provided for @ledgerAccount.
  ///
  /// In en, this message translates to:
  /// **'LEDGER ACCOUNT'**
  String get ledgerAccount;

  /// No description provided for @categoriesCount.
  ///
  /// In en, this message translates to:
  /// **'{count} Categories'**
  String categoriesCount(int count);

  /// No description provided for @addNew.
  ///
  /// In en, this message translates to:
  /// **'Add new'**
  String get addNew;

  /// No description provided for @bookkeeperMemo.
  ///
  /// In en, this message translates to:
  /// **'BOOKKEEPER MEMO'**
  String get bookkeeperMemo;

  /// No description provided for @noteHint.
  ///
  /// In en, this message translates to:
  /// **'Add note or counterparty (optional)...'**
  String get noteHint;

  /// No description provided for @transactionDate.
  ///
  /// In en, this message translates to:
  /// **'TRANSACTION DATE'**
  String get transactionDate;

  /// No description provided for @change.
  ///
  /// In en, this message translates to:
  /// **'Change'**
  String get change;

  /// No description provided for @missingAmountAndCategory.
  ///
  /// In en, this message translates to:
  /// **'Enter an amount and choose a category'**
  String get missingAmountAndCategory;

  /// No description provided for @saveEntry.
  ///
  /// In en, this message translates to:
  /// **'Save entry'**
  String get saveEntry;

  /// No description provided for @offlineEntryNote.
  ///
  /// In en, this message translates to:
  /// **'Offline deterministic entry • No cloud sync'**
  String get offlineEntryNote;

  /// No description provided for @debit.
  ///
  /// In en, this message translates to:
  /// **'Debit'**
  String get debit;

  /// No description provided for @credit.
  ///
  /// In en, this message translates to:
  /// **'Credit'**
  String get credit;

  /// No description provided for @debitExpense.
  ///
  /// In en, this message translates to:
  /// **'Debit (Expense)'**
  String get debitExpense;

  /// No description provided for @creditIncome.
  ///
  /// In en, this message translates to:
  /// **'Credit (Income)'**
  String get creditIncome;

  /// No description provided for @today.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get today;

  /// No description provided for @yesterday.
  ///
  /// In en, this message translates to:
  /// **'Yesterday'**
  String get yesterday;

  /// No description provided for @todayWithDate.
  ///
  /// In en, this message translates to:
  /// **'Today, {date}'**
  String todayWithDate(String date);

  /// No description provided for @yesterdayWithDate.
  ///
  /// In en, this message translates to:
  /// **'Yesterday, {date}'**
  String yesterdayWithDate(String date);

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @languageSubtitle.
  ///
  /// In en, this message translates to:
  /// **'English or Arabic interface'**
  String get languageSubtitle;

  /// No description provided for @localeEn.
  ///
  /// In en, this message translates to:
  /// **'EN'**
  String get localeEn;

  /// No description provided for @localeAr.
  ///
  /// In en, this message translates to:
  /// **'ع'**
  String get localeAr;

  /// No description provided for @ledgrJournal.
  ///
  /// In en, this message translates to:
  /// **'Ledgr Journal'**
  String get ledgrJournal;

  /// No description provided for @journal.
  ///
  /// In en, this message translates to:
  /// **'JOURNAL'**
  String get journal;

  /// No description provided for @physicalDriftStorage.
  ///
  /// In en, this message translates to:
  /// **'Physical drift SQLite storage'**
  String get physicalDriftStorage;

  /// No description provided for @offlineChip.
  ///
  /// In en, this message translates to:
  /// **'100% Offline'**
  String get offlineChip;

  /// No description provided for @zeroAiChip.
  ///
  /// In en, this message translates to:
  /// **'Zero AI / Cloud'**
  String get zeroAiChip;

  /// No description provided for @activeConfiguration.
  ///
  /// In en, this message translates to:
  /// **'Active Configuration'**
  String get activeConfiguration;

  /// No description provided for @localVerified.
  ///
  /// In en, this message translates to:
  /// **'LOCAL VERIFIED'**
  String get localVerified;

  /// No description provided for @baseCurrency.
  ///
  /// In en, this message translates to:
  /// **'Base Currency'**
  String get baseCurrency;

  /// No description provided for @baseCurrencySubtitle.
  ///
  /// In en, this message translates to:
  /// **'Deterministic single currency standard'**
  String get baseCurrencySubtitle;

  /// No description provided for @defaultEntryType.
  ///
  /// In en, this message translates to:
  /// **'Default Entry Type'**
  String get defaultEntryType;

  /// No description provided for @defaultEntryTypeSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Primary recording column'**
  String get defaultEntryTypeSubtitle;

  /// No description provided for @appearance.
  ///
  /// In en, this message translates to:
  /// **'Appearance'**
  String get appearance;

  /// No description provided for @appearanceSubtitle.
  ///
  /// In en, this message translates to:
  /// **'System, light, or nocturnal ledger'**
  String get appearanceSubtitle;

  /// No description provided for @dataSovereignty.
  ///
  /// In en, this message translates to:
  /// **'Data & Sovereignty'**
  String get dataSovereignty;

  /// No description provided for @dataSovereigntySubtitle.
  ///
  /// In en, this message translates to:
  /// **'SQLite file on this device'**
  String get dataSovereigntySubtitle;

  /// No description provided for @export.
  ///
  /// In en, this message translates to:
  /// **'Export'**
  String get export;

  /// No description provided for @bankSmsImport.
  ///
  /// In en, this message translates to:
  /// **'Bank SMS Import'**
  String get bankSmsImport;

  /// No description provided for @bankSmsImportSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Deterministic regex parser. No AI/NLP.'**
  String get bankSmsImportSubtitle;

  /// No description provided for @readyToReview.
  ///
  /// In en, this message translates to:
  /// **'{count} to review'**
  String readyToReview(int count);

  /// No description provided for @upcomingModules.
  ///
  /// In en, this message translates to:
  /// **'Upcoming Ledger Modules'**
  String get upcomingModules;

  /// No description provided for @phase2Plus.
  ///
  /// In en, this message translates to:
  /// **'PHASE 2+'**
  String get phase2Plus;

  /// No description provided for @categoryBudgets.
  ///
  /// In en, this message translates to:
  /// **'Category Budgets'**
  String get categoryBudgets;

  /// No description provided for @categoryBudgetsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Monthly allocation limits'**
  String get categoryBudgetsSubtitle;

  /// No description provided for @phase3.
  ///
  /// In en, this message translates to:
  /// **'Phase 3'**
  String get phase3;

  /// No description provided for @multiCurrency.
  ///
  /// In en, this message translates to:
  /// **'Multi-Currency Ledger'**
  String get multiCurrency;

  /// No description provided for @multiCurrencySubtitle.
  ///
  /// In en, this message translates to:
  /// **'Manual conversion ratios'**
  String get multiCurrencySubtitle;

  /// No description provided for @phase4.
  ///
  /// In en, this message translates to:
  /// **'Phase 4'**
  String get phase4;

  /// No description provided for @vaults.
  ///
  /// In en, this message translates to:
  /// **'Vaults & Sovereign Net Worth'**
  String get vaults;

  /// No description provided for @vaultsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Aggregated accounts and assets'**
  String get vaultsSubtitle;

  /// No description provided for @phase5.
  ///
  /// In en, this message translates to:
  /// **'Phase 5'**
  String get phase5;

  /// No description provided for @resetLocalLedger.
  ///
  /// In en, this message translates to:
  /// **'Reset Local Ledger Journal'**
  String get resetLocalLedger;

  /// No description provided for @settingsFooter.
  ///
  /// In en, this message translates to:
  /// **'Architected for absolute manual agency and sovereign accounting. Zero cloud dependencies.'**
  String get settingsFooter;

  /// No description provided for @displayCurrency.
  ///
  /// In en, this message translates to:
  /// **'Display currency'**
  String get displayCurrency;

  /// No description provided for @currencySymbolOnly.
  ///
  /// In en, this message translates to:
  /// **'Changes the symbol only — amounts are not converted.'**
  String get currencySymbolOnly;

  /// No description provided for @noLedgerFile.
  ///
  /// In en, this message translates to:
  /// **'No ledger file to export yet'**
  String get noLedgerFile;

  /// No description provided for @exportSubject.
  ///
  /// In en, this message translates to:
  /// **'Ledgr journal export'**
  String get exportSubject;

  /// No description provided for @couldNotExport.
  ///
  /// In en, this message translates to:
  /// **'Could not export: {error}'**
  String couldNotExport(String error);

  /// No description provided for @resetLedgerTitle.
  ///
  /// In en, this message translates to:
  /// **'Reset local ledger?'**
  String get resetLedgerTitle;

  /// No description provided for @resetLedgerMessage.
  ///
  /// In en, this message translates to:
  /// **'This deletes all transactions and SMS inbox items. Categories and settings stay.'**
  String get resetLedgerMessage;

  /// No description provided for @reset.
  ///
  /// In en, this message translates to:
  /// **'Reset'**
  String get reset;

  /// No description provided for @themeSystem.
  ///
  /// In en, this message translates to:
  /// **'System'**
  String get themeSystem;

  /// No description provided for @themeLight.
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get themeLight;

  /// No description provided for @themeDark.
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get themeDark;

  /// No description provided for @currencyEgp.
  ///
  /// In en, this message translates to:
  /// **'Egyptian Pound'**
  String get currencyEgp;

  /// No description provided for @currencyUsd.
  ///
  /// In en, this message translates to:
  /// **'US Dollar'**
  String get currencyUsd;

  /// No description provided for @currencyEur.
  ///
  /// In en, this message translates to:
  /// **'Euro'**
  String get currencyEur;

  /// No description provided for @currencyGbp.
  ///
  /// In en, this message translates to:
  /// **'British Pound'**
  String get currencyGbp;

  /// No description provided for @currencySar.
  ///
  /// In en, this message translates to:
  /// **'Saudi Riyal'**
  String get currencySar;

  /// No description provided for @currencyAed.
  ///
  /// In en, this message translates to:
  /// **'UAE Dirham'**
  String get currencyAed;

  /// No description provided for @categoryFoodDining.
  ///
  /// In en, this message translates to:
  /// **'Food & Dining'**
  String get categoryFoodDining;

  /// No description provided for @categoryTransport.
  ///
  /// In en, this message translates to:
  /// **'Transport'**
  String get categoryTransport;

  /// No description provided for @categoryShopping.
  ///
  /// In en, this message translates to:
  /// **'Shopping'**
  String get categoryShopping;

  /// No description provided for @categoryBillsUtilities.
  ///
  /// In en, this message translates to:
  /// **'Bills & Utilities'**
  String get categoryBillsUtilities;

  /// No description provided for @categoryHealth.
  ///
  /// In en, this message translates to:
  /// **'Health'**
  String get categoryHealth;

  /// No description provided for @categoryEntertainment.
  ///
  /// In en, this message translates to:
  /// **'Entertainment'**
  String get categoryEntertainment;

  /// No description provided for @categoryTransfer.
  ///
  /// In en, this message translates to:
  /// **'Transfer'**
  String get categoryTransfer;

  /// No description provided for @categoryOther.
  ///
  /// In en, this message translates to:
  /// **'Other'**
  String get categoryOther;

  /// No description provided for @categorySalary.
  ///
  /// In en, this message translates to:
  /// **'Salary'**
  String get categorySalary;

  /// No description provided for @categoryFreelance.
  ///
  /// In en, this message translates to:
  /// **'Freelance'**
  String get categoryFreelance;

  /// No description provided for @bankSms.
  ///
  /// In en, this message translates to:
  /// **'Bank SMS'**
  String get bankSms;

  /// No description provided for @smsInboxSupported.
  ///
  /// In en, this message translates to:
  /// **'Ledgr reads only known bank senders. SMS access is for personal/sideload use — Google Play restricts this permission for expense apps.'**
  String get smsInboxSupported;

  /// No description provided for @smsInboxUnsupported.
  ///
  /// In en, this message translates to:
  /// **'Inbox reading isn’t available on this device. Paste a bank SMS below.'**
  String get smsInboxUnsupported;

  /// No description provided for @pasteBankSms.
  ///
  /// In en, this message translates to:
  /// **'Paste a bank SMS'**
  String get pasteBankSms;

  /// No description provided for @parse.
  ///
  /// In en, this message translates to:
  /// **'Parse'**
  String get parse;

  /// No description provided for @parsing.
  ///
  /// In en, this message translates to:
  /// **'Parsing…'**
  String get parsing;

  /// No description provided for @toReview.
  ///
  /// In en, this message translates to:
  /// **'To review'**
  String get toReview;

  /// No description provided for @unmatched.
  ///
  /// In en, this message translates to:
  /// **'Unmatched'**
  String get unmatched;

  /// No description provided for @imported.
  ///
  /// In en, this message translates to:
  /// **'Imported'**
  String get imported;

  /// No description provided for @emptyToReview.
  ///
  /// In en, this message translates to:
  /// **'Nothing to review — paste a bank SMS or scan the inbox'**
  String get emptyToReview;

  /// No description provided for @emptyUnmatched.
  ///
  /// In en, this message translates to:
  /// **'No unmatched messages'**
  String get emptyUnmatched;

  /// No description provided for @emptyImported.
  ///
  /// In en, this message translates to:
  /// **'No imported SMS yet'**
  String get emptyImported;

  /// No description provided for @skipSmsTitle.
  ///
  /// In en, this message translates to:
  /// **'Skip this SMS?'**
  String get skipSmsTitle;

  /// No description provided for @skipSmsMessage.
  ///
  /// In en, this message translates to:
  /// **'It will not be added to the ledger.'**
  String get skipSmsMessage;

  /// No description provided for @skip.
  ///
  /// In en, this message translates to:
  /// **'Skip'**
  String get skip;

  /// No description provided for @inboxAccessGranted.
  ///
  /// In en, this message translates to:
  /// **'Inbox access granted'**
  String get inboxAccessGranted;

  /// No description provided for @allowSmsAccess.
  ///
  /// In en, this message translates to:
  /// **'Allow SMS access to scan bank messages'**
  String get allowSmsAccess;

  /// No description provided for @scanInbox.
  ///
  /// In en, this message translates to:
  /// **'Scan inbox'**
  String get scanInbox;

  /// No description provided for @scanning.
  ///
  /// In en, this message translates to:
  /// **'Scanning…'**
  String get scanning;

  /// No description provided for @request.
  ///
  /// In en, this message translates to:
  /// **'Request'**
  String get request;

  /// No description provided for @confirmEntry.
  ///
  /// In en, this message translates to:
  /// **'Confirm entry'**
  String get confirmEntry;

  /// No description provided for @smsCurrencyMismatch.
  ///
  /// In en, this message translates to:
  /// **'SMS currency {code} — stored as display currency, not converted.'**
  String smsCurrencyMismatch(String code);

  /// No description provided for @noteOptional.
  ///
  /// In en, this message translates to:
  /// **'Note (optional)'**
  String get noteOptional;

  /// No description provided for @alreadyInInbox.
  ///
  /// In en, this message translates to:
  /// **'Already in the inbox'**
  String get alreadyInInbox;

  /// No description provided for @noNewBankMessages.
  ///
  /// In en, this message translates to:
  /// **'No new bank messages'**
  String get noNewBankMessages;

  /// No description provided for @foundMessagesToReview.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{Found {count} message to review} other{Found {count} messages to review}}'**
  String foundMessagesToReview(int count);

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @discardEntryTitle.
  ///
  /// In en, this message translates to:
  /// **'Discard this entry?'**
  String get discardEntryTitle;

  /// No description provided for @discardEntryMessage.
  ///
  /// In en, this message translates to:
  /// **'The amount you entered will be lost.'**
  String get discardEntryMessage;

  /// No description provided for @discard.
  ///
  /// In en, this message translates to:
  /// **'Discard'**
  String get discard;

  /// No description provided for @duplicateCategory.
  ///
  /// In en, this message translates to:
  /// **'A category with that name already exists.'**
  String get duplicateCategory;

  /// No description provided for @defaultCategoryProtected.
  ///
  /// In en, this message translates to:
  /// **'Default categories cannot be changed or deleted.'**
  String get defaultCategoryProtected;

  /// No description provided for @smsNotFound.
  ///
  /// In en, this message translates to:
  /// **'That SMS is no longer in the inbox.'**
  String get smsNotFound;

  /// No description provided for @smsAlreadyImported.
  ///
  /// In en, this message translates to:
  /// **'This SMS has already been added to the ledger.'**
  String get smsAlreadyImported;

  /// No description provided for @transactionNotFound.
  ///
  /// In en, this message translates to:
  /// **'This entry is no longer in the ledger.'**
  String get transactionNotFound;

  /// No description provided for @categoryNotFound.
  ///
  /// In en, this message translates to:
  /// **'This category is no longer available.'**
  String get categoryNotFound;

  /// No description provided for @enterCategoryName.
  ///
  /// In en, this message translates to:
  /// **'Enter a category name.'**
  String get enterCategoryName;

  /// No description provided for @amountMustBePositive.
  ///
  /// In en, this message translates to:
  /// **'Amount must be greater than 0.'**
  String get amountMustBePositive;

  /// No description provided for @categoryTypeMismatch.
  ///
  /// In en, this message translates to:
  /// **'Category does not match Debit/Credit.'**
  String get categoryTypeMismatch;

  /// No description provided for @otherCategoryMissing.
  ///
  /// In en, this message translates to:
  /// **'The Other category is missing.'**
  String get otherCategoryMissing;

  /// No description provided for @scanFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not scan the inbox.'**
  String get scanFailed;
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['ar', 'en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {


  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar': return AppLocalizationsAr();
    case 'en': return AppLocalizationsEn();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.'
  );
}
