// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $CategoryRowsTable extends CategoryRows
    with TableInfo<$CategoryRowsTable, CategoryRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CategoryRowsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  @override
  late final GeneratedColumnWithTypeConverter<TransactionType, String> type =
      GeneratedColumn<String>('type', aliasedName, false,
              type: DriftSqlType.string, requiredDuringInsert: true)
          .withConverter<TransactionType>($CategoryRowsTable.$convertertype);
  static const VerificationMeta _iconCodePointMeta =
      const VerificationMeta('iconCodePoint');
  @override
  late final GeneratedColumn<int> iconCodePoint = GeneratedColumn<int>(
      'icon_code_point', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _colorValueMeta =
      const VerificationMeta('colorValue');
  @override
  late final GeneratedColumn<int> colorValue = GeneratedColumn<int>(
      'color_value', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _isDefaultMeta =
      const VerificationMeta('isDefault');
  @override
  late final GeneratedColumn<bool> isDefault = GeneratedColumn<bool>(
      'is_default', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_default" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _isFallbackMeta =
      const VerificationMeta('isFallback');
  @override
  late final GeneratedColumn<bool> isFallback = GeneratedColumn<bool>(
      'is_fallback', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_fallback" IN (0, 1))'),
      defaultValue: const Constant(false));
  @override
  List<GeneratedColumn> get $columns =>
      [id, name, type, iconCodePoint, colorValue, isDefault, isFallback];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'categories';
  @override
  VerificationContext validateIntegrity(Insertable<CategoryRow> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('icon_code_point')) {
      context.handle(
          _iconCodePointMeta,
          iconCodePoint.isAcceptableOrUnknown(
              data['icon_code_point']!, _iconCodePointMeta));
    } else if (isInserting) {
      context.missing(_iconCodePointMeta);
    }
    if (data.containsKey('color_value')) {
      context.handle(
          _colorValueMeta,
          colorValue.isAcceptableOrUnknown(
              data['color_value']!, _colorValueMeta));
    } else if (isInserting) {
      context.missing(_colorValueMeta);
    }
    if (data.containsKey('is_default')) {
      context.handle(_isDefaultMeta,
          isDefault.isAcceptableOrUnknown(data['is_default']!, _isDefaultMeta));
    }
    if (data.containsKey('is_fallback')) {
      context.handle(
          _isFallbackMeta,
          isFallback.isAcceptableOrUnknown(
              data['is_fallback']!, _isFallbackMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  List<Set<GeneratedColumn>> get uniqueKeys => [
        {name, type},
      ];
  @override
  CategoryRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CategoryRow(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      type: $CategoryRowsTable.$convertertype.fromSql(attachedDatabase
          .typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}type'])!),
      iconCodePoint: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}icon_code_point'])!,
      colorValue: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}color_value'])!,
      isDefault: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_default'])!,
      isFallback: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_fallback'])!,
    );
  }

  @override
  $CategoryRowsTable createAlias(String alias) {
    return $CategoryRowsTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<TransactionType, String, String> $convertertype =
      const EnumNameConverter<TransactionType>(TransactionType.values);
}

class CategoryRow extends DataClass implements Insertable<CategoryRow> {
  final int id;
  final String name;
  final TransactionType type;
  final int iconCodePoint;
  final int colorValue;
  final bool isDefault;
  final bool isFallback;
  const CategoryRow(
      {required this.id,
      required this.name,
      required this.type,
      required this.iconCodePoint,
      required this.colorValue,
      required this.isDefault,
      required this.isFallback});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    {
      map['type'] =
          Variable<String>($CategoryRowsTable.$convertertype.toSql(type));
    }
    map['icon_code_point'] = Variable<int>(iconCodePoint);
    map['color_value'] = Variable<int>(colorValue);
    map['is_default'] = Variable<bool>(isDefault);
    map['is_fallback'] = Variable<bool>(isFallback);
    return map;
  }

  CategoryRowsCompanion toCompanion(bool nullToAbsent) {
    return CategoryRowsCompanion(
      id: Value(id),
      name: Value(name),
      type: Value(type),
      iconCodePoint: Value(iconCodePoint),
      colorValue: Value(colorValue),
      isDefault: Value(isDefault),
      isFallback: Value(isFallback),
    );
  }

  factory CategoryRow.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CategoryRow(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      type: $CategoryRowsTable.$convertertype
          .fromJson(serializer.fromJson<String>(json['type'])),
      iconCodePoint: serializer.fromJson<int>(json['iconCodePoint']),
      colorValue: serializer.fromJson<int>(json['colorValue']),
      isDefault: serializer.fromJson<bool>(json['isDefault']),
      isFallback: serializer.fromJson<bool>(json['isFallback']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'type': serializer
          .toJson<String>($CategoryRowsTable.$convertertype.toJson(type)),
      'iconCodePoint': serializer.toJson<int>(iconCodePoint),
      'colorValue': serializer.toJson<int>(colorValue),
      'isDefault': serializer.toJson<bool>(isDefault),
      'isFallback': serializer.toJson<bool>(isFallback),
    };
  }

  CategoryRow copyWith(
          {int? id,
          String? name,
          TransactionType? type,
          int? iconCodePoint,
          int? colorValue,
          bool? isDefault,
          bool? isFallback}) =>
      CategoryRow(
        id: id ?? this.id,
        name: name ?? this.name,
        type: type ?? this.type,
        iconCodePoint: iconCodePoint ?? this.iconCodePoint,
        colorValue: colorValue ?? this.colorValue,
        isDefault: isDefault ?? this.isDefault,
        isFallback: isFallback ?? this.isFallback,
      );
  CategoryRow copyWithCompanion(CategoryRowsCompanion data) {
    return CategoryRow(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      type: data.type.present ? data.type.value : this.type,
      iconCodePoint: data.iconCodePoint.present
          ? data.iconCodePoint.value
          : this.iconCodePoint,
      colorValue:
          data.colorValue.present ? data.colorValue.value : this.colorValue,
      isDefault: data.isDefault.present ? data.isDefault.value : this.isDefault,
      isFallback:
          data.isFallback.present ? data.isFallback.value : this.isFallback,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CategoryRow(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('type: $type, ')
          ..write('iconCodePoint: $iconCodePoint, ')
          ..write('colorValue: $colorValue, ')
          ..write('isDefault: $isDefault, ')
          ..write('isFallback: $isFallback')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id, name, type, iconCodePoint, colorValue, isDefault, isFallback);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CategoryRow &&
          other.id == this.id &&
          other.name == this.name &&
          other.type == this.type &&
          other.iconCodePoint == this.iconCodePoint &&
          other.colorValue == this.colorValue &&
          other.isDefault == this.isDefault &&
          other.isFallback == this.isFallback);
}

class CategoryRowsCompanion extends UpdateCompanion<CategoryRow> {
  final Value<int> id;
  final Value<String> name;
  final Value<TransactionType> type;
  final Value<int> iconCodePoint;
  final Value<int> colorValue;
  final Value<bool> isDefault;
  final Value<bool> isFallback;
  const CategoryRowsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.type = const Value.absent(),
    this.iconCodePoint = const Value.absent(),
    this.colorValue = const Value.absent(),
    this.isDefault = const Value.absent(),
    this.isFallback = const Value.absent(),
  });
  CategoryRowsCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    required TransactionType type,
    required int iconCodePoint,
    required int colorValue,
    this.isDefault = const Value.absent(),
    this.isFallback = const Value.absent(),
  })  : name = Value(name),
        type = Value(type),
        iconCodePoint = Value(iconCodePoint),
        colorValue = Value(colorValue);
  static Insertable<CategoryRow> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<String>? type,
    Expression<int>? iconCodePoint,
    Expression<int>? colorValue,
    Expression<bool>? isDefault,
    Expression<bool>? isFallback,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (type != null) 'type': type,
      if (iconCodePoint != null) 'icon_code_point': iconCodePoint,
      if (colorValue != null) 'color_value': colorValue,
      if (isDefault != null) 'is_default': isDefault,
      if (isFallback != null) 'is_fallback': isFallback,
    });
  }

  CategoryRowsCompanion copyWith(
      {Value<int>? id,
      Value<String>? name,
      Value<TransactionType>? type,
      Value<int>? iconCodePoint,
      Value<int>? colorValue,
      Value<bool>? isDefault,
      Value<bool>? isFallback}) {
    return CategoryRowsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      type: type ?? this.type,
      iconCodePoint: iconCodePoint ?? this.iconCodePoint,
      colorValue: colorValue ?? this.colorValue,
      isDefault: isDefault ?? this.isDefault,
      isFallback: isFallback ?? this.isFallback,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (type.present) {
      map['type'] =
          Variable<String>($CategoryRowsTable.$convertertype.toSql(type.value));
    }
    if (iconCodePoint.present) {
      map['icon_code_point'] = Variable<int>(iconCodePoint.value);
    }
    if (colorValue.present) {
      map['color_value'] = Variable<int>(colorValue.value);
    }
    if (isDefault.present) {
      map['is_default'] = Variable<bool>(isDefault.value);
    }
    if (isFallback.present) {
      map['is_fallback'] = Variable<bool>(isFallback.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CategoryRowsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('type: $type, ')
          ..write('iconCodePoint: $iconCodePoint, ')
          ..write('colorValue: $colorValue, ')
          ..write('isDefault: $isDefault, ')
          ..write('isFallback: $isFallback')
          ..write(')'))
        .toString();
  }
}

class $TransactionRowsTable extends TransactionRows
    with TableInfo<$TransactionRowsTable, TransactionRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TransactionRowsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _amountMeta = const VerificationMeta('amount');
  @override
  late final GeneratedColumn<int> amount = GeneratedColumn<int>(
      'amount', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  @override
  late final GeneratedColumnWithTypeConverter<TransactionType, String> type =
      GeneratedColumn<String>('type', aliasedName, false,
              type: DriftSqlType.string, requiredDuringInsert: true)
          .withConverter<TransactionType>($TransactionRowsTable.$convertertype);
  static const VerificationMeta _categoryIdMeta =
      const VerificationMeta('categoryId');
  @override
  late final GeneratedColumn<int> categoryId = GeneratedColumn<int>(
      'category_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES categories (id)'));
  static const VerificationMeta _noteMeta = const VerificationMeta('note');
  @override
  late final GeneratedColumn<String> note = GeneratedColumn<String>(
      'note', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _dateMeta = const VerificationMeta('date');
  @override
  late final GeneratedColumn<DateTime> date = GeneratedColumn<DateTime>(
      'date', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  @override
  late final GeneratedColumnWithTypeConverter<TransactionSource, String>
      source = GeneratedColumn<String>('source', aliasedName, false,
              type: DriftSqlType.string,
              requiredDuringInsert: false,
              defaultValue: const Constant('manual'))
          .withConverter<TransactionSource>(
              $TransactionRowsTable.$convertersource);
  @override
  List<GeneratedColumn> get $columns =>
      [id, amount, type, categoryId, note, date, createdAt, source];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'transactions';
  @override
  VerificationContext validateIntegrity(Insertable<TransactionRow> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('amount')) {
      context.handle(_amountMeta,
          amount.isAcceptableOrUnknown(data['amount']!, _amountMeta));
    } else if (isInserting) {
      context.missing(_amountMeta);
    }
    if (data.containsKey('category_id')) {
      context.handle(
          _categoryIdMeta,
          categoryId.isAcceptableOrUnknown(
              data['category_id']!, _categoryIdMeta));
    } else if (isInserting) {
      context.missing(_categoryIdMeta);
    }
    if (data.containsKey('note')) {
      context.handle(
          _noteMeta, note.isAcceptableOrUnknown(data['note']!, _noteMeta));
    }
    if (data.containsKey('date')) {
      context.handle(
          _dateMeta, date.isAcceptableOrUnknown(data['date']!, _dateMeta));
    } else if (isInserting) {
      context.missing(_dateMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  TransactionRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return TransactionRow(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      amount: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}amount'])!,
      type: $TransactionRowsTable.$convertertype.fromSql(attachedDatabase
          .typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}type'])!),
      categoryId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}category_id'])!,
      note: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}note']),
      date: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}date'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      source: $TransactionRowsTable.$convertersource.fromSql(attachedDatabase
          .typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}source'])!),
    );
  }

  @override
  $TransactionRowsTable createAlias(String alias) {
    return $TransactionRowsTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<TransactionType, String, String> $convertertype =
      const EnumNameConverter<TransactionType>(TransactionType.values);
  static JsonTypeConverter2<TransactionSource, String, String>
      $convertersource =
      const EnumNameConverter<TransactionSource>(TransactionSource.values);
}

class TransactionRow extends DataClass implements Insertable<TransactionRow> {
  final int id;
  final int amount;
  final TransactionType type;
  final int categoryId;
  final String? note;
  final DateTime date;
  final DateTime createdAt;
  final TransactionSource source;
  const TransactionRow(
      {required this.id,
      required this.amount,
      required this.type,
      required this.categoryId,
      this.note,
      required this.date,
      required this.createdAt,
      required this.source});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['amount'] = Variable<int>(amount);
    {
      map['type'] =
          Variable<String>($TransactionRowsTable.$convertertype.toSql(type));
    }
    map['category_id'] = Variable<int>(categoryId);
    if (!nullToAbsent || note != null) {
      map['note'] = Variable<String>(note);
    }
    map['date'] = Variable<DateTime>(date);
    map['created_at'] = Variable<DateTime>(createdAt);
    {
      map['source'] = Variable<String>(
          $TransactionRowsTable.$convertersource.toSql(source));
    }
    return map;
  }

  TransactionRowsCompanion toCompanion(bool nullToAbsent) {
    return TransactionRowsCompanion(
      id: Value(id),
      amount: Value(amount),
      type: Value(type),
      categoryId: Value(categoryId),
      note: note == null && nullToAbsent ? const Value.absent() : Value(note),
      date: Value(date),
      createdAt: Value(createdAt),
      source: Value(source),
    );
  }

  factory TransactionRow.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return TransactionRow(
      id: serializer.fromJson<int>(json['id']),
      amount: serializer.fromJson<int>(json['amount']),
      type: $TransactionRowsTable.$convertertype
          .fromJson(serializer.fromJson<String>(json['type'])),
      categoryId: serializer.fromJson<int>(json['categoryId']),
      note: serializer.fromJson<String?>(json['note']),
      date: serializer.fromJson<DateTime>(json['date']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      source: $TransactionRowsTable.$convertersource
          .fromJson(serializer.fromJson<String>(json['source'])),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'amount': serializer.toJson<int>(amount),
      'type': serializer
          .toJson<String>($TransactionRowsTable.$convertertype.toJson(type)),
      'categoryId': serializer.toJson<int>(categoryId),
      'note': serializer.toJson<String?>(note),
      'date': serializer.toJson<DateTime>(date),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'source': serializer.toJson<String>(
          $TransactionRowsTable.$convertersource.toJson(source)),
    };
  }

  TransactionRow copyWith(
          {int? id,
          int? amount,
          TransactionType? type,
          int? categoryId,
          Value<String?> note = const Value.absent(),
          DateTime? date,
          DateTime? createdAt,
          TransactionSource? source}) =>
      TransactionRow(
        id: id ?? this.id,
        amount: amount ?? this.amount,
        type: type ?? this.type,
        categoryId: categoryId ?? this.categoryId,
        note: note.present ? note.value : this.note,
        date: date ?? this.date,
        createdAt: createdAt ?? this.createdAt,
        source: source ?? this.source,
      );
  TransactionRow copyWithCompanion(TransactionRowsCompanion data) {
    return TransactionRow(
      id: data.id.present ? data.id.value : this.id,
      amount: data.amount.present ? data.amount.value : this.amount,
      type: data.type.present ? data.type.value : this.type,
      categoryId:
          data.categoryId.present ? data.categoryId.value : this.categoryId,
      note: data.note.present ? data.note.value : this.note,
      date: data.date.present ? data.date.value : this.date,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      source: data.source.present ? data.source.value : this.source,
    );
  }

  @override
  String toString() {
    return (StringBuffer('TransactionRow(')
          ..write('id: $id, ')
          ..write('amount: $amount, ')
          ..write('type: $type, ')
          ..write('categoryId: $categoryId, ')
          ..write('note: $note, ')
          ..write('date: $date, ')
          ..write('createdAt: $createdAt, ')
          ..write('source: $source')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, amount, type, categoryId, note, date, createdAt, source);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is TransactionRow &&
          other.id == this.id &&
          other.amount == this.amount &&
          other.type == this.type &&
          other.categoryId == this.categoryId &&
          other.note == this.note &&
          other.date == this.date &&
          other.createdAt == this.createdAt &&
          other.source == this.source);
}

class TransactionRowsCompanion extends UpdateCompanion<TransactionRow> {
  final Value<int> id;
  final Value<int> amount;
  final Value<TransactionType> type;
  final Value<int> categoryId;
  final Value<String?> note;
  final Value<DateTime> date;
  final Value<DateTime> createdAt;
  final Value<TransactionSource> source;
  const TransactionRowsCompanion({
    this.id = const Value.absent(),
    this.amount = const Value.absent(),
    this.type = const Value.absent(),
    this.categoryId = const Value.absent(),
    this.note = const Value.absent(),
    this.date = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.source = const Value.absent(),
  });
  TransactionRowsCompanion.insert({
    this.id = const Value.absent(),
    required int amount,
    required TransactionType type,
    required int categoryId,
    this.note = const Value.absent(),
    required DateTime date,
    required DateTime createdAt,
    this.source = const Value.absent(),
  })  : amount = Value(amount),
        type = Value(type),
        categoryId = Value(categoryId),
        date = Value(date),
        createdAt = Value(createdAt);
  static Insertable<TransactionRow> custom({
    Expression<int>? id,
    Expression<int>? amount,
    Expression<String>? type,
    Expression<int>? categoryId,
    Expression<String>? note,
    Expression<DateTime>? date,
    Expression<DateTime>? createdAt,
    Expression<String>? source,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (amount != null) 'amount': amount,
      if (type != null) 'type': type,
      if (categoryId != null) 'category_id': categoryId,
      if (note != null) 'note': note,
      if (date != null) 'date': date,
      if (createdAt != null) 'created_at': createdAt,
      if (source != null) 'source': source,
    });
  }

  TransactionRowsCompanion copyWith(
      {Value<int>? id,
      Value<int>? amount,
      Value<TransactionType>? type,
      Value<int>? categoryId,
      Value<String?>? note,
      Value<DateTime>? date,
      Value<DateTime>? createdAt,
      Value<TransactionSource>? source}) {
    return TransactionRowsCompanion(
      id: id ?? this.id,
      amount: amount ?? this.amount,
      type: type ?? this.type,
      categoryId: categoryId ?? this.categoryId,
      note: note ?? this.note,
      date: date ?? this.date,
      createdAt: createdAt ?? this.createdAt,
      source: source ?? this.source,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (amount.present) {
      map['amount'] = Variable<int>(amount.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(
          $TransactionRowsTable.$convertertype.toSql(type.value));
    }
    if (categoryId.present) {
      map['category_id'] = Variable<int>(categoryId.value);
    }
    if (note.present) {
      map['note'] = Variable<String>(note.value);
    }
    if (date.present) {
      map['date'] = Variable<DateTime>(date.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (source.present) {
      map['source'] = Variable<String>(
          $TransactionRowsTable.$convertersource.toSql(source.value));
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TransactionRowsCompanion(')
          ..write('id: $id, ')
          ..write('amount: $amount, ')
          ..write('type: $type, ')
          ..write('categoryId: $categoryId, ')
          ..write('note: $note, ')
          ..write('date: $date, ')
          ..write('createdAt: $createdAt, ')
          ..write('source: $source')
          ..write(')'))
        .toString();
  }
}

class $SettingsRowsTable extends SettingsRows
    with TableInfo<$SettingsRowsTable, SettingsRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SettingsRowsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _currencyCodeMeta =
      const VerificationMeta('currencyCode');
  @override
  late final GeneratedColumn<String> currencyCode = GeneratedColumn<String>(
      'currency_code', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('EGP'));
  static const VerificationMeta _smsLastScanAtMeta =
      const VerificationMeta('smsLastScanAt');
  @override
  late final GeneratedColumn<DateTime> smsLastScanAt =
      GeneratedColumn<DateTime>('sms_last_scan_at', aliasedName, true,
          type: DriftSqlType.dateTime, requiredDuringInsert: false);
  @override
  late final GeneratedColumnWithTypeConverter<AppThemeMode, String> themeMode =
      GeneratedColumn<String>('theme_mode', aliasedName, false,
              type: DriftSqlType.string,
              requiredDuringInsert: false,
              defaultValue: const Constant('system'))
          .withConverter<AppThemeMode>($SettingsRowsTable.$converterthemeMode);
  @override
  late final GeneratedColumnWithTypeConverter<TransactionType, String>
      defaultEntryType = GeneratedColumn<String>(
              'default_entry_type', aliasedName, false,
              type: DriftSqlType.string,
              requiredDuringInsert: false,
              defaultValue: const Constant('expense'))
          .withConverter<TransactionType>(
              $SettingsRowsTable.$converterdefaultEntryType);
  @override
  late final GeneratedColumnWithTypeConverter<AppLocale, String> localeCode =
      GeneratedColumn<String>('locale_code', aliasedName, false,
              type: DriftSqlType.string,
              requiredDuringInsert: false,
              defaultValue: const Constant('en'))
          .withConverter<AppLocale>($SettingsRowsTable.$converterlocaleCode);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        currencyCode,
        smsLastScanAt,
        themeMode,
        defaultEntryType,
        localeCode
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'app_settings';
  @override
  VerificationContext validateIntegrity(Insertable<SettingsRow> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('currency_code')) {
      context.handle(
          _currencyCodeMeta,
          currencyCode.isAcceptableOrUnknown(
              data['currency_code']!, _currencyCodeMeta));
    }
    if (data.containsKey('sms_last_scan_at')) {
      context.handle(
          _smsLastScanAtMeta,
          smsLastScanAt.isAcceptableOrUnknown(
              data['sms_last_scan_at']!, _smsLastScanAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  SettingsRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SettingsRow(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      currencyCode: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}currency_code'])!,
      smsLastScanAt: attachedDatabase.typeMapping.read(
          DriftSqlType.dateTime, data['${effectivePrefix}sms_last_scan_at']),
      themeMode: $SettingsRowsTable.$converterthemeMode.fromSql(attachedDatabase
          .typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}theme_mode'])!),
      defaultEntryType: $SettingsRowsTable.$converterdefaultEntryType.fromSql(
          attachedDatabase.typeMapping.read(DriftSqlType.string,
              data['${effectivePrefix}default_entry_type'])!),
      localeCode: $SettingsRowsTable.$converterlocaleCode.fromSql(
          attachedDatabase.typeMapping.read(
              DriftSqlType.string, data['${effectivePrefix}locale_code'])!),
    );
  }

  @override
  $SettingsRowsTable createAlias(String alias) {
    return $SettingsRowsTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<AppThemeMode, String, String> $converterthemeMode =
      const EnumNameConverter<AppThemeMode>(AppThemeMode.values);
  static JsonTypeConverter2<TransactionType, String, String>
      $converterdefaultEntryType =
      const EnumNameConverter<TransactionType>(TransactionType.values);
  static JsonTypeConverter2<AppLocale, String, String> $converterlocaleCode =
      const EnumNameConverter<AppLocale>(AppLocale.values);
}

class SettingsRow extends DataClass implements Insertable<SettingsRow> {
  final int id;
  final String currencyCode;
  final DateTime? smsLastScanAt;
  final AppThemeMode themeMode;
  final TransactionType defaultEntryType;
  final AppLocale localeCode;
  const SettingsRow(
      {required this.id,
      required this.currencyCode,
      this.smsLastScanAt,
      required this.themeMode,
      required this.defaultEntryType,
      required this.localeCode});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['currency_code'] = Variable<String>(currencyCode);
    if (!nullToAbsent || smsLastScanAt != null) {
      map['sms_last_scan_at'] = Variable<DateTime>(smsLastScanAt);
    }
    {
      map['theme_mode'] = Variable<String>(
          $SettingsRowsTable.$converterthemeMode.toSql(themeMode));
    }
    {
      map['default_entry_type'] = Variable<String>($SettingsRowsTable
          .$converterdefaultEntryType
          .toSql(defaultEntryType));
    }
    {
      map['locale_code'] = Variable<String>(
          $SettingsRowsTable.$converterlocaleCode.toSql(localeCode));
    }
    return map;
  }

  SettingsRowsCompanion toCompanion(bool nullToAbsent) {
    return SettingsRowsCompanion(
      id: Value(id),
      currencyCode: Value(currencyCode),
      smsLastScanAt: smsLastScanAt == null && nullToAbsent
          ? const Value.absent()
          : Value(smsLastScanAt),
      themeMode: Value(themeMode),
      defaultEntryType: Value(defaultEntryType),
      localeCode: Value(localeCode),
    );
  }

  factory SettingsRow.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SettingsRow(
      id: serializer.fromJson<int>(json['id']),
      currencyCode: serializer.fromJson<String>(json['currencyCode']),
      smsLastScanAt: serializer.fromJson<DateTime?>(json['smsLastScanAt']),
      themeMode: $SettingsRowsTable.$converterthemeMode
          .fromJson(serializer.fromJson<String>(json['themeMode'])),
      defaultEntryType: $SettingsRowsTable.$converterdefaultEntryType
          .fromJson(serializer.fromJson<String>(json['defaultEntryType'])),
      localeCode: $SettingsRowsTable.$converterlocaleCode
          .fromJson(serializer.fromJson<String>(json['localeCode'])),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'currencyCode': serializer.toJson<String>(currencyCode),
      'smsLastScanAt': serializer.toJson<DateTime?>(smsLastScanAt),
      'themeMode': serializer.toJson<String>(
          $SettingsRowsTable.$converterthemeMode.toJson(themeMode)),
      'defaultEntryType': serializer.toJson<String>($SettingsRowsTable
          .$converterdefaultEntryType
          .toJson(defaultEntryType)),
      'localeCode': serializer.toJson<String>(
          $SettingsRowsTable.$converterlocaleCode.toJson(localeCode)),
    };
  }

  SettingsRow copyWith(
          {int? id,
          String? currencyCode,
          Value<DateTime?> smsLastScanAt = const Value.absent(),
          AppThemeMode? themeMode,
          TransactionType? defaultEntryType,
          AppLocale? localeCode}) =>
      SettingsRow(
        id: id ?? this.id,
        currencyCode: currencyCode ?? this.currencyCode,
        smsLastScanAt:
            smsLastScanAt.present ? smsLastScanAt.value : this.smsLastScanAt,
        themeMode: themeMode ?? this.themeMode,
        defaultEntryType: defaultEntryType ?? this.defaultEntryType,
        localeCode: localeCode ?? this.localeCode,
      );
  SettingsRow copyWithCompanion(SettingsRowsCompanion data) {
    return SettingsRow(
      id: data.id.present ? data.id.value : this.id,
      currencyCode: data.currencyCode.present
          ? data.currencyCode.value
          : this.currencyCode,
      smsLastScanAt: data.smsLastScanAt.present
          ? data.smsLastScanAt.value
          : this.smsLastScanAt,
      themeMode: data.themeMode.present ? data.themeMode.value : this.themeMode,
      defaultEntryType: data.defaultEntryType.present
          ? data.defaultEntryType.value
          : this.defaultEntryType,
      localeCode:
          data.localeCode.present ? data.localeCode.value : this.localeCode,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SettingsRow(')
          ..write('id: $id, ')
          ..write('currencyCode: $currencyCode, ')
          ..write('smsLastScanAt: $smsLastScanAt, ')
          ..write('themeMode: $themeMode, ')
          ..write('defaultEntryType: $defaultEntryType, ')
          ..write('localeCode: $localeCode')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id, currencyCode, smsLastScanAt, themeMode, defaultEntryType, localeCode);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SettingsRow &&
          other.id == this.id &&
          other.currencyCode == this.currencyCode &&
          other.smsLastScanAt == this.smsLastScanAt &&
          other.themeMode == this.themeMode &&
          other.defaultEntryType == this.defaultEntryType &&
          other.localeCode == this.localeCode);
}

class SettingsRowsCompanion extends UpdateCompanion<SettingsRow> {
  final Value<int> id;
  final Value<String> currencyCode;
  final Value<DateTime?> smsLastScanAt;
  final Value<AppThemeMode> themeMode;
  final Value<TransactionType> defaultEntryType;
  final Value<AppLocale> localeCode;
  const SettingsRowsCompanion({
    this.id = const Value.absent(),
    this.currencyCode = const Value.absent(),
    this.smsLastScanAt = const Value.absent(),
    this.themeMode = const Value.absent(),
    this.defaultEntryType = const Value.absent(),
    this.localeCode = const Value.absent(),
  });
  SettingsRowsCompanion.insert({
    this.id = const Value.absent(),
    this.currencyCode = const Value.absent(),
    this.smsLastScanAt = const Value.absent(),
    this.themeMode = const Value.absent(),
    this.defaultEntryType = const Value.absent(),
    this.localeCode = const Value.absent(),
  });
  static Insertable<SettingsRow> custom({
    Expression<int>? id,
    Expression<String>? currencyCode,
    Expression<DateTime>? smsLastScanAt,
    Expression<String>? themeMode,
    Expression<String>? defaultEntryType,
    Expression<String>? localeCode,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (currencyCode != null) 'currency_code': currencyCode,
      if (smsLastScanAt != null) 'sms_last_scan_at': smsLastScanAt,
      if (themeMode != null) 'theme_mode': themeMode,
      if (defaultEntryType != null) 'default_entry_type': defaultEntryType,
      if (localeCode != null) 'locale_code': localeCode,
    });
  }

  SettingsRowsCompanion copyWith(
      {Value<int>? id,
      Value<String>? currencyCode,
      Value<DateTime?>? smsLastScanAt,
      Value<AppThemeMode>? themeMode,
      Value<TransactionType>? defaultEntryType,
      Value<AppLocale>? localeCode}) {
    return SettingsRowsCompanion(
      id: id ?? this.id,
      currencyCode: currencyCode ?? this.currencyCode,
      smsLastScanAt: smsLastScanAt ?? this.smsLastScanAt,
      themeMode: themeMode ?? this.themeMode,
      defaultEntryType: defaultEntryType ?? this.defaultEntryType,
      localeCode: localeCode ?? this.localeCode,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (currencyCode.present) {
      map['currency_code'] = Variable<String>(currencyCode.value);
    }
    if (smsLastScanAt.present) {
      map['sms_last_scan_at'] = Variable<DateTime>(smsLastScanAt.value);
    }
    if (themeMode.present) {
      map['theme_mode'] = Variable<String>(
          $SettingsRowsTable.$converterthemeMode.toSql(themeMode.value));
    }
    if (defaultEntryType.present) {
      map['default_entry_type'] = Variable<String>($SettingsRowsTable
          .$converterdefaultEntryType
          .toSql(defaultEntryType.value));
    }
    if (localeCode.present) {
      map['locale_code'] = Variable<String>(
          $SettingsRowsTable.$converterlocaleCode.toSql(localeCode.value));
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SettingsRowsCompanion(')
          ..write('id: $id, ')
          ..write('currencyCode: $currencyCode, ')
          ..write('smsLastScanAt: $smsLastScanAt, ')
          ..write('themeMode: $themeMode, ')
          ..write('defaultEntryType: $defaultEntryType, ')
          ..write('localeCode: $localeCode')
          ..write(')'))
        .toString();
  }
}

class $SmsInboxRowsTable extends SmsInboxRows
    with TableInfo<$SmsInboxRowsTable, SmsInboxRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SmsInboxRowsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _fingerprintMeta =
      const VerificationMeta('fingerprint');
  @override
  late final GeneratedColumn<String> fingerprint = GeneratedColumn<String>(
      'fingerprint', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'));
  static const VerificationMeta _platformMessageIdMeta =
      const VerificationMeta('platformMessageId');
  @override
  late final GeneratedColumn<String> platformMessageId =
      GeneratedColumn<String>('platform_message_id', aliasedName, true,
          type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _senderMeta = const VerificationMeta('sender');
  @override
  late final GeneratedColumn<String> sender = GeneratedColumn<String>(
      'sender', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _bodyMeta = const VerificationMeta('body');
  @override
  late final GeneratedColumn<String> body = GeneratedColumn<String>(
      'body', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _receivedAtMeta =
      const VerificationMeta('receivedAt');
  @override
  late final GeneratedColumn<DateTime> receivedAt = GeneratedColumn<DateTime>(
      'received_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  @override
  late final GeneratedColumnWithTypeConverter<SmsInboxStatus, String> status =
      GeneratedColumn<String>('status', aliasedName, false,
              type: DriftSqlType.string, requiredDuringInsert: true)
          .withConverter<SmsInboxStatus>($SmsInboxRowsTable.$converterstatus);
  static const VerificationMeta _bankIdMeta = const VerificationMeta('bankId');
  @override
  late final GeneratedColumn<String> bankId = GeneratedColumn<String>(
      'bank_id', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _templateIdMeta =
      const VerificationMeta('templateId');
  @override
  late final GeneratedColumn<String> templateId = GeneratedColumn<String>(
      'template_id', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _amountMeta = const VerificationMeta('amount');
  @override
  late final GeneratedColumn<int> amount = GeneratedColumn<int>(
      'amount', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  @override
  late final GeneratedColumnWithTypeConverter<TransactionType?, String> type =
      GeneratedColumn<String>('type', aliasedName, true,
              type: DriftSqlType.string, requiredDuringInsert: false)
          .withConverter<TransactionType?>($SmsInboxRowsTable.$convertertypen);
  static const VerificationMeta _suggestedCategoryIdMeta =
      const VerificationMeta('suggestedCategoryId');
  @override
  late final GeneratedColumn<int> suggestedCategoryId = GeneratedColumn<int>(
      'suggested_category_id', aliasedName, true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES categories (id) ON DELETE SET NULL'));
  static const VerificationMeta _noteMeta = const VerificationMeta('note');
  @override
  late final GeneratedColumn<String> note = GeneratedColumn<String>(
      'note', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _valueDateMeta =
      const VerificationMeta('valueDate');
  @override
  late final GeneratedColumn<DateTime> valueDate = GeneratedColumn<DateTime>(
      'value_date', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _currencyCodeMeta =
      const VerificationMeta('currencyCode');
  @override
  late final GeneratedColumn<String> currencyCode = GeneratedColumn<String>(
      'currency_code', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _transactionIdMeta =
      const VerificationMeta('transactionId');
  @override
  late final GeneratedColumn<int> transactionId = GeneratedColumn<int>(
      'transaction_id', aliasedName, true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES transactions (id) ON DELETE SET NULL'));
  @override
  List<GeneratedColumn> get $columns => [
        id,
        fingerprint,
        platformMessageId,
        sender,
        body,
        receivedAt,
        createdAt,
        status,
        bankId,
        templateId,
        amount,
        type,
        suggestedCategoryId,
        note,
        valueDate,
        currencyCode,
        transactionId
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'sms_inbox';
  @override
  VerificationContext validateIntegrity(Insertable<SmsInboxRow> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('fingerprint')) {
      context.handle(
          _fingerprintMeta,
          fingerprint.isAcceptableOrUnknown(
              data['fingerprint']!, _fingerprintMeta));
    } else if (isInserting) {
      context.missing(_fingerprintMeta);
    }
    if (data.containsKey('platform_message_id')) {
      context.handle(
          _platformMessageIdMeta,
          platformMessageId.isAcceptableOrUnknown(
              data['platform_message_id']!, _platformMessageIdMeta));
    }
    if (data.containsKey('sender')) {
      context.handle(_senderMeta,
          sender.isAcceptableOrUnknown(data['sender']!, _senderMeta));
    } else if (isInserting) {
      context.missing(_senderMeta);
    }
    if (data.containsKey('body')) {
      context.handle(
          _bodyMeta, body.isAcceptableOrUnknown(data['body']!, _bodyMeta));
    } else if (isInserting) {
      context.missing(_bodyMeta);
    }
    if (data.containsKey('received_at')) {
      context.handle(
          _receivedAtMeta,
          receivedAt.isAcceptableOrUnknown(
              data['received_at']!, _receivedAtMeta));
    } else if (isInserting) {
      context.missing(_receivedAtMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('bank_id')) {
      context.handle(_bankIdMeta,
          bankId.isAcceptableOrUnknown(data['bank_id']!, _bankIdMeta));
    }
    if (data.containsKey('template_id')) {
      context.handle(
          _templateIdMeta,
          templateId.isAcceptableOrUnknown(
              data['template_id']!, _templateIdMeta));
    }
    if (data.containsKey('amount')) {
      context.handle(_amountMeta,
          amount.isAcceptableOrUnknown(data['amount']!, _amountMeta));
    }
    if (data.containsKey('suggested_category_id')) {
      context.handle(
          _suggestedCategoryIdMeta,
          suggestedCategoryId.isAcceptableOrUnknown(
              data['suggested_category_id']!, _suggestedCategoryIdMeta));
    }
    if (data.containsKey('note')) {
      context.handle(
          _noteMeta, note.isAcceptableOrUnknown(data['note']!, _noteMeta));
    }
    if (data.containsKey('value_date')) {
      context.handle(_valueDateMeta,
          valueDate.isAcceptableOrUnknown(data['value_date']!, _valueDateMeta));
    }
    if (data.containsKey('currency_code')) {
      context.handle(
          _currencyCodeMeta,
          currencyCode.isAcceptableOrUnknown(
              data['currency_code']!, _currencyCodeMeta));
    }
    if (data.containsKey('transaction_id')) {
      context.handle(
          _transactionIdMeta,
          transactionId.isAcceptableOrUnknown(
              data['transaction_id']!, _transactionIdMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  SmsInboxRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SmsInboxRow(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      fingerprint: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}fingerprint'])!,
      platformMessageId: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}platform_message_id']),
      sender: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}sender'])!,
      body: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}body'])!,
      receivedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}received_at'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      status: $SmsInboxRowsTable.$converterstatus.fromSql(attachedDatabase
          .typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}status'])!),
      bankId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}bank_id']),
      templateId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}template_id']),
      amount: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}amount']),
      type: $SmsInboxRowsTable.$convertertypen.fromSql(attachedDatabase
          .typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}type'])),
      suggestedCategoryId: attachedDatabase.typeMapping.read(
          DriftSqlType.int, data['${effectivePrefix}suggested_category_id']),
      note: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}note']),
      valueDate: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}value_date']),
      currencyCode: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}currency_code']),
      transactionId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}transaction_id']),
    );
  }

  @override
  $SmsInboxRowsTable createAlias(String alias) {
    return $SmsInboxRowsTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<SmsInboxStatus, String, String> $converterstatus =
      const EnumNameConverter<SmsInboxStatus>(SmsInboxStatus.values);
  static JsonTypeConverter2<TransactionType, String, String> $convertertype =
      const EnumNameConverter<TransactionType>(TransactionType.values);
  static JsonTypeConverter2<TransactionType?, String?, String?>
      $convertertypen = JsonTypeConverter2.asNullable($convertertype);
}

class SmsInboxRow extends DataClass implements Insertable<SmsInboxRow> {
  final int id;
  final String fingerprint;
  final String? platformMessageId;
  final String sender;
  final String body;
  final DateTime receivedAt;
  final DateTime createdAt;
  final SmsInboxStatus status;
  final String? bankId;
  final String? templateId;
  final int? amount;
  final TransactionType? type;
  final int? suggestedCategoryId;
  final String? note;
  final DateTime? valueDate;
  final String? currencyCode;
  final int? transactionId;
  const SmsInboxRow(
      {required this.id,
      required this.fingerprint,
      this.platformMessageId,
      required this.sender,
      required this.body,
      required this.receivedAt,
      required this.createdAt,
      required this.status,
      this.bankId,
      this.templateId,
      this.amount,
      this.type,
      this.suggestedCategoryId,
      this.note,
      this.valueDate,
      this.currencyCode,
      this.transactionId});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['fingerprint'] = Variable<String>(fingerprint);
    if (!nullToAbsent || platformMessageId != null) {
      map['platform_message_id'] = Variable<String>(platformMessageId);
    }
    map['sender'] = Variable<String>(sender);
    map['body'] = Variable<String>(body);
    map['received_at'] = Variable<DateTime>(receivedAt);
    map['created_at'] = Variable<DateTime>(createdAt);
    {
      map['status'] =
          Variable<String>($SmsInboxRowsTable.$converterstatus.toSql(status));
    }
    if (!nullToAbsent || bankId != null) {
      map['bank_id'] = Variable<String>(bankId);
    }
    if (!nullToAbsent || templateId != null) {
      map['template_id'] = Variable<String>(templateId);
    }
    if (!nullToAbsent || amount != null) {
      map['amount'] = Variable<int>(amount);
    }
    if (!nullToAbsent || type != null) {
      map['type'] =
          Variable<String>($SmsInboxRowsTable.$convertertypen.toSql(type));
    }
    if (!nullToAbsent || suggestedCategoryId != null) {
      map['suggested_category_id'] = Variable<int>(suggestedCategoryId);
    }
    if (!nullToAbsent || note != null) {
      map['note'] = Variable<String>(note);
    }
    if (!nullToAbsent || valueDate != null) {
      map['value_date'] = Variable<DateTime>(valueDate);
    }
    if (!nullToAbsent || currencyCode != null) {
      map['currency_code'] = Variable<String>(currencyCode);
    }
    if (!nullToAbsent || transactionId != null) {
      map['transaction_id'] = Variable<int>(transactionId);
    }
    return map;
  }

  SmsInboxRowsCompanion toCompanion(bool nullToAbsent) {
    return SmsInboxRowsCompanion(
      id: Value(id),
      fingerprint: Value(fingerprint),
      platformMessageId: platformMessageId == null && nullToAbsent
          ? const Value.absent()
          : Value(platformMessageId),
      sender: Value(sender),
      body: Value(body),
      receivedAt: Value(receivedAt),
      createdAt: Value(createdAt),
      status: Value(status),
      bankId:
          bankId == null && nullToAbsent ? const Value.absent() : Value(bankId),
      templateId: templateId == null && nullToAbsent
          ? const Value.absent()
          : Value(templateId),
      amount:
          amount == null && nullToAbsent ? const Value.absent() : Value(amount),
      type: type == null && nullToAbsent ? const Value.absent() : Value(type),
      suggestedCategoryId: suggestedCategoryId == null && nullToAbsent
          ? const Value.absent()
          : Value(suggestedCategoryId),
      note: note == null && nullToAbsent ? const Value.absent() : Value(note),
      valueDate: valueDate == null && nullToAbsent
          ? const Value.absent()
          : Value(valueDate),
      currencyCode: currencyCode == null && nullToAbsent
          ? const Value.absent()
          : Value(currencyCode),
      transactionId: transactionId == null && nullToAbsent
          ? const Value.absent()
          : Value(transactionId),
    );
  }

  factory SmsInboxRow.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SmsInboxRow(
      id: serializer.fromJson<int>(json['id']),
      fingerprint: serializer.fromJson<String>(json['fingerprint']),
      platformMessageId:
          serializer.fromJson<String?>(json['platformMessageId']),
      sender: serializer.fromJson<String>(json['sender']),
      body: serializer.fromJson<String>(json['body']),
      receivedAt: serializer.fromJson<DateTime>(json['receivedAt']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      status: $SmsInboxRowsTable.$converterstatus
          .fromJson(serializer.fromJson<String>(json['status'])),
      bankId: serializer.fromJson<String?>(json['bankId']),
      templateId: serializer.fromJson<String?>(json['templateId']),
      amount: serializer.fromJson<int?>(json['amount']),
      type: $SmsInboxRowsTable.$convertertypen
          .fromJson(serializer.fromJson<String?>(json['type'])),
      suggestedCategoryId:
          serializer.fromJson<int?>(json['suggestedCategoryId']),
      note: serializer.fromJson<String?>(json['note']),
      valueDate: serializer.fromJson<DateTime?>(json['valueDate']),
      currencyCode: serializer.fromJson<String?>(json['currencyCode']),
      transactionId: serializer.fromJson<int?>(json['transactionId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'fingerprint': serializer.toJson<String>(fingerprint),
      'platformMessageId': serializer.toJson<String?>(platformMessageId),
      'sender': serializer.toJson<String>(sender),
      'body': serializer.toJson<String>(body),
      'receivedAt': serializer.toJson<DateTime>(receivedAt),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'status': serializer
          .toJson<String>($SmsInboxRowsTable.$converterstatus.toJson(status)),
      'bankId': serializer.toJson<String?>(bankId),
      'templateId': serializer.toJson<String?>(templateId),
      'amount': serializer.toJson<int?>(amount),
      'type': serializer
          .toJson<String?>($SmsInboxRowsTable.$convertertypen.toJson(type)),
      'suggestedCategoryId': serializer.toJson<int?>(suggestedCategoryId),
      'note': serializer.toJson<String?>(note),
      'valueDate': serializer.toJson<DateTime?>(valueDate),
      'currencyCode': serializer.toJson<String?>(currencyCode),
      'transactionId': serializer.toJson<int?>(transactionId),
    };
  }

  SmsInboxRow copyWith(
          {int? id,
          String? fingerprint,
          Value<String?> platformMessageId = const Value.absent(),
          String? sender,
          String? body,
          DateTime? receivedAt,
          DateTime? createdAt,
          SmsInboxStatus? status,
          Value<String?> bankId = const Value.absent(),
          Value<String?> templateId = const Value.absent(),
          Value<int?> amount = const Value.absent(),
          Value<TransactionType?> type = const Value.absent(),
          Value<int?> suggestedCategoryId = const Value.absent(),
          Value<String?> note = const Value.absent(),
          Value<DateTime?> valueDate = const Value.absent(),
          Value<String?> currencyCode = const Value.absent(),
          Value<int?> transactionId = const Value.absent()}) =>
      SmsInboxRow(
        id: id ?? this.id,
        fingerprint: fingerprint ?? this.fingerprint,
        platformMessageId: platformMessageId.present
            ? platformMessageId.value
            : this.platformMessageId,
        sender: sender ?? this.sender,
        body: body ?? this.body,
        receivedAt: receivedAt ?? this.receivedAt,
        createdAt: createdAt ?? this.createdAt,
        status: status ?? this.status,
        bankId: bankId.present ? bankId.value : this.bankId,
        templateId: templateId.present ? templateId.value : this.templateId,
        amount: amount.present ? amount.value : this.amount,
        type: type.present ? type.value : this.type,
        suggestedCategoryId: suggestedCategoryId.present
            ? suggestedCategoryId.value
            : this.suggestedCategoryId,
        note: note.present ? note.value : this.note,
        valueDate: valueDate.present ? valueDate.value : this.valueDate,
        currencyCode:
            currencyCode.present ? currencyCode.value : this.currencyCode,
        transactionId:
            transactionId.present ? transactionId.value : this.transactionId,
      );
  SmsInboxRow copyWithCompanion(SmsInboxRowsCompanion data) {
    return SmsInboxRow(
      id: data.id.present ? data.id.value : this.id,
      fingerprint:
          data.fingerprint.present ? data.fingerprint.value : this.fingerprint,
      platformMessageId: data.platformMessageId.present
          ? data.platformMessageId.value
          : this.platformMessageId,
      sender: data.sender.present ? data.sender.value : this.sender,
      body: data.body.present ? data.body.value : this.body,
      receivedAt:
          data.receivedAt.present ? data.receivedAt.value : this.receivedAt,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      status: data.status.present ? data.status.value : this.status,
      bankId: data.bankId.present ? data.bankId.value : this.bankId,
      templateId:
          data.templateId.present ? data.templateId.value : this.templateId,
      amount: data.amount.present ? data.amount.value : this.amount,
      type: data.type.present ? data.type.value : this.type,
      suggestedCategoryId: data.suggestedCategoryId.present
          ? data.suggestedCategoryId.value
          : this.suggestedCategoryId,
      note: data.note.present ? data.note.value : this.note,
      valueDate: data.valueDate.present ? data.valueDate.value : this.valueDate,
      currencyCode: data.currencyCode.present
          ? data.currencyCode.value
          : this.currencyCode,
      transactionId: data.transactionId.present
          ? data.transactionId.value
          : this.transactionId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SmsInboxRow(')
          ..write('id: $id, ')
          ..write('fingerprint: $fingerprint, ')
          ..write('platformMessageId: $platformMessageId, ')
          ..write('sender: $sender, ')
          ..write('body: $body, ')
          ..write('receivedAt: $receivedAt, ')
          ..write('createdAt: $createdAt, ')
          ..write('status: $status, ')
          ..write('bankId: $bankId, ')
          ..write('templateId: $templateId, ')
          ..write('amount: $amount, ')
          ..write('type: $type, ')
          ..write('suggestedCategoryId: $suggestedCategoryId, ')
          ..write('note: $note, ')
          ..write('valueDate: $valueDate, ')
          ..write('currencyCode: $currencyCode, ')
          ..write('transactionId: $transactionId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id,
      fingerprint,
      platformMessageId,
      sender,
      body,
      receivedAt,
      createdAt,
      status,
      bankId,
      templateId,
      amount,
      type,
      suggestedCategoryId,
      note,
      valueDate,
      currencyCode,
      transactionId);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SmsInboxRow &&
          other.id == this.id &&
          other.fingerprint == this.fingerprint &&
          other.platformMessageId == this.platformMessageId &&
          other.sender == this.sender &&
          other.body == this.body &&
          other.receivedAt == this.receivedAt &&
          other.createdAt == this.createdAt &&
          other.status == this.status &&
          other.bankId == this.bankId &&
          other.templateId == this.templateId &&
          other.amount == this.amount &&
          other.type == this.type &&
          other.suggestedCategoryId == this.suggestedCategoryId &&
          other.note == this.note &&
          other.valueDate == this.valueDate &&
          other.currencyCode == this.currencyCode &&
          other.transactionId == this.transactionId);
}

class SmsInboxRowsCompanion extends UpdateCompanion<SmsInboxRow> {
  final Value<int> id;
  final Value<String> fingerprint;
  final Value<String?> platformMessageId;
  final Value<String> sender;
  final Value<String> body;
  final Value<DateTime> receivedAt;
  final Value<DateTime> createdAt;
  final Value<SmsInboxStatus> status;
  final Value<String?> bankId;
  final Value<String?> templateId;
  final Value<int?> amount;
  final Value<TransactionType?> type;
  final Value<int?> suggestedCategoryId;
  final Value<String?> note;
  final Value<DateTime?> valueDate;
  final Value<String?> currencyCode;
  final Value<int?> transactionId;
  const SmsInboxRowsCompanion({
    this.id = const Value.absent(),
    this.fingerprint = const Value.absent(),
    this.platformMessageId = const Value.absent(),
    this.sender = const Value.absent(),
    this.body = const Value.absent(),
    this.receivedAt = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.status = const Value.absent(),
    this.bankId = const Value.absent(),
    this.templateId = const Value.absent(),
    this.amount = const Value.absent(),
    this.type = const Value.absent(),
    this.suggestedCategoryId = const Value.absent(),
    this.note = const Value.absent(),
    this.valueDate = const Value.absent(),
    this.currencyCode = const Value.absent(),
    this.transactionId = const Value.absent(),
  });
  SmsInboxRowsCompanion.insert({
    this.id = const Value.absent(),
    required String fingerprint,
    this.platformMessageId = const Value.absent(),
    required String sender,
    required String body,
    required DateTime receivedAt,
    required DateTime createdAt,
    required SmsInboxStatus status,
    this.bankId = const Value.absent(),
    this.templateId = const Value.absent(),
    this.amount = const Value.absent(),
    this.type = const Value.absent(),
    this.suggestedCategoryId = const Value.absent(),
    this.note = const Value.absent(),
    this.valueDate = const Value.absent(),
    this.currencyCode = const Value.absent(),
    this.transactionId = const Value.absent(),
  })  : fingerprint = Value(fingerprint),
        sender = Value(sender),
        body = Value(body),
        receivedAt = Value(receivedAt),
        createdAt = Value(createdAt),
        status = Value(status);
  static Insertable<SmsInboxRow> custom({
    Expression<int>? id,
    Expression<String>? fingerprint,
    Expression<String>? platformMessageId,
    Expression<String>? sender,
    Expression<String>? body,
    Expression<DateTime>? receivedAt,
    Expression<DateTime>? createdAt,
    Expression<String>? status,
    Expression<String>? bankId,
    Expression<String>? templateId,
    Expression<int>? amount,
    Expression<String>? type,
    Expression<int>? suggestedCategoryId,
    Expression<String>? note,
    Expression<DateTime>? valueDate,
    Expression<String>? currencyCode,
    Expression<int>? transactionId,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (fingerprint != null) 'fingerprint': fingerprint,
      if (platformMessageId != null) 'platform_message_id': platformMessageId,
      if (sender != null) 'sender': sender,
      if (body != null) 'body': body,
      if (receivedAt != null) 'received_at': receivedAt,
      if (createdAt != null) 'created_at': createdAt,
      if (status != null) 'status': status,
      if (bankId != null) 'bank_id': bankId,
      if (templateId != null) 'template_id': templateId,
      if (amount != null) 'amount': amount,
      if (type != null) 'type': type,
      if (suggestedCategoryId != null)
        'suggested_category_id': suggestedCategoryId,
      if (note != null) 'note': note,
      if (valueDate != null) 'value_date': valueDate,
      if (currencyCode != null) 'currency_code': currencyCode,
      if (transactionId != null) 'transaction_id': transactionId,
    });
  }

  SmsInboxRowsCompanion copyWith(
      {Value<int>? id,
      Value<String>? fingerprint,
      Value<String?>? platformMessageId,
      Value<String>? sender,
      Value<String>? body,
      Value<DateTime>? receivedAt,
      Value<DateTime>? createdAt,
      Value<SmsInboxStatus>? status,
      Value<String?>? bankId,
      Value<String?>? templateId,
      Value<int?>? amount,
      Value<TransactionType?>? type,
      Value<int?>? suggestedCategoryId,
      Value<String?>? note,
      Value<DateTime?>? valueDate,
      Value<String?>? currencyCode,
      Value<int?>? transactionId}) {
    return SmsInboxRowsCompanion(
      id: id ?? this.id,
      fingerprint: fingerprint ?? this.fingerprint,
      platformMessageId: platformMessageId ?? this.platformMessageId,
      sender: sender ?? this.sender,
      body: body ?? this.body,
      receivedAt: receivedAt ?? this.receivedAt,
      createdAt: createdAt ?? this.createdAt,
      status: status ?? this.status,
      bankId: bankId ?? this.bankId,
      templateId: templateId ?? this.templateId,
      amount: amount ?? this.amount,
      type: type ?? this.type,
      suggestedCategoryId: suggestedCategoryId ?? this.suggestedCategoryId,
      note: note ?? this.note,
      valueDate: valueDate ?? this.valueDate,
      currencyCode: currencyCode ?? this.currencyCode,
      transactionId: transactionId ?? this.transactionId,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (fingerprint.present) {
      map['fingerprint'] = Variable<String>(fingerprint.value);
    }
    if (platformMessageId.present) {
      map['platform_message_id'] = Variable<String>(platformMessageId.value);
    }
    if (sender.present) {
      map['sender'] = Variable<String>(sender.value);
    }
    if (body.present) {
      map['body'] = Variable<String>(body.value);
    }
    if (receivedAt.present) {
      map['received_at'] = Variable<DateTime>(receivedAt.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(
          $SmsInboxRowsTable.$converterstatus.toSql(status.value));
    }
    if (bankId.present) {
      map['bank_id'] = Variable<String>(bankId.value);
    }
    if (templateId.present) {
      map['template_id'] = Variable<String>(templateId.value);
    }
    if (amount.present) {
      map['amount'] = Variable<int>(amount.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(
          $SmsInboxRowsTable.$convertertypen.toSql(type.value));
    }
    if (suggestedCategoryId.present) {
      map['suggested_category_id'] = Variable<int>(suggestedCategoryId.value);
    }
    if (note.present) {
      map['note'] = Variable<String>(note.value);
    }
    if (valueDate.present) {
      map['value_date'] = Variable<DateTime>(valueDate.value);
    }
    if (currencyCode.present) {
      map['currency_code'] = Variable<String>(currencyCode.value);
    }
    if (transactionId.present) {
      map['transaction_id'] = Variable<int>(transactionId.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SmsInboxRowsCompanion(')
          ..write('id: $id, ')
          ..write('fingerprint: $fingerprint, ')
          ..write('platformMessageId: $platformMessageId, ')
          ..write('sender: $sender, ')
          ..write('body: $body, ')
          ..write('receivedAt: $receivedAt, ')
          ..write('createdAt: $createdAt, ')
          ..write('status: $status, ')
          ..write('bankId: $bankId, ')
          ..write('templateId: $templateId, ')
          ..write('amount: $amount, ')
          ..write('type: $type, ')
          ..write('suggestedCategoryId: $suggestedCategoryId, ')
          ..write('note: $note, ')
          ..write('valueDate: $valueDate, ')
          ..write('currencyCode: $currencyCode, ')
          ..write('transactionId: $transactionId')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $CategoryRowsTable categoryRows = $CategoryRowsTable(this);
  late final $TransactionRowsTable transactionRows =
      $TransactionRowsTable(this);
  late final $SettingsRowsTable settingsRows = $SettingsRowsTable(this);
  late final $SmsInboxRowsTable smsInboxRows = $SmsInboxRowsTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities =>
      [categoryRows, transactionRows, settingsRows, smsInboxRows];
  @override
  StreamQueryUpdateRules get streamUpdateRules => const StreamQueryUpdateRules(
        [
          WritePropagation(
            on: TableUpdateQuery.onTableName('categories',
                limitUpdateKind: UpdateKind.delete),
            result: [
              TableUpdate('sms_inbox', kind: UpdateKind.update),
            ],
          ),
          WritePropagation(
            on: TableUpdateQuery.onTableName('transactions',
                limitUpdateKind: UpdateKind.delete),
            result: [
              TableUpdate('sms_inbox', kind: UpdateKind.update),
            ],
          ),
        ],
      );
}

typedef $$CategoryRowsTableCreateCompanionBuilder = CategoryRowsCompanion
    Function({
  Value<int> id,
  required String name,
  required TransactionType type,
  required int iconCodePoint,
  required int colorValue,
  Value<bool> isDefault,
  Value<bool> isFallback,
});
typedef $$CategoryRowsTableUpdateCompanionBuilder = CategoryRowsCompanion
    Function({
  Value<int> id,
  Value<String> name,
  Value<TransactionType> type,
  Value<int> iconCodePoint,
  Value<int> colorValue,
  Value<bool> isDefault,
  Value<bool> isFallback,
});

final class $$CategoryRowsTableReferences
    extends BaseReferences<_$AppDatabase, $CategoryRowsTable, CategoryRow> {
  $$CategoryRowsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$TransactionRowsTable, List<TransactionRow>>
      _transactionRowsRefsTable(_$AppDatabase db) =>
          MultiTypedResultKey.fromTable(db.transactionRows,
              aliasName: $_aliasNameGenerator(
                  db.categoryRows.id, db.transactionRows.categoryId));

  $$TransactionRowsTableProcessedTableManager get transactionRowsRefs {
    final manager =
        $$TransactionRowsTableTableManager($_db, $_db.transactionRows)
            .filter((f) => f.categoryId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache =
        $_typedResult.readTableOrNull(_transactionRowsRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }

  static MultiTypedResultKey<$SmsInboxRowsTable, List<SmsInboxRow>>
      _smsInboxRowsRefsTable(_$AppDatabase db) =>
          MultiTypedResultKey.fromTable(db.smsInboxRows,
              aliasName: $_aliasNameGenerator(
                  db.categoryRows.id, db.smsInboxRows.suggestedCategoryId));

  $$SmsInboxRowsTableProcessedTableManager get smsInboxRowsRefs {
    final manager = $$SmsInboxRowsTableTableManager($_db, $_db.smsInboxRows)
        .filter((f) =>
            f.suggestedCategoryId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_smsInboxRowsRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }
}

class $$CategoryRowsTableFilterComposer
    extends Composer<_$AppDatabase, $CategoryRowsTable> {
  $$CategoryRowsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnWithTypeConverterFilters<TransactionType, TransactionType, String>
      get type => $composableBuilder(
          column: $table.type,
          builder: (column) => ColumnWithTypeConverterFilters(column));

  ColumnFilters<int> get iconCodePoint => $composableBuilder(
      column: $table.iconCodePoint, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get colorValue => $composableBuilder(
      column: $table.colorValue, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isDefault => $composableBuilder(
      column: $table.isDefault, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isFallback => $composableBuilder(
      column: $table.isFallback, builder: (column) => ColumnFilters(column));

  Expression<bool> transactionRowsRefs(
      Expression<bool> Function($$TransactionRowsTableFilterComposer f) f) {
    final $$TransactionRowsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.transactionRows,
        getReferencedColumn: (t) => t.categoryId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$TransactionRowsTableFilterComposer(
              $db: $db,
              $table: $db.transactionRows,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<bool> smsInboxRowsRefs(
      Expression<bool> Function($$SmsInboxRowsTableFilterComposer f) f) {
    final $$SmsInboxRowsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.smsInboxRows,
        getReferencedColumn: (t) => t.suggestedCategoryId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$SmsInboxRowsTableFilterComposer(
              $db: $db,
              $table: $db.smsInboxRows,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$CategoryRowsTableOrderingComposer
    extends Composer<_$AppDatabase, $CategoryRowsTable> {
  $$CategoryRowsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get type => $composableBuilder(
      column: $table.type, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get iconCodePoint => $composableBuilder(
      column: $table.iconCodePoint,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get colorValue => $composableBuilder(
      column: $table.colorValue, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isDefault => $composableBuilder(
      column: $table.isDefault, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isFallback => $composableBuilder(
      column: $table.isFallback, builder: (column) => ColumnOrderings(column));
}

class $$CategoryRowsTableAnnotationComposer
    extends Composer<_$AppDatabase, $CategoryRowsTable> {
  $$CategoryRowsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumnWithTypeConverter<TransactionType, String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<int> get iconCodePoint => $composableBuilder(
      column: $table.iconCodePoint, builder: (column) => column);

  GeneratedColumn<int> get colorValue => $composableBuilder(
      column: $table.colorValue, builder: (column) => column);

  GeneratedColumn<bool> get isDefault =>
      $composableBuilder(column: $table.isDefault, builder: (column) => column);

  GeneratedColumn<bool> get isFallback => $composableBuilder(
      column: $table.isFallback, builder: (column) => column);

  Expression<T> transactionRowsRefs<T extends Object>(
      Expression<T> Function($$TransactionRowsTableAnnotationComposer a) f) {
    final $$TransactionRowsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.transactionRows,
        getReferencedColumn: (t) => t.categoryId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$TransactionRowsTableAnnotationComposer(
              $db: $db,
              $table: $db.transactionRows,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<T> smsInboxRowsRefs<T extends Object>(
      Expression<T> Function($$SmsInboxRowsTableAnnotationComposer a) f) {
    final $$SmsInboxRowsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.smsInboxRows,
        getReferencedColumn: (t) => t.suggestedCategoryId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$SmsInboxRowsTableAnnotationComposer(
              $db: $db,
              $table: $db.smsInboxRows,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$CategoryRowsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $CategoryRowsTable,
    CategoryRow,
    $$CategoryRowsTableFilterComposer,
    $$CategoryRowsTableOrderingComposer,
    $$CategoryRowsTableAnnotationComposer,
    $$CategoryRowsTableCreateCompanionBuilder,
    $$CategoryRowsTableUpdateCompanionBuilder,
    (CategoryRow, $$CategoryRowsTableReferences),
    CategoryRow,
    PrefetchHooks Function({bool transactionRowsRefs, bool smsInboxRowsRefs})> {
  $$CategoryRowsTableTableManager(_$AppDatabase db, $CategoryRowsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CategoryRowsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CategoryRowsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CategoryRowsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<TransactionType> type = const Value.absent(),
            Value<int> iconCodePoint = const Value.absent(),
            Value<int> colorValue = const Value.absent(),
            Value<bool> isDefault = const Value.absent(),
            Value<bool> isFallback = const Value.absent(),
          }) =>
              CategoryRowsCompanion(
            id: id,
            name: name,
            type: type,
            iconCodePoint: iconCodePoint,
            colorValue: colorValue,
            isDefault: isDefault,
            isFallback: isFallback,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String name,
            required TransactionType type,
            required int iconCodePoint,
            required int colorValue,
            Value<bool> isDefault = const Value.absent(),
            Value<bool> isFallback = const Value.absent(),
          }) =>
              CategoryRowsCompanion.insert(
            id: id,
            name: name,
            type: type,
            iconCodePoint: iconCodePoint,
            colorValue: colorValue,
            isDefault: isDefault,
            isFallback: isFallback,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$CategoryRowsTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: (
              {transactionRowsRefs = false, smsInboxRowsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (transactionRowsRefs) db.transactionRows,
                if (smsInboxRowsRefs) db.smsInboxRows
              ],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (transactionRowsRefs)
                    await $_getPrefetchedData<CategoryRow, $CategoryRowsTable,
                            TransactionRow>(
                        currentTable: table,
                        referencedTable: $$CategoryRowsTableReferences
                            ._transactionRowsRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$CategoryRowsTableReferences(db, table, p0)
                                .transactionRowsRefs,
                        referencedItemsForCurrentItem:
                            (item, referencedItems) => referencedItems
                                .where((e) => e.categoryId == item.id),
                        typedResults: items),
                  if (smsInboxRowsRefs)
                    await $_getPrefetchedData<CategoryRow, $CategoryRowsTable,
                            SmsInboxRow>(
                        currentTable: table,
                        referencedTable: $$CategoryRowsTableReferences
                            ._smsInboxRowsRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$CategoryRowsTableReferences(db, table, p0)
                                .smsInboxRowsRefs,
                        referencedItemsForCurrentItem:
                            (item, referencedItems) => referencedItems
                                .where((e) => e.suggestedCategoryId == item.id),
                        typedResults: items)
                ];
              },
            );
          },
        ));
}

typedef $$CategoryRowsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $CategoryRowsTable,
    CategoryRow,
    $$CategoryRowsTableFilterComposer,
    $$CategoryRowsTableOrderingComposer,
    $$CategoryRowsTableAnnotationComposer,
    $$CategoryRowsTableCreateCompanionBuilder,
    $$CategoryRowsTableUpdateCompanionBuilder,
    (CategoryRow, $$CategoryRowsTableReferences),
    CategoryRow,
    PrefetchHooks Function({bool transactionRowsRefs, bool smsInboxRowsRefs})>;
typedef $$TransactionRowsTableCreateCompanionBuilder = TransactionRowsCompanion
    Function({
  Value<int> id,
  required int amount,
  required TransactionType type,
  required int categoryId,
  Value<String?> note,
  required DateTime date,
  required DateTime createdAt,
  Value<TransactionSource> source,
});
typedef $$TransactionRowsTableUpdateCompanionBuilder = TransactionRowsCompanion
    Function({
  Value<int> id,
  Value<int> amount,
  Value<TransactionType> type,
  Value<int> categoryId,
  Value<String?> note,
  Value<DateTime> date,
  Value<DateTime> createdAt,
  Value<TransactionSource> source,
});

final class $$TransactionRowsTableReferences extends BaseReferences<
    _$AppDatabase, $TransactionRowsTable, TransactionRow> {
  $$TransactionRowsTableReferences(
      super.$_db, super.$_table, super.$_typedResult);

  static $CategoryRowsTable _categoryIdTable(_$AppDatabase db) =>
      db.categoryRows.createAlias($_aliasNameGenerator(
          db.transactionRows.categoryId, db.categoryRows.id));

  $$CategoryRowsTableProcessedTableManager get categoryId {
    final $_column = $_itemColumn<int>('category_id')!;

    final manager = $$CategoryRowsTableTableManager($_db, $_db.categoryRows)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_categoryIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }

  static MultiTypedResultKey<$SmsInboxRowsTable, List<SmsInboxRow>>
      _smsInboxRowsRefsTable(_$AppDatabase db) =>
          MultiTypedResultKey.fromTable(db.smsInboxRows,
              aliasName: $_aliasNameGenerator(
                  db.transactionRows.id, db.smsInboxRows.transactionId));

  $$SmsInboxRowsTableProcessedTableManager get smsInboxRowsRefs {
    final manager = $$SmsInboxRowsTableTableManager($_db, $_db.smsInboxRows)
        .filter((f) => f.transactionId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_smsInboxRowsRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }
}

class $$TransactionRowsTableFilterComposer
    extends Composer<_$AppDatabase, $TransactionRowsTable> {
  $$TransactionRowsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get amount => $composableBuilder(
      column: $table.amount, builder: (column) => ColumnFilters(column));

  ColumnWithTypeConverterFilters<TransactionType, TransactionType, String>
      get type => $composableBuilder(
          column: $table.type,
          builder: (column) => ColumnWithTypeConverterFilters(column));

  ColumnFilters<String> get note => $composableBuilder(
      column: $table.note, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get date => $composableBuilder(
      column: $table.date, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnWithTypeConverterFilters<TransactionSource, TransactionSource, String>
      get source => $composableBuilder(
          column: $table.source,
          builder: (column) => ColumnWithTypeConverterFilters(column));

  $$CategoryRowsTableFilterComposer get categoryId {
    final $$CategoryRowsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.categoryId,
        referencedTable: $db.categoryRows,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$CategoryRowsTableFilterComposer(
              $db: $db,
              $table: $db.categoryRows,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  Expression<bool> smsInboxRowsRefs(
      Expression<bool> Function($$SmsInboxRowsTableFilterComposer f) f) {
    final $$SmsInboxRowsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.smsInboxRows,
        getReferencedColumn: (t) => t.transactionId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$SmsInboxRowsTableFilterComposer(
              $db: $db,
              $table: $db.smsInboxRows,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$TransactionRowsTableOrderingComposer
    extends Composer<_$AppDatabase, $TransactionRowsTable> {
  $$TransactionRowsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get amount => $composableBuilder(
      column: $table.amount, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get type => $composableBuilder(
      column: $table.type, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get note => $composableBuilder(
      column: $table.note, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get date => $composableBuilder(
      column: $table.date, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get source => $composableBuilder(
      column: $table.source, builder: (column) => ColumnOrderings(column));

  $$CategoryRowsTableOrderingComposer get categoryId {
    final $$CategoryRowsTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.categoryId,
        referencedTable: $db.categoryRows,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$CategoryRowsTableOrderingComposer(
              $db: $db,
              $table: $db.categoryRows,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$TransactionRowsTableAnnotationComposer
    extends Composer<_$AppDatabase, $TransactionRowsTable> {
  $$TransactionRowsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get amount =>
      $composableBuilder(column: $table.amount, builder: (column) => column);

  GeneratedColumnWithTypeConverter<TransactionType, String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<String> get note =>
      $composableBuilder(column: $table.note, builder: (column) => column);

  GeneratedColumn<DateTime> get date =>
      $composableBuilder(column: $table.date, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumnWithTypeConverter<TransactionSource, String> get source =>
      $composableBuilder(column: $table.source, builder: (column) => column);

  $$CategoryRowsTableAnnotationComposer get categoryId {
    final $$CategoryRowsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.categoryId,
        referencedTable: $db.categoryRows,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$CategoryRowsTableAnnotationComposer(
              $db: $db,
              $table: $db.categoryRows,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  Expression<T> smsInboxRowsRefs<T extends Object>(
      Expression<T> Function($$SmsInboxRowsTableAnnotationComposer a) f) {
    final $$SmsInboxRowsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.smsInboxRows,
        getReferencedColumn: (t) => t.transactionId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$SmsInboxRowsTableAnnotationComposer(
              $db: $db,
              $table: $db.smsInboxRows,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$TransactionRowsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $TransactionRowsTable,
    TransactionRow,
    $$TransactionRowsTableFilterComposer,
    $$TransactionRowsTableOrderingComposer,
    $$TransactionRowsTableAnnotationComposer,
    $$TransactionRowsTableCreateCompanionBuilder,
    $$TransactionRowsTableUpdateCompanionBuilder,
    (TransactionRow, $$TransactionRowsTableReferences),
    TransactionRow,
    PrefetchHooks Function({bool categoryId, bool smsInboxRowsRefs})> {
  $$TransactionRowsTableTableManager(
      _$AppDatabase db, $TransactionRowsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TransactionRowsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TransactionRowsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TransactionRowsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int> amount = const Value.absent(),
            Value<TransactionType> type = const Value.absent(),
            Value<int> categoryId = const Value.absent(),
            Value<String?> note = const Value.absent(),
            Value<DateTime> date = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<TransactionSource> source = const Value.absent(),
          }) =>
              TransactionRowsCompanion(
            id: id,
            amount: amount,
            type: type,
            categoryId: categoryId,
            note: note,
            date: date,
            createdAt: createdAt,
            source: source,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required int amount,
            required TransactionType type,
            required int categoryId,
            Value<String?> note = const Value.absent(),
            required DateTime date,
            required DateTime createdAt,
            Value<TransactionSource> source = const Value.absent(),
          }) =>
              TransactionRowsCompanion.insert(
            id: id,
            amount: amount,
            type: type,
            categoryId: categoryId,
            note: note,
            date: date,
            createdAt: createdAt,
            source: source,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$TransactionRowsTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: (
              {categoryId = false, smsInboxRowsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (smsInboxRowsRefs) db.smsInboxRows],
              addJoins: <
                  T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic>>(state) {
                if (categoryId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.categoryId,
                    referencedTable:
                        $$TransactionRowsTableReferences._categoryIdTable(db),
                    referencedColumn: $$TransactionRowsTableReferences
                        ._categoryIdTable(db)
                        .id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [
                  if (smsInboxRowsRefs)
                    await $_getPrefetchedData<TransactionRow,
                            $TransactionRowsTable, SmsInboxRow>(
                        currentTable: table,
                        referencedTable: $$TransactionRowsTableReferences
                            ._smsInboxRowsRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$TransactionRowsTableReferences(db, table, p0)
                                .smsInboxRowsRefs,
                        referencedItemsForCurrentItem:
                            (item, referencedItems) => referencedItems
                                .where((e) => e.transactionId == item.id),
                        typedResults: items)
                ];
              },
            );
          },
        ));
}

typedef $$TransactionRowsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $TransactionRowsTable,
    TransactionRow,
    $$TransactionRowsTableFilterComposer,
    $$TransactionRowsTableOrderingComposer,
    $$TransactionRowsTableAnnotationComposer,
    $$TransactionRowsTableCreateCompanionBuilder,
    $$TransactionRowsTableUpdateCompanionBuilder,
    (TransactionRow, $$TransactionRowsTableReferences),
    TransactionRow,
    PrefetchHooks Function({bool categoryId, bool smsInboxRowsRefs})>;
typedef $$SettingsRowsTableCreateCompanionBuilder = SettingsRowsCompanion
    Function({
  Value<int> id,
  Value<String> currencyCode,
  Value<DateTime?> smsLastScanAt,
  Value<AppThemeMode> themeMode,
  Value<TransactionType> defaultEntryType,
  Value<AppLocale> localeCode,
});
typedef $$SettingsRowsTableUpdateCompanionBuilder = SettingsRowsCompanion
    Function({
  Value<int> id,
  Value<String> currencyCode,
  Value<DateTime?> smsLastScanAt,
  Value<AppThemeMode> themeMode,
  Value<TransactionType> defaultEntryType,
  Value<AppLocale> localeCode,
});

class $$SettingsRowsTableFilterComposer
    extends Composer<_$AppDatabase, $SettingsRowsTable> {
  $$SettingsRowsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get currencyCode => $composableBuilder(
      column: $table.currencyCode, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get smsLastScanAt => $composableBuilder(
      column: $table.smsLastScanAt, builder: (column) => ColumnFilters(column));

  ColumnWithTypeConverterFilters<AppThemeMode, AppThemeMode, String>
      get themeMode => $composableBuilder(
          column: $table.themeMode,
          builder: (column) => ColumnWithTypeConverterFilters(column));

  ColumnWithTypeConverterFilters<TransactionType, TransactionType, String>
      get defaultEntryType => $composableBuilder(
          column: $table.defaultEntryType,
          builder: (column) => ColumnWithTypeConverterFilters(column));

  ColumnWithTypeConverterFilters<AppLocale, AppLocale, String> get localeCode =>
      $composableBuilder(
          column: $table.localeCode,
          builder: (column) => ColumnWithTypeConverterFilters(column));
}

class $$SettingsRowsTableOrderingComposer
    extends Composer<_$AppDatabase, $SettingsRowsTable> {
  $$SettingsRowsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get currencyCode => $composableBuilder(
      column: $table.currencyCode,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get smsLastScanAt => $composableBuilder(
      column: $table.smsLastScanAt,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get themeMode => $composableBuilder(
      column: $table.themeMode, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get defaultEntryType => $composableBuilder(
      column: $table.defaultEntryType,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get localeCode => $composableBuilder(
      column: $table.localeCode, builder: (column) => ColumnOrderings(column));
}

class $$SettingsRowsTableAnnotationComposer
    extends Composer<_$AppDatabase, $SettingsRowsTable> {
  $$SettingsRowsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get currencyCode => $composableBuilder(
      column: $table.currencyCode, builder: (column) => column);

  GeneratedColumn<DateTime> get smsLastScanAt => $composableBuilder(
      column: $table.smsLastScanAt, builder: (column) => column);

  GeneratedColumnWithTypeConverter<AppThemeMode, String> get themeMode =>
      $composableBuilder(column: $table.themeMode, builder: (column) => column);

  GeneratedColumnWithTypeConverter<TransactionType, String>
      get defaultEntryType => $composableBuilder(
          column: $table.defaultEntryType, builder: (column) => column);

  GeneratedColumnWithTypeConverter<AppLocale, String> get localeCode =>
      $composableBuilder(
          column: $table.localeCode, builder: (column) => column);
}

class $$SettingsRowsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $SettingsRowsTable,
    SettingsRow,
    $$SettingsRowsTableFilterComposer,
    $$SettingsRowsTableOrderingComposer,
    $$SettingsRowsTableAnnotationComposer,
    $$SettingsRowsTableCreateCompanionBuilder,
    $$SettingsRowsTableUpdateCompanionBuilder,
    (
      SettingsRow,
      BaseReferences<_$AppDatabase, $SettingsRowsTable, SettingsRow>
    ),
    SettingsRow,
    PrefetchHooks Function()> {
  $$SettingsRowsTableTableManager(_$AppDatabase db, $SettingsRowsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SettingsRowsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SettingsRowsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SettingsRowsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> currencyCode = const Value.absent(),
            Value<DateTime?> smsLastScanAt = const Value.absent(),
            Value<AppThemeMode> themeMode = const Value.absent(),
            Value<TransactionType> defaultEntryType = const Value.absent(),
            Value<AppLocale> localeCode = const Value.absent(),
          }) =>
              SettingsRowsCompanion(
            id: id,
            currencyCode: currencyCode,
            smsLastScanAt: smsLastScanAt,
            themeMode: themeMode,
            defaultEntryType: defaultEntryType,
            localeCode: localeCode,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> currencyCode = const Value.absent(),
            Value<DateTime?> smsLastScanAt = const Value.absent(),
            Value<AppThemeMode> themeMode = const Value.absent(),
            Value<TransactionType> defaultEntryType = const Value.absent(),
            Value<AppLocale> localeCode = const Value.absent(),
          }) =>
              SettingsRowsCompanion.insert(
            id: id,
            currencyCode: currencyCode,
            smsLastScanAt: smsLastScanAt,
            themeMode: themeMode,
            defaultEntryType: defaultEntryType,
            localeCode: localeCode,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$SettingsRowsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $SettingsRowsTable,
    SettingsRow,
    $$SettingsRowsTableFilterComposer,
    $$SettingsRowsTableOrderingComposer,
    $$SettingsRowsTableAnnotationComposer,
    $$SettingsRowsTableCreateCompanionBuilder,
    $$SettingsRowsTableUpdateCompanionBuilder,
    (
      SettingsRow,
      BaseReferences<_$AppDatabase, $SettingsRowsTable, SettingsRow>
    ),
    SettingsRow,
    PrefetchHooks Function()>;
typedef $$SmsInboxRowsTableCreateCompanionBuilder = SmsInboxRowsCompanion
    Function({
  Value<int> id,
  required String fingerprint,
  Value<String?> platformMessageId,
  required String sender,
  required String body,
  required DateTime receivedAt,
  required DateTime createdAt,
  required SmsInboxStatus status,
  Value<String?> bankId,
  Value<String?> templateId,
  Value<int?> amount,
  Value<TransactionType?> type,
  Value<int?> suggestedCategoryId,
  Value<String?> note,
  Value<DateTime?> valueDate,
  Value<String?> currencyCode,
  Value<int?> transactionId,
});
typedef $$SmsInboxRowsTableUpdateCompanionBuilder = SmsInboxRowsCompanion
    Function({
  Value<int> id,
  Value<String> fingerprint,
  Value<String?> platformMessageId,
  Value<String> sender,
  Value<String> body,
  Value<DateTime> receivedAt,
  Value<DateTime> createdAt,
  Value<SmsInboxStatus> status,
  Value<String?> bankId,
  Value<String?> templateId,
  Value<int?> amount,
  Value<TransactionType?> type,
  Value<int?> suggestedCategoryId,
  Value<String?> note,
  Value<DateTime?> valueDate,
  Value<String?> currencyCode,
  Value<int?> transactionId,
});

final class $$SmsInboxRowsTableReferences
    extends BaseReferences<_$AppDatabase, $SmsInboxRowsTable, SmsInboxRow> {
  $$SmsInboxRowsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $CategoryRowsTable _suggestedCategoryIdTable(_$AppDatabase db) =>
      db.categoryRows.createAlias($_aliasNameGenerator(
          db.smsInboxRows.suggestedCategoryId, db.categoryRows.id));

  $$CategoryRowsTableProcessedTableManager? get suggestedCategoryId {
    final $_column = $_itemColumn<int>('suggested_category_id');
    if ($_column == null) return null;
    final manager = $$CategoryRowsTableTableManager($_db, $_db.categoryRows)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_suggestedCategoryIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }

  static $TransactionRowsTable _transactionIdTable(_$AppDatabase db) =>
      db.transactionRows.createAlias($_aliasNameGenerator(
          db.smsInboxRows.transactionId, db.transactionRows.id));

  $$TransactionRowsTableProcessedTableManager? get transactionId {
    final $_column = $_itemColumn<int>('transaction_id');
    if ($_column == null) return null;
    final manager =
        $$TransactionRowsTableTableManager($_db, $_db.transactionRows)
            .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_transactionIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }
}

class $$SmsInboxRowsTableFilterComposer
    extends Composer<_$AppDatabase, $SmsInboxRowsTable> {
  $$SmsInboxRowsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get fingerprint => $composableBuilder(
      column: $table.fingerprint, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get platformMessageId => $composableBuilder(
      column: $table.platformMessageId,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get sender => $composableBuilder(
      column: $table.sender, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get body => $composableBuilder(
      column: $table.body, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get receivedAt => $composableBuilder(
      column: $table.receivedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnWithTypeConverterFilters<SmsInboxStatus, SmsInboxStatus, String>
      get status => $composableBuilder(
          column: $table.status,
          builder: (column) => ColumnWithTypeConverterFilters(column));

  ColumnFilters<String> get bankId => $composableBuilder(
      column: $table.bankId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get templateId => $composableBuilder(
      column: $table.templateId, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get amount => $composableBuilder(
      column: $table.amount, builder: (column) => ColumnFilters(column));

  ColumnWithTypeConverterFilters<TransactionType?, TransactionType, String>
      get type => $composableBuilder(
          column: $table.type,
          builder: (column) => ColumnWithTypeConverterFilters(column));

  ColumnFilters<String> get note => $composableBuilder(
      column: $table.note, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get valueDate => $composableBuilder(
      column: $table.valueDate, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get currencyCode => $composableBuilder(
      column: $table.currencyCode, builder: (column) => ColumnFilters(column));

  $$CategoryRowsTableFilterComposer get suggestedCategoryId {
    final $$CategoryRowsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.suggestedCategoryId,
        referencedTable: $db.categoryRows,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$CategoryRowsTableFilterComposer(
              $db: $db,
              $table: $db.categoryRows,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$TransactionRowsTableFilterComposer get transactionId {
    final $$TransactionRowsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.transactionId,
        referencedTable: $db.transactionRows,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$TransactionRowsTableFilterComposer(
              $db: $db,
              $table: $db.transactionRows,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$SmsInboxRowsTableOrderingComposer
    extends Composer<_$AppDatabase, $SmsInboxRowsTable> {
  $$SmsInboxRowsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get fingerprint => $composableBuilder(
      column: $table.fingerprint, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get platformMessageId => $composableBuilder(
      column: $table.platformMessageId,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get sender => $composableBuilder(
      column: $table.sender, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get body => $composableBuilder(
      column: $table.body, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get receivedAt => $composableBuilder(
      column: $table.receivedAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get bankId => $composableBuilder(
      column: $table.bankId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get templateId => $composableBuilder(
      column: $table.templateId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get amount => $composableBuilder(
      column: $table.amount, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get type => $composableBuilder(
      column: $table.type, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get note => $composableBuilder(
      column: $table.note, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get valueDate => $composableBuilder(
      column: $table.valueDate, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get currencyCode => $composableBuilder(
      column: $table.currencyCode,
      builder: (column) => ColumnOrderings(column));

  $$CategoryRowsTableOrderingComposer get suggestedCategoryId {
    final $$CategoryRowsTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.suggestedCategoryId,
        referencedTable: $db.categoryRows,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$CategoryRowsTableOrderingComposer(
              $db: $db,
              $table: $db.categoryRows,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$TransactionRowsTableOrderingComposer get transactionId {
    final $$TransactionRowsTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.transactionId,
        referencedTable: $db.transactionRows,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$TransactionRowsTableOrderingComposer(
              $db: $db,
              $table: $db.transactionRows,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$SmsInboxRowsTableAnnotationComposer
    extends Composer<_$AppDatabase, $SmsInboxRowsTable> {
  $$SmsInboxRowsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get fingerprint => $composableBuilder(
      column: $table.fingerprint, builder: (column) => column);

  GeneratedColumn<String> get platformMessageId => $composableBuilder(
      column: $table.platformMessageId, builder: (column) => column);

  GeneratedColumn<String> get sender =>
      $composableBuilder(column: $table.sender, builder: (column) => column);

  GeneratedColumn<String> get body =>
      $composableBuilder(column: $table.body, builder: (column) => column);

  GeneratedColumn<DateTime> get receivedAt => $composableBuilder(
      column: $table.receivedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumnWithTypeConverter<SmsInboxStatus, String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<String> get bankId =>
      $composableBuilder(column: $table.bankId, builder: (column) => column);

  GeneratedColumn<String> get templateId => $composableBuilder(
      column: $table.templateId, builder: (column) => column);

  GeneratedColumn<int> get amount =>
      $composableBuilder(column: $table.amount, builder: (column) => column);

  GeneratedColumnWithTypeConverter<TransactionType?, String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<String> get note =>
      $composableBuilder(column: $table.note, builder: (column) => column);

  GeneratedColumn<DateTime> get valueDate =>
      $composableBuilder(column: $table.valueDate, builder: (column) => column);

  GeneratedColumn<String> get currencyCode => $composableBuilder(
      column: $table.currencyCode, builder: (column) => column);

  $$CategoryRowsTableAnnotationComposer get suggestedCategoryId {
    final $$CategoryRowsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.suggestedCategoryId,
        referencedTable: $db.categoryRows,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$CategoryRowsTableAnnotationComposer(
              $db: $db,
              $table: $db.categoryRows,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$TransactionRowsTableAnnotationComposer get transactionId {
    final $$TransactionRowsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.transactionId,
        referencedTable: $db.transactionRows,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$TransactionRowsTableAnnotationComposer(
              $db: $db,
              $table: $db.transactionRows,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$SmsInboxRowsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $SmsInboxRowsTable,
    SmsInboxRow,
    $$SmsInboxRowsTableFilterComposer,
    $$SmsInboxRowsTableOrderingComposer,
    $$SmsInboxRowsTableAnnotationComposer,
    $$SmsInboxRowsTableCreateCompanionBuilder,
    $$SmsInboxRowsTableUpdateCompanionBuilder,
    (SmsInboxRow, $$SmsInboxRowsTableReferences),
    SmsInboxRow,
    PrefetchHooks Function({bool suggestedCategoryId, bool transactionId})> {
  $$SmsInboxRowsTableTableManager(_$AppDatabase db, $SmsInboxRowsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SmsInboxRowsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SmsInboxRowsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SmsInboxRowsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> fingerprint = const Value.absent(),
            Value<String?> platformMessageId = const Value.absent(),
            Value<String> sender = const Value.absent(),
            Value<String> body = const Value.absent(),
            Value<DateTime> receivedAt = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<SmsInboxStatus> status = const Value.absent(),
            Value<String?> bankId = const Value.absent(),
            Value<String?> templateId = const Value.absent(),
            Value<int?> amount = const Value.absent(),
            Value<TransactionType?> type = const Value.absent(),
            Value<int?> suggestedCategoryId = const Value.absent(),
            Value<String?> note = const Value.absent(),
            Value<DateTime?> valueDate = const Value.absent(),
            Value<String?> currencyCode = const Value.absent(),
            Value<int?> transactionId = const Value.absent(),
          }) =>
              SmsInboxRowsCompanion(
            id: id,
            fingerprint: fingerprint,
            platformMessageId: platformMessageId,
            sender: sender,
            body: body,
            receivedAt: receivedAt,
            createdAt: createdAt,
            status: status,
            bankId: bankId,
            templateId: templateId,
            amount: amount,
            type: type,
            suggestedCategoryId: suggestedCategoryId,
            note: note,
            valueDate: valueDate,
            currencyCode: currencyCode,
            transactionId: transactionId,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String fingerprint,
            Value<String?> platformMessageId = const Value.absent(),
            required String sender,
            required String body,
            required DateTime receivedAt,
            required DateTime createdAt,
            required SmsInboxStatus status,
            Value<String?> bankId = const Value.absent(),
            Value<String?> templateId = const Value.absent(),
            Value<int?> amount = const Value.absent(),
            Value<TransactionType?> type = const Value.absent(),
            Value<int?> suggestedCategoryId = const Value.absent(),
            Value<String?> note = const Value.absent(),
            Value<DateTime?> valueDate = const Value.absent(),
            Value<String?> currencyCode = const Value.absent(),
            Value<int?> transactionId = const Value.absent(),
          }) =>
              SmsInboxRowsCompanion.insert(
            id: id,
            fingerprint: fingerprint,
            platformMessageId: platformMessageId,
            sender: sender,
            body: body,
            receivedAt: receivedAt,
            createdAt: createdAt,
            status: status,
            bankId: bankId,
            templateId: templateId,
            amount: amount,
            type: type,
            suggestedCategoryId: suggestedCategoryId,
            note: note,
            valueDate: valueDate,
            currencyCode: currencyCode,
            transactionId: transactionId,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$SmsInboxRowsTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: (
              {suggestedCategoryId = false, transactionId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
                  T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic>>(state) {
                if (suggestedCategoryId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.suggestedCategoryId,
                    referencedTable: $$SmsInboxRowsTableReferences
                        ._suggestedCategoryIdTable(db),
                    referencedColumn: $$SmsInboxRowsTableReferences
                        ._suggestedCategoryIdTable(db)
                        .id,
                  ) as T;
                }
                if (transactionId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.transactionId,
                    referencedTable:
                        $$SmsInboxRowsTableReferences._transactionIdTable(db),
                    referencedColumn: $$SmsInboxRowsTableReferences
                        ._transactionIdTable(db)
                        .id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ));
}

typedef $$SmsInboxRowsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $SmsInboxRowsTable,
    SmsInboxRow,
    $$SmsInboxRowsTableFilterComposer,
    $$SmsInboxRowsTableOrderingComposer,
    $$SmsInboxRowsTableAnnotationComposer,
    $$SmsInboxRowsTableCreateCompanionBuilder,
    $$SmsInboxRowsTableUpdateCompanionBuilder,
    (SmsInboxRow, $$SmsInboxRowsTableReferences),
    SmsInboxRow,
    PrefetchHooks Function({bool suggestedCategoryId, bool transactionId})>;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$CategoryRowsTableTableManager get categoryRows =>
      $$CategoryRowsTableTableManager(_db, _db.categoryRows);
  $$TransactionRowsTableTableManager get transactionRows =>
      $$TransactionRowsTableTableManager(_db, _db.transactionRows);
  $$SettingsRowsTableTableManager get settingsRows =>
      $$SettingsRowsTableTableManager(_db, _db.settingsRows);
  $$SmsInboxRowsTableTableManager get smsInboxRows =>
      $$SmsInboxRowsTableTableManager(_db, _db.smsInboxRows);
}
