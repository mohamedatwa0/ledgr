import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../domain/date_utils.dart';
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
        super(HistoryState.initial()) {
    on<HistoryStarted>(_onStarted);
    on<HistoryFilterChanged>(_onFilterChanged);
    on<HistoryDeleteRequested>(_onDeleteRequested);
    on<HistoryEntriesUpdated>(_onEntriesUpdated);
    on<HistoryQueryChanged>(_onQueryChanged);
    on<HistoryMonthChanged>(_onMonthChanged);
  }

  final TransactionRepository _transactions;
  final DeleteTransaction _deleteTransaction;
  StreamSubscription<List<TransactionEntry>>? _subscription;

  void _onStarted(HistoryStarted event, Emitter<HistoryState> emit) {
    _watch(filter: state.filter, month: state.month);
  }

  void _onFilterChanged(
    HistoryFilterChanged event,
    Emitter<HistoryState> emit,
  ) {
    if (event.filter == state.filter) return;
    emit(state.copyWith(filter: event.filter, loading: state.entries.isEmpty));
    _watch(filter: event.filter, month: state.month);
  }

  void _onMonthChanged(HistoryMonthChanged event, Emitter<HistoryState> emit) {
    final month = monthStart(event.month);
    if (isSameMonth(month, state.month)) return;
    emit(
      state.copyWith(
        month: month,
        entries: const [],
        loading: true,
      ),
    );
    _watch(filter: state.filter, month: month);
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

  void _onQueryChanged(
    HistoryQueryChanged event,
    Emitter<HistoryState> emit,
  ) {
    emit(state.copyWith(query: event.query));
  }

  void _watch({required HistoryFilter filter, required DateTime month}) {
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
    _subscription = _transactions
        .watchEntries(
      type: type,
      from: monthStart(month),
      toExclusive: monthEndExclusive(month),
    )
        .listen((entries) {
      if (!isClosed) add(HistoryEntriesUpdated(entries));
    });
  }

  @override
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }
}
