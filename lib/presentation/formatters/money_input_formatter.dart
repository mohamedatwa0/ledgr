import 'package:flutter/services.dart';

import '../../domain/sms/numeral.dart';

class MoneyInputFormatter extends TextInputFormatter {
  const MoneyInputFormatter();

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final normalized =
        easternToWesternDigits(newValue.text).replaceAll(',', '.');
    if (normalized.isEmpty) {
      return newValue.copyWith(text: '');
    }
    if (!RegExp(r'^\d*\.?\d{0,2}$').hasMatch(normalized)) {
      return oldValue;
    }
    if (normalized == newValue.text) return newValue;
    return TextEditingValue(
      text: normalized,
      selection: TextSelection.collapsed(offset: normalized.length),
    );
  }
}
