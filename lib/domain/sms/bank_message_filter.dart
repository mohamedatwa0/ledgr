import 'sms_normalize.dart';
import 'templates/template_registry.dart';

const _placeholderSenders = {'', 'SHARE', 'PASTE', 'MESSAGES', 'SMS'};

/// Sender ids for the Central Bank of Egypt list: licensed banks, telecom
/// wallets, bank wallets, and payment apps. Matched like template sender ids.
const extraBankAndWalletSenders = [
  // Telecom wallets and bank wallets.
  'VODAFONECASH',
  'VFCASH',
  'VFCSH',
  'ORANGECASH',
  'ETISALATCASH',
  'ECASH',
  'EMONEY',
  'WEPAY',
  'PHONECASH',
  'NBEPHONECASH',
  'BMWALLET',
  'SMARTWALLET',
  'CAIRECASH',
  // Payment apps.
  'FAWRY',
  'TELDA',
  'KLIVVR',
  'HALAN',
  'MNTHALAN',
  'MASARY',
  'AMAN',
  'MEEZA',
  // Licensed banks beyond the parsed templates.
  'AAIB',
  'ADIB',
  'FABMISR',
  'FABEGY',
  'ALEXBANK',
  'HDB',
  'EBANK',
  'EBE',
  'IDBE',
  'MIDBANK',
  'ABK',
  'ABKEGYPT',
  'NBK',
  'ENBD',
  'SAIB',
  'HSBC',
  'CITI',
  'CITIBANK',
  'ARABANK',
  'STANCHART',
  'BANKNXT',
  'ATTIJARI',
  'ATTIJARIWAFA',
  'FAISAL',
  'FAISALBANK',
  'ALBARAKA',
  'BARAKA',
  'SUEZCANAL',
  'UNITEDBANK',
  'AGBANK',
  'EALB',
  'فودافون كاش',
  'أورنج كاش',
  'اورنج كاش',
  'اتصالات كاش',
  'وي باي',
  'فون كاش',
  'فوري',
  'تيلدا',
  'ميزة',
];

Set<String> smsImportSenderAllowlist() {
  return {
    ...smsSenderAllowlist(),
    ...extraBankAndWalletSenders,
  };
}

final _bankOrWalletMarker = RegExp(
  r'(\b(?:cib|nbe|qnb|bdc|aaib|adib|hdb|saib|hsbc|nbk|abk|ebe|idb)\b|'
  r'\b(?:instapay|ipn|fawry|telda|klivvr|halan|masary|meeza|aman)\b|'
  r'\b(?:alexbank|fabmisr|midbank|enbd|ebank|bank\s+nxt|attijari)\b|'
  r'\b(?:citibank|citi|arab\s+bank|standard\s+chartered|stanchart)\b|'
  r'banque\s+misr|banque\s+du\s+caire|bank\s+misr|'
  r'national\s+bank\s+of\s+egypt|banque\s+alexandria|'
  r'vodafone\s+cash|vf[\s-]?cash|orange\s+cash|etisalat\s+cash|'
  r'we\s+pay|phone\s*cash|bm\s+wallet|smart\s+wallet|cairo\s+cash|'
  r'mnt[-\s]?halan|faisal\s+islamic|al\s*baraka|suez\s+canal|'
  r'agricultural\s+bank|united\s+bank|export\s+development|'
  r'بنك\s*مصر|البنك\s*الأهلي|بنك\s*القاهرة|الأهلي\s*المصري|'
  r'البنك\s*العقاري|البنك\s*الزراعي|التنمية\s*الصناعية|المصرف\s*المتحد|'
  r'التجاري\s*الدولي|أبوظبي\s*الإسلامي|ابوظبي\s*الاسلامي|'
  r'أبوظبي\s*الأول|ابوظبي\s*الاول|بنك\s*الإسكندرية|بنك\s*الاسكندرية|'
  r'التعمير\s*والإسكان|التعمير\s*والاسكان|فيصل\s*الإسلامي|فيصل\s*الاسلامي|'
  r'تنمية\s*الصادرات|بنك\s*البركة|قناة\s*السويس|بنك\s*نكست|بنك\s*ميد|'
  r'الأهلي\s*الكويتي|الاهلي\s*الكويتي|الكويت\s*الوطني|الإمارات\s*دبي|'
  r'الامارات\s*دبي|التجاري\s*وفا|'
  r'فودافون\s*كاش|أورنج\s*كاش|اورنج\s*كاش|اتصالات\s*كاش|وي\s*باي|'
  r'فون\s*كاش|كاش\s*القاهرة|المحفظة\s*الذكية|انستاباي|إنستاباي|'
  r'فوري|تيلدا|هالان|مصاري|ميزة)',
  caseSensitive: false,
);

final _cardOrAccount = RegExp(
  r'(card\s+ending|acct|account|بطاقة|حساب|\*{2,}\d{3,4}|ending\s+\d{3,4})',
  caseSensitive: false,
);

final _txnVerb = RegExp(
  r'(debit(?:ed)?|credit(?:ed)?|purchased?|withdrawn|withdrawal|\bpos\b|'
  r'available\s+balance|avl\s+bal|'
  r'خصم|سحب|ايداع|إيداع|مشتريات|الرصيد)',
  caseSensitive: false,
);

final _money = RegExp(
  r'(E£|EGP|USD|EUR|GBP|SAR|AED|\bLE\b|جنيه)',
  caseSensitive: false,
);

final _arabicBankVerb = RegExp(
  r'(تم\s+خصم|تم\s+سحب|تم\s+ايداع|تم\s+إيداع|تم\s+تحويل)',
);

/// True when this text is a bank or smart-wallet alert, not a personal message.
bool isBankOrWalletMessage({
  required String sender,
  required String body,
}) {
  final text = normalizeSmsText(body);
  if (text.isEmpty || looksLikeOtp(text)) return false;
  final normalizedSender = normalizeSender(sender);
  final knownSender = !_placeholderSenders.contains(normalizedSender) &&
      senderMatchesAllowlist(normalizedSender, smsImportSenderAllowlist());
  if (knownSender) return _bodyLooksLikeTransaction(text);
  return bodyLooksLikeBankOrWallet(text);
}

final _lightTxn = RegExp(
  r'(debit(?:ed)?|credit(?:ed)?|purchased?|withdrawn|withdrawal|'
  r'\bpaid\b|\bpayment\b|\breceived\b|\bcharged\b|\bsent\b|'
  r'خصم|سحب|ايداع|إيداع|تحويل|مدفوع|مشتريات)',
  caseSensitive: false,
);

bool _bodyLooksLikeTransaction(String text) {
  final hasMoney = _money.hasMatch(text) || RegExp(r'\d').hasMatch(text);
  return hasMoney &&
      (_txnVerb.hasMatch(text) ||
          _lightTxn.hasMatch(text) ||
          _arabicBankVerb.hasMatch(text));
}

bool bodyLooksLikeBankOrWallet(String text) {
  final hasMoney = _money.hasMatch(text) || RegExp(r'\d').hasMatch(text);
  if (_bankOrWalletMarker.hasMatch(text) && hasMoney) return true;
  if (_cardOrAccount.hasMatch(text) &&
      _txnVerb.hasMatch(text) &&
      _money.hasMatch(text)) {
    return true;
  }
  if (_arabicBankVerb.hasMatch(text) && _money.hasMatch(text)) return true;
  return false;
}
