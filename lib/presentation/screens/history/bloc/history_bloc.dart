import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../domain/models/transaction_entry.dart';
import '../../../../domain/models/transaction_type.dart';
import '../../../../domain/repositories/transaction_repository.dart';
import '../../../../domain/usecases/delete_transaction.dart';
import 'history_event.dart';
import 'history_state.dart';

class HistoryBloc extends Bloc<HistoryEvent, HistoryState> {
  HistoryBloc({
    required TransactionRepository transactions,
    required DeleteTransaction deleteTransaction,
  })  : _transactions = transactions,
        _deleteTransaction = deleteTransaction,
        super(HistoryState.initial) {
    on<HistoryStarted>(_onStarted);
    on<HistoryFilterChanged>(_onFilterChanged);
    on<HistoryDeleteRequested>(_onDeleteRequested);
    on<HistoryEntriesUpdated>(_onEntriesUpdated);
  }

  final TransactionRepository _transactions;
  final DeleteTransaction _deleteTransaction;
  StreamSubscription<List<TransactionEntry>>? _subscription;

  void _onStarted(HistoryStarted event, Emitter<HistoryState> emit) {
    _watch(state.filter);
  }

  void _onFilterChanged(
    HistoryFilterChanged event,
    Emitter<HistoryState> emit,
  ) {
    if (event.filter == state.filter) return;
    emit(state.copyWith(filter: event.filter, loading: state.entries.isEmpty));
    _watch(event.filter);
  }

  Future<void> _onDeleteRequested(
    HistoryDeleteRequested event,
    Emitter<HistoryState> emit,
  ) {
    return _deleteTransaction(event.id);
  }

  void _onEntriesUpdated(
    HistoryEntriesUpdated event,
    Emitter<HistoryState> emit,
  ) {
    emit(state.copyWith(entries: event.entries, loading: false));
  }

  void _watch(HistoryFilter filter) {
    _subscription?.cancel();
    TransactionType? type;
    switch (filter) {
      case HistoryFilter.all:
        type = null;
      case HistoryFilter.credit:
        type = TransactionType.income;
      case HistoryFilter.debit:
        type = TransactionType.expense;
    }
    _subscription = _transactions.watchEntries(type: type).listen((entries) {
      if (!isClosed) add(HistoryEntriesUpdated(entries));
    });
  }

  @override
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }
}
