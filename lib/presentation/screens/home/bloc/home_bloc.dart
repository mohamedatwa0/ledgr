import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../domain/date_utils.dart';
import '../../../../domain/models/app_settings.dart';
import '../../../../domain/models/monthly_summary.dart';
import '../../../../domain/models/transaction_entry.dart';
import '../../../../domain/exceptions.dart';
import '../../../../domain/models/transaction_command.dart';
import '../../../../domain/repositories/settings_repository.dart';
import '../../../../domain/repositories/transaction_repository.dart';
import '../../../../domain/usecases/create_transaction.dart';
import '../../../../domain/usecases/delete_transaction.dart';
import '../../../../domain/usecases/get_monthly_summary.dart';
import 'home_event.dart';
import 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc({
    required TransactionRepository transactions,
    required SettingsRepository settings,
    required DeleteTransaction deleteTransaction,
    required CreateTransaction createTransaction,
  })  : _transactions = transactions,
        _settings = settings,
        _deleteTransaction = deleteTransaction,
        _createTransaction = createTransaction,
        super(HomeState.initial()) {
    on<HomeStarted>(_onStarted);
    on<HomeMonthChanged>(_onMonthChanged);
    on<HomeEntriesUpdated>(_onEntriesUpdated);
    on<HomeCurrencyUpdated>(_onCurrencyUpdated);
    on<HomeDeleteRequested>(_onDeleteRequested);
    on<HomeUndoDeleteRequested>(_onUndoDeleteRequested);
  }

  final TransactionRepository _transactions;
  final SettingsRepository _settings;
  final DeleteTransaction _deleteTransaction;
  final CreateTransaction _createTransaction;
  StreamSubscription<List<TransactionEntry>>? _entriesSub;
  StreamSubscription<AppSettings>? _settingsSub;

  void _onStarted(HomeStarted event, Emitter<HomeState> emit) {
    _settingsSub?.cancel();
    _settingsSub = _settings.watch().listen((settings) {
      if (!isClosed) add(HomeCurrencyUpdated(settings.currencyCode));
    });
    _watchMonth(state.month);
  }

  void _onMonthChanged(HomeMonthChanged event, Emitter<HomeState> emit) {
    final month = monthStart(event.month);
    if (isSameMonth(month, state.month)) return;
    emit(
      state.copyWith(
        month: month,
        entries: const [],
        summary: MonthlySummary.empty,
        loading: true,
      ),
    );
    _watchMonth(month);
  }

  void _onEntriesUpdated(HomeEntriesUpdated event, Emitter<HomeState> emit) {
    emit(
      state.copyWith(
        entries: event.entries,
        summary: const GetMonthlySummary().call([
          for (final entry in event.entries) entry.transaction,
        ]),
        loading: false,
      ),
    );
  }

  void _onCurrencyUpdated(HomeCurrencyUpdated event, Emitter<HomeState> emit) {
    emit(state.copyWith(currencyCode: event.currencyCode));
  }

  Future<void> _onDeleteRequested(
    HomeDeleteRequested event,
    Emitter<HomeState> emit,
  ) async {
    TransactionEntry? entry;
    for (final item in state.entries) {
      if (item.transaction.id == event.id) {
        entry = item;
        break;
      }
    }
    final previous = state.entries;
    final remaining = [
      for (final item in state.entries)
        if (item.transaction.id != event.id) item,
    ];
    emit(
      state.copyWith(
        entries: remaining,
        summary: const GetMonthlySummary().call([
          for (final item in remaining) item.transaction,
        ]),
        undoEntry: entry,
        clearError: true,
      ),
    );
    try {
      await _deleteTransaction(event.id);
    } on LedgrException catch (e) {
      if (!isClosed) {
        emit(
          state.copyWith(
            entries: previous,
            summary: const GetMonthlySummary().call([
              for (final item in previous) item.transaction,
            ]),
            errorMessage: e.message,
            clearUndo: true,
          ),
        );
      }
    }
  }

  Future<void> _onUndoDeleteRequested(
    HomeUndoDeleteRequested event,
    Emitter<HomeState> emit,
  ) async {
    final entry = state.undoEntry;
    if (entry == null) return;
    try {
      await _createTransaction(
        TransactionCommand(
          amount: entry.transaction.amount,
          type: entry.transaction.type,
          categoryId: entry.category.id,
          note: entry.transaction.note,
          date: entry.transaction.date,
          source: entry.transaction.source,
        ),
      );
      if (!isClosed) emit(state.copyWith(clearUndo: true, clearError: true));
    } on LedgrException catch (e) {
      if (!isClosed) emit(state.copyWith(errorMessage: e.message));
    }
  }

  void _watchMonth(DateTime month) {
    _entriesSub?.cancel();
    _entriesSub = _transactions
        .watchEntries(
      from: monthStart(month),
      toExclusive: monthEndExclusive(month),
    )
        .listen((entries) {
      if (!isClosed) add(HomeEntriesUpdated(entries));
    });
  }

  @override
  Future<void> close() {
    _entriesSub?.cancel();
    _settingsSub?.cancel();
    return super.close();
  }
}
