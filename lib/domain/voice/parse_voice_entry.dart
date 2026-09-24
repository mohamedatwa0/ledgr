import '../date_utils.dart';
import '../models/transaction_type.dart';
import '../sms/numeral.dart';

class ParsedVoiceEntry {
  const ParsedVoiceEntry({
    required this.categoryName,
    required this.createIfMissing,
    required this.transcript,
    this.type,
    this.amountMinor,
  });

  final TransactionType? type;
  final int? amountMinor;
  final String categoryName;
  final bool createIfMissing;
  final String transcript;
}

final _incomePhrases = <String>[
  'اتحولي',
  'اتحول',
  'استلمت',
  'received',
  'payroll',
  'salary',
  'مرتب',
  'راتب',
  'قبض',
  'جالي',
];

final _expensePhrases = <String>[
  'اشتريت',
  'transferred',
  'withdrew',
  'bought',
  'دفعت',
  'صرفت',
  'سحبت',
  'حولت',
  'paid',
];

final _withdrawalKeys = <String>[
  'withdrew',
  'سحبت',
  'سحب',
  'atm',
];

final _salaryKeys = <String>[
  'payroll',
  'salary',
  'مرتب',
  'راتب',
];

final _transferKeys = <String>[
  'transferred',
  'transfer',
  'اتحولي',
  'اتحول',
  'تحويل',
  'حواله',
  'حولت',
  'حول',
];

final _foodKeys = <String>[
  'restaurant',
  'starbucks',
  'mcdonald',
  'koshary',
  'talabat',
  'coffee',
  'burger',
  'cafe',
  'قهوه',
  'اكل',
  'kfc',
];

final _transportKeys = <String>[
  'totalenergies',
  'gas station',
  'petrol',
  'careem',
  'بنزين',
  'اوبر',
  'shell',
  'uber',
  'didi',
  'fuel',
];

final _shoppingKeys = <String>[
  'carrefour',
  'amazon',
  'b.tech',
  'btech',
  'jumia',
  'noon',
  'zara',
];

final _billsKeys = <String>[
  'electricity',
  'gas bill',
  'water bill',
  'vodafone',
  'etisalat',
  'orange',
];

final _healthKeys = <String>[
  'pharmacy',
  'hospital',
  'clinic',
  'صيدليه',
  'مستشفي',
  'دوا',
];

final _entertainmentKeys = <String>[
  'netflix',
  'spotify',
  'cinema',
  'movie',
];

final _fillerTokens = <String>{
  'transferred',
  'withdrew',
  'received',
  'اشتريت',
  'استلمت',
  'اتحولي',
  'pounds',
  'bought',
  'اتحول',
  'payroll',
  'salary',
  'دفعت',
  'صرفت',
  'سحبت',
  'حولت',
  'جنيه',
  'pack',
  'كيلو',
  'علبه',
  'انا',
  'paid',
  'نزل',
  'جالي',
  'قبض',
  'box',
  'for',
  'egp',
  'the',
  'atm',
  'on',
  'at',
  'i',
  'ب',
};

final _amountToken = RegExp(r'^\d+(?:[.,]\d+)?$');
final _amountInText = RegExp(r'\d+(?:[.,]\d+)?');

ParsedVoiceEntry parseVoiceEntry(String transcript) {
  final raw = transcript.trim();
  final text = normalizeVoiceText(raw);
  final amountMinor = _amountMinor(text);
  final type = _typeOf(text);
  final category = _categoryOf(text);

  return ParsedVoiceEntry(
    type: type,
    amountMinor: amountMinor,
    categoryName: category.name,
    createIfMissing: category.createIfMissing,
    transcript: raw,
  );
}

String normalizeVoiceText(String input) {
  var text = easternToWesternDigits(input);
  text = text.replaceAll(RegExp(r'[\u064B-\u065F\u0670]'), '');
  text = text
      .replaceAll('أ', 'ا')
      .replaceAll('إ', 'ا')
      .replaceAll('آ', 'ا')
      .replaceAll('ى', 'ي')
      .replaceAll('ة', 'ه')
      .replaceAll('ئ', 'ي');
  text = text.toLowerCase();
  return text.replaceAll(RegExp(r'\s+'), ' ').trim();
}

int? _amountMinor(String text) {
  final match = _amountInText.firstMatch(text);
  if (match == null) return null;
  return parseMinorUnits(match.group(0)!);
}

TransactionType? _typeOf(String text) {
  if (_hasAny(text, _incomePhrases)) return TransactionType.income;
  if (_hasAny(text, _expensePhrases)) return TransactionType.expense;
  if (text.contains('نزل') && _hasAny(text, _salaryKeys)) {
    return TransactionType.income;
  }
  return null;
}

({String name, bool createIfMissing}) _categoryOf(String text) {
  if (_hasAny(text, _withdrawalKeys)) {
    return (name: 'Other', createIfMissing: false);
  }
  if (_hasAny(text, _salaryKeys)) {
    return (name: 'Salary', createIfMissing: false);
  }
  if (_hasAny(text, _transferKeys)) {
    return (name: 'Transfer', createIfMissing: false);
  }
  if (_hasAny(text, _foodKeys)) {
    return (name: 'Food & Dining', createIfMissing: false);
  }
  if (_hasAny(text, _transportKeys)) {
    return (name: 'Transport', createIfMissing: false);
  }
  if (_hasAny(text, _shoppingKeys)) {
    return (name: 'Shopping', createIfMissing: false);
  }
  if (_hasAny(text, _billsKeys) || RegExp(r'\bwe\b').hasMatch(text)) {
    return (name: 'Bills & Utilities', createIfMissing: false);
  }
  if (_hasAny(text, _healthKeys)) {
    return (name: 'Health', createIfMissing: false);
  }
  if (_hasAny(text, _entertainmentKeys)) {
    return (name: 'Entertainment', createIfMissing: false);
  }

  final leftover = text
      .split(RegExp(r'\s+'))
      .where((token) => token.isNotEmpty)
      .where((token) => !_amountToken.hasMatch(token))
      .where((token) => !_fillerTokens.contains(token))
      .join(' ')
      .trim();
  if (leftover.isEmpty) {
    return (name: 'Other', createIfMissing: false);
  }
  return (name: leftover, createIfMissing: true);
}

bool _hasAny(String haystack, List<String> keys) {
  for (final key in keys) {
    if (key.length <= 3) {
      if (RegExp('\\b${RegExp.escape(key)}\\b').hasMatch(haystack)) {
        return true;
      }
      if (_isArabic(key) && haystack.contains(key)) return true;
    } else if (haystack.contains(key)) {
      return true;
    }
  }
  return false;
}

bool _isArabic(String value) => RegExp(r'[\u0600-\u06FF]').hasMatch(value);
