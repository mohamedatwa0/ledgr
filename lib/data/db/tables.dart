import 'package:drift/drift.dart';

import '../../domain/models/app_locale.dart';
import '../../domain/models/app_theme_mode.dart';
import '../../domain/models/transaction_source.dart';
import '../../domain/models/transaction_type.dart';
import '../../domain/sms/sms_inbox_status.dart';

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
  DateTimeColumn get smsLastScanAt => dateTime().nullable()();
  TextColumn get themeMode =>
      textEnum<AppThemeMode>().withDefault(const Constant('system'))();
  TextColumn get defaultEntryType =>
      textEnum<TransactionType>().withDefault(const Constant('expense'))();
  TextColumn get localeCode =>
      textEnum<AppLocale>().withDefault(const Constant('en'))();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

class SmsInboxRows extends Table {
  @override
  String get tableName => 'sms_inbox';

  IntColumn get id => integer().autoIncrement()();
  TextColumn get fingerprint => text().unique()();
  TextColumn get platformMessageId => text().nullable()();
  TextColumn get sender => text()();
  TextColumn get body => text()();
  DateTimeColumn get receivedAt => dateTime()();
  DateTimeColumn get createdAt => dateTime()();
  TextColumn get status => textEnum<SmsInboxStatus>()();
  TextColumn get bankId => text().nullable()();
  TextColumn get templateId => text().nullable()();
  IntColumn get amount => integer().nullable()();
  TextColumn get type => textEnum<TransactionType>().nullable()();
  IntColumn get suggestedCategoryId => integer().nullable().references(
        CategoryRows,
        #id,
        onDelete: KeyAction.setNull,
      )();
  TextColumn get note => text().nullable()();
  DateTimeColumn get valueDate => dateTime().nullable()();
  TextColumn get currencyCode => text().nullable()();
  IntColumn get transactionId => integer().nullable().references(
        TransactionRows,
        #id,
        onDelete: KeyAction.setNull,
      )();
}
