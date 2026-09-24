import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../domain/date_utils.dart';
import '../../../../domain/models/app_settings.dart';
import '../../../../domain/models/monthly_summary.dart';
import '../../../../domain/models/transaction_entry.dart';
import '../../../../domain/repositories/settings_repository.dart';
import '../../../../domain/repositories/transaction_repository.dart';
import '../../../../domain/usecases/delete_transaction.dart';
import '../../../../domain/usecases/get_monthly_summary.dart';
import 'home_event.dart';
import 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc({
    required TransactionRepository transactions,
    required SettingsRepository settings,
    required DeleteTransaction deleteTransaction,
  })  : _transactions = transactions,
        _settings = settings,
        _deleteTransaction = deleteTransaction,
        super(HomeState.initial()) {
    on<HomeStarted>(_onStarted);
    on<HomeMonthChanged>(_onMonthChanged);
    on<HomeEntriesUpdated>(_onEntriesUpdated);
    on<HomeCurrencyUpdated>(_onCurrencyUpdated);
    on<HomeDeleteRequested>(_onDeleteRequested);
  }

  final TransactionRepository _transactions;
  final SettingsRepository _settings;
  final DeleteTransaction _deleteTransaction;
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
  ) {
    return _deleteTransaction(event.id);
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
