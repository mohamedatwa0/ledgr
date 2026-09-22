import 'package:drift/drift.dart';

import '../../domain/models/ledger_transaction.dart';
import '../../domain/models/transaction_entry.dart';
import '../../domain/models/transaction_source.dart';
import '../../domain/models/transaction_type.dart';
import '../../domain/repositories/transaction_repository.dart';
import '../db/app_database.dart';
import '../mappers.dart';

class TransactionRepositoryImpl implements TransactionRepository {
  TransactionRepositoryImpl(this._db);

  final AppDatabase _db;

  @override
  Stream<List<TransactionEntry>> watchEntries({
    DateTime? from,
    DateTime? toExclusive,
    TransactionType? type,
  }) {
    final query = _db.select(_db.transactionRows).join([
      innerJoin(
        _db.categoryRows,
        _db.categoryRows.id.equalsExp(_db.transactionRows.categoryId),
      ),
    ]);

    if (from != null) {
      query.where(_db.transactionRows.date.isBiggerOrEqualValue(from));
    }
    if (toExclusive != null) {
      query.where(_db.transactionRows.date.isSmallerThanValue(toExclusive));
    }
    if (type != null) {
      query.where(_db.transactionRows.type.equalsValue(type));
    }

    query.orderBy([
      OrderingTerm.desc(_db.transactionRows.date),
      OrderingTerm.desc(_db.transactionRows.createdAt),
    ]);

    return query.watch().map((rows) {
      return rows
          .map(
            (row) => entryFromRows(
              row.readTable(_db.transactionRows),
              row.readTable(_db.categoryRows),
            ),
          )
          .toList();
    });
  }

  @override
  Future<LedgerTransaction?> getById(int id) async {
    final row = await (_db.select(_db.transactionRows)
          ..where((t) => t.id.equals(id)))
        .getSingleOrNull();
    return row == null ? null : transactionFromRow(row);
  }

  @override
  Future<int> countForCategory(int categoryId) async {
    final count = _db.transactionRows.id.count();
    final query = _db.selectOnly(_db.transactionRows)
      ..addColumns([count])
      ..where(_db.transactionRows.categoryId.equals(categoryId));
    final row = await query.getSingle();
    return row.read(count) ?? 0;
  }

  @override
  Future<LedgerTransaction> create({
    required int amount,
    required TransactionType type,
    required int categoryId,
    String? note,
    required DateTime date,
    TransactionSource source = TransactionSource.manual,
  }) async {
    final id = await _db.into(_db.transactionRows).insert(
          TransactionRowsCompanion.insert(
            amount: amount,
            type: type,
            categoryId: categoryId,
            note: Value(note),
            date: date,
            createdAt: DateTime.now(),
            source: Value(source),
          ),
        );
    final created = await getById(id);
    return created!;
  }

  @override
  Future<void> update(LedgerTransaction transaction) {
    return _db.update(_db.transactionRows).replace(
          TransactionRow(
            id: transaction.id,
            amount: transaction.amount,
            type: transaction.type,
            categoryId: transaction.categoryId,
            note: transaction.note,
            date: transaction.date,
            createdAt: transaction.createdAt,
            source: transaction.source,
          ),
        );
  }

  @override
  Future<void> delete(int id) {
    return (_db.delete(_db.transactionRows)..where((t) => t.id.equals(id))).go();
  }

  @override
  Future<void> deleteAll() {
    return _db.delete(_db.transactionRows).go();
  }
}
