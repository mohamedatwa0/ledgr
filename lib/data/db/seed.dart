import 'package:drift/drift.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';

import '../../domain/models/transaction_type.dart';
import 'app_database.dart';

const _seedColors = <int>[
  0xFF1C2B3A,
  0xFF2C6E7F,
  0xFF9C2B2B,
  0xFF2F5233,
  0xFF5B5B52,
  0xFF6B5A3E,
  0xFF3D5A80,
  0xFF7A4E7A,
];

Future<void> seedDatabase(AppDatabase db) async {
  await db.batch((batch) {
    batch.insertAll(db.categoryRows, [
      _category(
        'Food & Dining',
        TransactionType.expense,
        TablerIcons.coffee,
        _seedColors[0],
      ),
      _category(
        'Transport',
        TransactionType.expense,
        TablerIcons.car,
        _seedColors[1],
      ),
      _category(
        'Shopping',
        TransactionType.expense,
        TablerIcons.shopping_bag,
        _seedColors[2],
      ),
      _category(
        'Bills & Utilities',
        TransactionType.expense,
        TablerIcons.file_invoice,
        _seedColors[3],
      ),
      _category(
        'Health',
        TransactionType.expense,
        TablerIcons.heart,
        _seedColors[4],
      ),
      _category(
        'Entertainment',
        TransactionType.expense,
        TablerIcons.movie,
        _seedColors[5],
      ),
      _category(
        'Transfer',
        TransactionType.expense,
        TablerIcons.arrows_exchange,
        _seedColors[6],
      ),
      _category(
        'Other',
        TransactionType.expense,
        TablerIcons.dots,
        _seedColors[7],
        isFallback: true,
      ),
      _category(
        'Salary',
        TransactionType.income,
        TablerIcons.wallet,
        _seedColors[3],
      ),
      _category(
        'Freelance',
        TransactionType.income,
        TablerIcons.briefcase,
        _seedColors[1],
      ),
      _category(
        'Transfer',
        TransactionType.income,
        TablerIcons.arrows_exchange,
        _seedColors[6],
      ),
      _category(
        'Other',
        TransactionType.income,
        TablerIcons.dots,
        _seedColors[7],
        isFallback: true,
      ),
    ]);
    batch.insert(
      db.settingsRows,
      SettingsRowsCompanion.insert(
        id: const Value(1),
        currencyCode: const Value('EGP'),
      ),
    );
  });
}

CategoryRowsCompanion _category(
  String name,
  TransactionType type,
  IconData icon,
  int colorValue, {
  bool isFallback = false,
}) {
  return CategoryRowsCompanion.insert(
    name: name,
    type: type,
    iconCodePoint: icon.codePoint,
    colorValue: colorValue,
    isDefault: const Value(true),
    isFallback: Value(isFallback),
  );
}
