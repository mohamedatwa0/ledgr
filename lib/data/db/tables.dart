import 'package:drift/drift.dart';

import '../../domain/models/transaction_source.dart';
import '../../domain/models/transaction_type.dart';

class CategoryRows extends Table {
  @override
  String get tableName => 'categories';

  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text()();
  TextColumn get type => textEnum<TransactionType>()();
  IntColumn get iconCodePoint => integer()();
  IntColumn get colorValue => integer()();
  BoolColumn get isDefault => boolean().withDefault(const Constant(false))();
  BoolColumn get isFallback => boolean().withDefault(const Constant(false))();

  @override
  List<Set<Column<Object>>> get uniqueKeys => [
        {name, type},
      ];
}

class TransactionRows extends Table {
  @override
  String get tableName => 'transactions';

  IntColumn get id => integer().autoIncrement()();
  IntColumn get amount => integer()();
  TextColumn get type => textEnum<TransactionType>()();
  IntColumn get categoryId => integer().references(CategoryRows, #id)();
  TextColumn get note => text().nullable()();
  DateTimeColumn get date => dateTime()();
  DateTimeColumn get createdAt => dateTime()();
  TextColumn get source =>
      textEnum<TransactionSource>().withDefault(const Constant('manual'))();
}

class SettingsRows extends Table {
  @override
  String get tableName => 'app_settings';

  IntColumn get id => integer()();
  TextColumn get currencyCode => text().withDefault(const Constant('EGP'))();

  @override
  Set<Column<Object>> get primaryKey => {id};
}
