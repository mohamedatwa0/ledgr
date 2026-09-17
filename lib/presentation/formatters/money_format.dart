import 'package:intl/intl.dart';

import '../../domain/date_utils.dart';
import '../../domain/models/transaction_type.dart';
import 'currencies.dart';

final _grouped = NumberFormat('#,##0.00');

String formatBalance(int amount, String currencyCode) {
  final symbol = currencyByCode(currencyCode).symbol;
  final sign = amount < 0 ? '-' : '';
  return '$sign$symbol ${_grouped.format(minorToDecimal(amount.abs()))}';
}

String formatSignedAmount(int amount, TransactionType type) {
  final sign = type == TransactionType.income ? '+' : '-';
  return '$sign${_grouped.format(minorToDecimal(amount))}';
}

String formatSubtotal(int amount) => _grouped.format(minorToDecimal(amount));
