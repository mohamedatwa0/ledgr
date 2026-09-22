import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get navDashboard => 'لوحة الحساب';

  @override
  String get navTransactions => 'العمليات';

  @override
  String get navCategories => 'التصنيفات';

  @override
  String get navSettings => 'الإعدادات';

  @override
  String get newEntryTooltip => 'قيد جديد';

  @override
  String get ledgerBook => 'دفتر الحساب';

  @override
  String get thisMonth => 'هذا الشهر';

  @override
  String get thisMonthLabel => 'هذا الشهر';

  @override
  String get credits => 'دائن';

  @override
  String get debits => 'مدين';

  @override
  String get previousMonth => 'الشهر السابق';

  @override
  String get nextMonth => 'الشهر التالي';

  @override
  String depositCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count إيداع',
      many: '$count إيداعاً',
      few: '$count إيداعات',
      two: 'إيداعان',
      one: 'إيداع واحد',
      zero: 'لا إيداعات',
    );
    return '$_temp0';
  }

  @override
  String postingCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count قيد',
      many: '$count قيداً',
      few: '$count قيود',
      two: 'قيدان',
      one: 'قيد واحد',
      zero: 'لا قيود',
    );
    return '$_temp0';
  }

  @override
  String hiddenDebitsLookup(String amount) {
    return 'مدين $amount';
  }

  @override
  String get dailyOutlayPace => 'وتيرة الصرف اليومي';

  @override
  String perDayAverage(String symbol, String amount) {
    return '$symbol$amount / متوسط اليوم';
  }

  @override
  String get ledgerEntries => 'قيود الدفتر';

  @override
  String postingsCount(int count) {
    return 'قيود • $count';
  }

  @override
  String get emptyHomeTransactions => 'لا عمليات بعد — اضغط + لإضافة أول قيد';

  @override
  String get searchHint => 'ابحث بالتاجر أو الملاحظة أو المبلغ...';

  @override
  String get filterAllRecords => 'كل السجلات';

  @override
  String get filterDebitsOut => 'مدين (خارج)';

  @override
  String get filterCreditsIn => 'دائن (داخل)';

  @override
  String entriesCount(int count) {
    return '$count قيود';
  }

  @override
  String get emptyHistory => 'لا عمليات في هذا العرض';

  @override
  String postItemsCount(int count) {
    return '$count قيود';
  }

  @override
  String get deleteEntry => 'حذف القيد';

  @override
  String get deleteEntryMessage => 'إزالة هذه العملية من الدفتر؟';

  @override
  String get categoriesTitle => 'التصنيفات';

  @override
  String get ledgerNomenclature => 'تسميات الدفتر';

  @override
  String get add => 'إضافة';

  @override
  String debitCategories(String count) {
    return 'تصنيفات المدين ($count)';
  }

  @override
  String creditCategories(String count) {
    return 'تصنيفات الدائن ($count)';
  }

  @override
  String get defaultCategoriesProtected => 'التصنيفات الافتراضية التي لها قيود مسجّلة محمية من الحذف.';

  @override
  String get defaultBadge => 'افتراضي';

  @override
  String get newCategory => 'تصنيف جديد';

  @override
  String get editCategory => 'تعديل التصنيف';

  @override
  String get addCategory => 'إضافة تصنيف';

  @override
  String get editCategoryTitle => 'تعديل التصنيف';

  @override
  String get close => 'إغلاق';

  @override
  String get back => 'رجوع';

  @override
  String get nameHint => 'الاسم';

  @override
  String get icon => 'الأيقونة';

  @override
  String get color => 'اللون';

  @override
  String get preview => 'معاينة';

  @override
  String get deleteCategory => 'حذف التصنيف';

  @override
  String get deleteThisCategory => 'حذف هذا التصنيف؟';

  @override
  String entriesWillMoveToOther(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'سيُنقل $count قيد إلى أخرى.',
      many: 'سيُنقل $count قيداً إلى أخرى.',
      few: 'ستُنقل $count قيود إلى أخرى.',
      two: 'سيُنقل قيدان إلى أخرى.',
      one: 'سيُنقل قيد واحد إلى أخرى.',
    );
    return '$_temp0';
  }

  @override
  String get saveCategory => 'حفظ التصنيف';

  @override
  String get newEntry => 'قيد جديد';

  @override
  String get editEntry => 'تعديل القيد';

  @override
  String get entryValue => 'قيمة القيد';

  @override
  String get ledgerAccount => 'حساب الدفتر';

  @override
  String categoriesCount(int count) {
    return '$count تصنيفات';
  }

  @override
  String get addNew => 'إضافة جديد';

  @override
  String get bookkeeperMemo => 'ملاحظة المحاسب';

  @override
  String get noteHint => 'أضف ملاحظة أو طرفاً مقابلاً (اختياري)...';

  @override
  String get transactionDate => 'تاريخ العملية';

  @override
  String get change => 'تغيير';

  @override
  String get missingAmountAndCategory => 'أدخل مبلغاً واختر تصنيفاً';

  @override
  String get saveEntry => 'حفظ القيد';

  @override
  String get offlineEntryNote => 'قيد محلي محدد • بدون مزامنة سحابية';

  @override
  String get debit => 'مدين';

  @override
  String get credit => 'دائن';

  @override
  String get debitExpense => 'مدين (مصروف)';

  @override
  String get creditIncome => 'دائن (دخل)';

  @override
  String get today => 'اليوم';

  @override
  String get yesterday => 'أمس';

  @override
  String todayWithDate(String date) {
    return 'اليوم، $date';
  }

  @override
  String yesterdayWithDate(String date) {
    return 'أمس، $date';
  }

  @override
  String get language => 'اللغة';

  @override
  String get languageSubtitle => 'واجهة إنجليزية أو عربية';

  @override
  String get localeEn => 'EN';

  @override
  String get localeAr => 'ع';

  @override
  String get ledgrJournal => 'دفتر Ledgr';

  @override
  String get journal => 'دفتر';

  @override
  String get physicalDriftStorage => 'تخزين SQLite محلي على الجهاز';

  @override
  String get offlineChip => 'بدون اتصال';

  @override
  String get zeroAiChip => 'بدون سحابة';

  @override
  String get activeConfiguration => 'الإعدادات الحالية';

  @override
  String get localVerified => 'محلي مؤكد';

  @override
  String get baseCurrency => 'العملة الأساسية';

  @override
  String get baseCurrencySubtitle => 'عملة عرض واحدة ثابتة';

  @override
  String get defaultEntryType => 'نوع القيد الافتراضي';

  @override
  String get defaultEntryTypeSubtitle => 'عمود التسجيل الأساسي';

  @override
  String get appearance => 'المظهر';

  @override
  String get appearanceSubtitle => 'نظام أو فاتح أو دفتر ليلي';

  @override
  String get dataSovereignty => 'البيانات والسيادة';

  @override
  String get dataSovereigntySubtitle => 'ملف SQLite على هذا الجهاز';

  @override
  String get export => 'تصدير';

  @override
  String get bankSmsImport => 'استيراد رسائل البنك';

  @override
  String get bankSmsImportSubtitle => 'محلل تعبير نمطي محدد. بدون ذكاء اصطناعي.';

  @override
  String readyToReview(int count) {
    return '$count للمراجعة';
  }

  @override
  String get upcomingModules => 'وحدات الدفتر القادمة';

  @override
  String get phase2Plus => 'المرحلة ٢+';

  @override
  String get categoryBudgets => 'ميزانيات التصنيفات';

  @override
  String get categoryBudgetsSubtitle => 'حدود تخصيص شهرية';

  @override
  String get phase3 => 'المرحلة ٣';

  @override
  String get multiCurrency => 'دفتر متعدد العملات';

  @override
  String get multiCurrencySubtitle => 'نسب تحويل يدوية';

  @override
  String get phase4 => 'المرحلة ٤';

  @override
  String get vaults => 'الخزائن وصافي الثروة';

  @override
  String get vaultsSubtitle => 'حسابات وأصول مجمّعة';

  @override
  String get phase5 => 'المرحلة ٥';

  @override
  String get resetLocalLedger => 'إعادة تعيين دفتر الحساب المحلي';

  @override
  String get settingsFooter => 'مصمم للتحكم اليدوي الكامل والمحاسبة المستقلة. بدون اعتماد على السحابة.';

  @override
  String get displayCurrency => 'عملة العرض';

  @override
  String get currencySymbolOnly => 'يغيّر الرمز فقط — لا تُحوَّل المبالغ.';

  @override
  String get noLedgerFile => 'لا يوجد ملف دفتر للتصدير بعد';

  @override
  String get exportSubject => 'تصدير دفتر Ledgr';

  @override
  String couldNotExport(String error) {
    return 'تعذر التصدير: $error';
  }

  @override
  String get resetLedgerTitle => 'إعادة تعيين الدفتر المحلي؟';

  @override
  String get resetLedgerMessage => 'سيُحذف كل العمليات ورسائل الصندوق. التصنيفات والإعدادات تبقى.';

  @override
  String get reset => 'إعادة تعيين';

  @override
  String get themeSystem => 'النظام';

  @override
  String get themeLight => 'فاتح';

  @override
  String get themeDark => 'داكن';

  @override
  String get currencyEgp => 'الجنيه المصري';

  @override
  String get currencyUsd => 'الدولار الأمريكي';

  @override
  String get currencyEur => 'اليورو';

  @override
  String get currencyGbp => 'الجنيه الإسترليني';

  @override
  String get currencySar => 'الريال السعودي';

  @override
  String get currencyAed => 'الدرهم الإماراتي';

  @override
  String get categoryFoodDining => 'طعام ومطاعم';

  @override
  String get categoryTransport => 'مواصلات';

  @override
  String get categoryShopping => 'تسوق';

  @override
  String get categoryBillsUtilities => 'فواتير وخدمات';

  @override
  String get categoryHealth => 'صحة';

  @override
  String get categoryEntertainment => 'ترفيه';

  @override
  String get categoryTransfer => 'تحويل';

  @override
  String get categoryOther => 'أخرى';

  @override
  String get categorySalary => 'راتب';

  @override
  String get categoryFreelance => 'عمل حر';

  @override
  String get bankSms => 'رسائل البنك';

  @override
  String get smsInboxSupported => 'يقرأ Ledgr مرسلين بنكيين معروفين فقط. الوصول للرسائل للاستخدام الشخصي — متجر جوجل يقيّد هذا الإذن لتطبيقات المصروفات.';

  @override
  String get smsInboxUnsupported => 'قراءة الصندوق غير متاحة على هذا الجهاز. الصق رسالة بنك أدناه.';

  @override
  String get pasteBankSms => 'الصق رسالة بنك';

  @override
  String get parse => 'تحليل';

  @override
  String get parsing => 'جاري التحليل…';

  @override
  String get toReview => 'للمراجعة';

  @override
  String get unmatched => 'غير مطابقة';

  @override
  String get imported => 'مستوردة';

  @override
  String get emptyToReview => 'لا شيء للمراجعة — الصق رسالة بنك أو امسح الصندوق';

  @override
  String get emptyUnmatched => 'لا رسائل غير مطابقة';

  @override
  String get emptyImported => 'لا رسائل مستوردة بعد';

  @override
  String get skipSmsTitle => 'تخطي هذه الرسالة؟';

  @override
  String get skipSmsMessage => 'لن تُضاف إلى الدفتر.';

  @override
  String get skip => 'تخطي';

  @override
  String get inboxAccessGranted => 'تم منح الوصول للصندوق';

  @override
  String get allowSmsAccess => 'اسمح بالوصول للرسائل لمسح رسائل البنك';

  @override
  String get scanInbox => 'مسح الصندوق';

  @override
  String get scanning => 'جاري المسح…';

  @override
  String get request => 'طلب';

  @override
  String get confirmEntry => 'تأكيد القيد';

  @override
  String smsCurrencyMismatch(String code) {
    return 'عملة الرسالة $code — تُحفظ بعملة العرض دون تحويل.';
  }

  @override
  String get noteOptional => 'ملاحظة (اختياري)';

  @override
  String get alreadyInInbox => 'موجودة مسبقاً في الصندوق';

  @override
  String get noNewBankMessages => 'لا رسائل بنك جديدة';

  @override
  String foundMessagesToReview(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'تم العثور على $count رسالة للمراجعة',
      many: 'تم العثور على $count رسالة للمراجعة',
      few: 'تم العثور على $count رسائل للمراجعة',
      two: 'تم العثور على رسالتين للمراجعة',
      one: 'تم العثور على رسالة واحدة للمراجعة',
    );
    return '$_temp0';
  }

  @override
  String get cancel => 'إلغاء';

  @override
  String get delete => 'حذف';
}
