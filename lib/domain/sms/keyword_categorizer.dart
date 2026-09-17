import '../models/transaction_type.dart';

/// Rule-based category name from merchant + body. Null means fallback Other.
String? suggestCategoryName({
  required String haystack,
  required TransactionType type,
}) {
  final text = haystack.toLowerCase();

  if (_has(text, const ['atm', 'cash withdrawal', 'سحب نقدي', 'ماكينة'])) {
    return null;
  }

  if (type == TransactionType.income &&
      _has(text, const ['salary', 'payroll', 'راتب'])) {
    return 'Salary';
  }

  if (_has(text, const [
    'instapay',
    'transfer',
    'sent to',
    'received from',
    'حوالة',
    'تحويل',
  ])) {
    return 'Transfer';
  }

  if (_has(text, const [
    'restaurant',
    'cafe',
    'coffee',
    'starbucks',
    'mcdonald',
    'koshary',
    'talabat',
    'kfc',
    'burger',
  ])) {
    return 'Food & Dining';
  }

  if (_has(text, const [
    'uber',
    'careem',
    'didi',
    'petrol',
    'shell',
    'totalenergies',
    'fuel',
    'gas station',
  ])) {
    return 'Transport';
  }

  if (_has(text, const [
    'amazon',
    'noon',
    'jumia',
    'zara',
    'carrefour',
    'b.tech',
    'btech',
  ])) {
    return 'Shopping';
  }

  if (_has(text, const [
        'vodafone',
        'orange',
        'etisalat',
        'electricity',
        'gas bill',
        'water bill',
      ]) ||
      RegExp(r'\bwe\b').hasMatch(text)) {
    return 'Bills & Utilities';
  }

  if (_has(text, const ['pharmacy', 'clinic', 'hospital', 'صيدلية', 'مستشفى'])) {
    return 'Health';
  }

  if (_has(text, const ['cinema', 'netflix', 'spotify', 'movie'])) {
    return 'Entertainment';
  }

  return null;
}

bool _has(String haystack, List<String> keys) {
  for (final key in keys) {
    if (key.length <= 3) {
      if (RegExp('\\b${RegExp.escape(key)}\\b').hasMatch(haystack)) {
        return true;
      }
    } else if (haystack.contains(key)) {
      return true;
    }
  }
  return false;
}
