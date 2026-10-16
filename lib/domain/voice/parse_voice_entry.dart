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
  'transferred to me',
  'transferred me',
  'sent to me',
  'اتحول لي',
  'اتحولي',
  'اتحول',
  'استلمت',
  'received',
  'deposit',
  'refund',
  'payroll',
  'salary',
  'freelance',
  'فريلانس',
  'sent me',
  'مرتب',
  'راتب',
  'ايداع',
  'وصلني',
  'وصلي',
  'قبض',
  'جالي',
  'دخل',
  'bonus',
  'got',
];

final _expensePhrases = <String>[
  'اشتريت',
  'transferred',
  'withdrew',
  'bought',
  'spent',
  'spend',
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
  'transferred to me',
  'اتحولي',
  'اتحول',
  'تحويل',
  'حواله',
  'حول لي',
  'حولت',
  'حول',
];

final _freelanceKeys = <String>[
  'freelance',
  'فريلانس',
  'client',
  'عميل',
];

final _foodKeys = <String>[
  'restaurant',
  'starbucks',
  'mcdonald',
  'breakfast',
  'koshary',
  'talabat',
  'dinner',
  'coffee',
  'burger',
  'lunch',
  'pizza',
  'food',
  'meal',
  'cafe',
  'مطعم',
  'كافيه',
  'قهوه',
  'فطار',
  'فطور',
  'عشاء',
  'غداء',
  'عشا',
  'غدا',
  'اكل',
  'kfc',
];

final _transportKeys = <String>[
  'totalenergies',
  'gas station',
  'parking',
  'petrol',
  'careem',
  'metro',
  'train',
  'taxi',
  'uber',
  'didi',
  'fuel',
  'bus',
  'ride',
  'مواصلات',
  'اتوبيس',
  'تاكسي',
  'بنزين',
  'اوبر',
  'مترو',
  'shell',
];

final _shoppingKeys = <String>[
  'carrefour',
  'shopping',
  'clothes',
  'amazon',
  'market',
  'wallet',
  'phone',
  'shoes',
  'store',
  'mall',
  'b.tech',
  'btech',
  'jumia',
  'noon',
  'zara',
  'ملابس',
  'موبايل',
  'محفظه',
  'سوق',
  'محل',
];

final _billsKeys = <String>[
  'electricity',
  'internet',
  'gas bill',
  'water bill',
  'vodafone',
  'etisalat',
  'orange',
  'wifi',
  'rent',
  'bill',
  'فاتوره',
  'انترنت',
  'النت',
  'كهربا',
  'ايجار',
];

final _healthKeys = <String>[
  'pharmacy',
  'hospital',
  'medicine',
  'doctor',
  'clinic',
  'صيدليه',
  'مستشفي',
  'دكتور',
  'علاج',
  'دوا',
];

final _entertainmentKeys = <String>[
  'netflix',
  'spotify',
  'cinema',
  'movie',
  'game',
  'سينما',
  'فيلم',
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
  'spent',
  'spend',
  'اتحول',
  'payroll',
  'salary',
  'دفعت',
  'صرفت',
  'سحبت',
  'حولت',
  'جنيهات',
  'جنيها',
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
  'of',
  'a',
  'an',
  'my',
  'to',
  'from',
  'with',
  'and',
  'pound',
  'فاصله',
  'point',
  'dollar',
  'dollars',
  'i',
  'ب',
  'لي',
  'li',
  'me',
  'him',
  'her',
  'them',
  'yesterday',
  'today',
  'tonight',
  'امبارح',
  'مبارح',
  'النهارده',
  'اليوم',
  'دلوقتي',
  'some',
  'new',
};

const _spokenNumberTokens = <String>{
  'one',
  'two',
  'three',
  'four',
  'five',
  'six',
  'seven',
  'eight',
  'nine',
  'ten',
  'eleven',
  'twelve',
  'thirteen',
  'fourteen',
  'fifteen',
  'sixteen',
  'seventeen',
  'eighteen',
  'nineteen',
  'twenty',
  'thirty',
  'forty',
  'fifty',
  'sixty',
  'seventy',
  'eighty',
  'ninety',
  'hundred',
  'thousand',
  'واحد',
  'اتنين',
  'اثنين',
  'تلاتة',
  'ثلاثة',
  'اربعة',
  'خمسة',
  'خمسه',
  'ستة',
  'سبعة',
  'تمانية',
  'ثمانية',
  'تسعة',
  'عشرة',
  'عشر',
  'عشرين',
  'تلاتين',
  'ثلاثين',
  'اربعين',
  'خمسين',
  'ستين',
  'سبعين',
  'تمانين',
  'ثمانين',
  'تسعين',
  'ميه',
  'مائه',
  'مئه',
  'ميتين',
  'مائتين',
  'الف',
  'الفين',
};

final _amountToken = RegExp(
  r'^\d{1,3}(?:[.,\s]\d{3})+(?:[.,]\d{1,2})?$|^\d+(?:[.,]\d{1,2})?$',
);
final _decimalInText = RegExp(r'\d+[.,]\d{1,2}(?!\d)');
final _integerInText = RegExp(r'\d+');
final _thousandsAmount = RegExp(
  r'\d{1,3}(?:[.,\s\u00a0\u202f]\d{3})+(?:[.,]\d{1,2})?',
);

const _arabicNumberValues = <String, int>{
  'اتنين الف': 2000,
  'اثنين الف': 2000,
  'الفين': 2000,
  'ميتين': 200,
  'مائتين': 200,
  'الف': 1000,
  'مائه': 100,
  'مئه': 100,
  'ميه': 100,
  'تسعين': 90,
  'تمانين': 80,
  'ثمانين': 80,
  'سبعين': 70,
  'ستين': 60,
  'خمسين': 50,
  'اربعين': 40,
  'تلاتين': 30,
  'ثلاثين': 30,
  'عشرين': 20,
  'اتناشر': 12,
  'احدعش': 11,
  'حداشر': 11,
  'عشرة': 10,
  'عشره': 10,
  'تسعة': 9,
  'تسعه': 9,
  'تمانية': 8,
  'تمانيه': 8,
  'ثمانية': 8,
  'ثمانيه': 8,
  'سبعة': 7,
  'سبعه': 7,
  'ستة': 6,
  'خمسة': 5,
  'خمسه': 5,
  'اربعة': 4,
  'اربعه': 4,
  'تلاتة': 3,
  'تلاته': 3,
  'ثلاثة': 3,
  'ثلاثه': 3,
  'اتنين': 2,
  'اثنين': 2,
  'واحد': 1,
};

ParsedVoiceEntry? voiceDraftFromQuery(Map<String, String> query) {
  if (!query.containsKey('voiceCategory') && !query.containsKey('voiceNote')) {
    return null;
  }
  final amount = int.tryParse(query['voiceAmount'] ?? '');
  final typeName = query['voiceType'];
  return ParsedVoiceEntry(
    type: typeName == TransactionType.income.name
        ? TransactionType.income
        : typeName == TransactionType.expense.name
            ? TransactionType.expense
            : null,
    amountMinor: amount != null && amount > 0 ? amount : null,
    categoryName: query['voiceCategory'] ?? 'Other',
    createIfMissing: query['voiceCreate'] == '1',
    transcript: query['voiceNote'] ?? '',
  );
}

String voiceEntryLocation(ParsedVoiceEntry draft) {
  return Uri(
    path: '/transaction/new',
    queryParameters: {
      'voiceCategory': draft.categoryName,
      'voiceCreate': draft.createIfMissing ? '1' : '0',
      'voiceNote': draft.transcript,
      if (draft.amountMinor != null) 'voiceAmount': '${draft.amountMinor}',
      if (draft.type != null) 'voiceType': draft.type!.name,
    },
  ).toString();
}

ParsedVoiceEntry parseVoiceEntry(String transcript) {
  final raw = transcript.trim();
  final text = normalizeVoiceText(raw);
  final amountMinor = _amountMinor(text);
  final type = _typeOf(text);
  final category = _categoryOf(text, type);

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
  final prepared = _prepareAmountText(text);
  final major = _amountAsMajor(prepared);
  if (major == null || major <= 0) return null;
  return (major * 100).round();
}

String _prepareAmountText(String text) {
  var prepared = text.replaceAll('\u066b', '.').replaceAll('\u066c', '');
  // Speech often inserts thousands separators: 20,000 / 20.000 / 20 000.
  prepared = prepared.replaceAllMapped(_thousandsAmount, _collapseThousands);
  prepared = prepared.replaceAllMapped(
    RegExp(r'(\d+)\s*[.,]\s*(\d{1,2})(?!\d)'),
    (match) => '${match[1]}.${match[2]}',
  );
  prepared = prepared.replaceAllMapped(
    RegExp(r'(\d+)\s+(?:point|فاصله)\s+(\d{1,2})\b'),
    (match) => '${match[1]}.${match[2]}',
  );
  // Voice often splits 135 into "1 35".
  prepared = prepared.replaceAllMapped(
    RegExp(r'\b(\d)\s+(\d{2})\b'),
    (match) => '${match[1]}${match[2]}',
  );
  return prepared;
}

String _collapseThousands(Match match) {
  final raw = match.group(0)!;
  final decimal = RegExp(r'[.,](\d{1,2})$').firstMatch(raw);
  final whole = decimal == null ? raw : raw.substring(0, decimal.start);
  final digits = whole.replaceAll(RegExp(r'[.,\s\u00a0\u202f]'), '');
  if (decimal == null) return digits;
  return '$digits.${decimal.group(1)}';
}

double? _amountAsMajor(String text) {
  final decimalMatch = _decimalInText.firstMatch(text);
  if (decimalMatch != null) {
    final parsed = double.tryParse(decimalMatch.group(0)!.replaceAll(',', '.'));
    if (parsed != null && parsed > 0) {
      return parsed + _halfFraction(text);
    }
  }

  final arabic = _arabicSpokenAmount(text);
  final english = _englishSpokenAmount(text);
  final words = arabic ?? english;
  final integers = _integerInText
      .allMatches(text)
      .map((match) => int.tryParse(match.group(0)!))
      .whereType<int>()
      .where((value) => value > 0)
      .toList();

  double? major;
  if (words != null && integers.isNotEmpty) {
    final remainder =
        integers.firstWhere((value) => value < 100, orElse: () => 0);
    if (words >= 100 && remainder > 0 && remainder != words) {
      major = words + remainder;
    } else {
      major = words >= integers.first ? words : integers.first.toDouble();
    }
  } else if (integers.isNotEmpty) {
    major = integers.reduce((a, b) => a >= b ? a : b).toDouble();
  } else {
    major = words;
  }

  if (major == null || major <= 0) return null;
  return major + _halfFraction(text);
}

double _halfFraction(String text) {
  if (RegExp(r'(?:و\s*نص|ونص|نصف|and a half|\bhalf\b)').hasMatch(text)) {
    return 0.5;
  }
  return 0;
}

double? _englishSpokenAmount(String text) {
  const ones = <String, int>{
    'one': 1,
    'two': 2,
    'three': 3,
    'four': 4,
    'five': 5,
    'six': 6,
    'seven': 7,
    'eight': 8,
    'nine': 9,
  };
  const teens = <String, int>{
    'ten': 10,
    'eleven': 11,
    'twelve': 12,
    'thirteen': 13,
    'fourteen': 14,
    'fifteen': 15,
    'sixteen': 16,
    'seventeen': 17,
    'eighteen': 18,
    'nineteen': 19,
  };
  const tens = <String, int>{
    'twenty': 20,
    'thirty': 30,
    'forty': 40,
    'fifty': 50,
    'sixty': 60,
    'seventy': 70,
    'eighty': 80,
    'ninety': 90,
  };
  final tokens = text
      .replaceAll('-', ' ')
      .split(RegExp(r'\s+'))
      .where((token) => token.isNotEmpty)
      .toList();
  var total = 0;
  var current = 0;
  var found = false;
  for (var i = 0; i < tokens.length; i++) {
    final token = tokens[i];
    if (token == 'and') continue;
    if ((token == 'a' || token == 'an') &&
        i + 1 < tokens.length &&
        (tokens[i + 1] == 'hundred' || tokens[i + 1] == 'thousand')) {
      current += 1;
      found = true;
      continue;
    }
    if (ones.containsKey(token)) {
      current += ones[token]!;
      found = true;
      continue;
    }
    if (teens.containsKey(token)) {
      current += teens[token]!;
      found = true;
      continue;
    }
    if (tens.containsKey(token)) {
      current += tens[token]!;
      found = true;
      continue;
    }
    if (token == 'hundred') {
      if (current == 0) current = 1;
      current *= 100;
      found = true;
      continue;
    }
    if (token == 'thousand') {
      if (current == 0) current = 1;
      total += current * 1000;
      current = 0;
      found = true;
      continue;
    }
    if (token == 'point' && found) {
      final whole = total + current;
      if (i + 1 >= tokens.length) return whole.toDouble();
      final fraction = ones[tokens[i + 1]] ?? teens[tokens[i + 1]];
      if (fraction == null) return whole.toDouble();
      return whole + fraction / 10.0;
    }
    if (found && current + total > 0) break;
  }
  final value = total + current;
  if (!found || value <= 0) return null;
  return value.toDouble();
}

double? _arabicSpokenAmount(String text) {
  final split = text.split(RegExp(r'فاصله'));
  final whole = _arabicWholeNumber(split.first);
  if (whole == null) return null;
  if (split.length < 2) return whole.toDouble();
  final fractionToken = split[1].trim().split(RegExp(r'\s+')).first;
  final fraction = _arabicNumberValues[fractionToken];
  if (fraction == null || fraction >= 10) return whole.toDouble();
  return whole + fraction / 10.0;
}

int? _arabicWholeNumber(String text) {
  final keys = _arabicNumberValues.keys.toList()
    ..sort((a, b) => b.length.compareTo(a.length));
  var remaining = text;
  var total = 0;
  var found = false;
  while (remaining.isNotEmpty) {
    var bestPos = remaining.length;
    String? bestKey;
    for (final key in keys) {
      final pos = remaining.indexOf(key);
      if (pos < 0) continue;
      if (pos < bestPos ||
          (pos == bestPos && key.length > (bestKey?.length ?? 0))) {
        bestPos = pos;
        bestKey = key;
      }
    }
    if (bestKey == null) break;
    total += _arabicNumberValues[bestKey]!;
    found = true;
    remaining = remaining.replaceFirst(bestKey, ' ');
  }
  if (!found || total <= 0) return null;
  return total;
}

TransactionType? _typeOf(String text) {
  // "حول لي" / "حوللي" = someone transferred to me (income).
  // Must win before "حولت" (I transferred) is treated as expense.
  if (RegExp(r'حول\s*لي').hasMatch(text)) return TransactionType.income;
  if (_hasAny(text, _incomePhrases)) return TransactionType.income;
  if (_hasAny(text, _expensePhrases)) return TransactionType.expense;
  if (text.contains('نزل') && _hasAny(text, _salaryKeys)) {
    return TransactionType.income;
  }
  return null;
}

({String name, bool createIfMissing}) _categoryOf(
  String text,
  TransactionType? type,
) {
  if (type == TransactionType.income && _hasAny(text, _salaryKeys)) {
    return (name: 'Salary', createIfMissing: false);
  }
  if (type == TransactionType.income && _hasAny(text, _freelanceKeys)) {
    return (name: 'Freelance', createIfMissing: false);
  }
  if (_hasAny(text, _transferKeys) || RegExp(r'حول\s*لي').hasMatch(text)) {
    return (name: 'Transfer', createIfMissing: false);
  }
  if (_hasAny(text, _withdrawalKeys)) {
    return (name: 'Other', createIfMissing: false);
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
      .where((token) => !_spokenNumberTokens.contains(token))
      .where((token) => !_incomePhrases.contains(token))
      .where((token) => !_expensePhrases.contains(token))
      .toList();
  if (leftover.isEmpty) {
    return (name: 'Other', createIfMissing: false);
  }
  final shortName = leftover.take(2).map(_prettyCategoryToken).join(' ');
  return (name: shortName, createIfMissing: true);
}

String _prettyCategoryToken(String token) {
  if (token.isEmpty || _isArabic(token)) return token;
  return '${token[0].toUpperCase()}${token.substring(1)}';
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
