import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../domain/date_utils.dart';
import '../../../../domain/exceptions.dart';
import '../../../../domain/models/app_settings.dart';
import '../../../../domain/models/category.dart';
import '../../../../domain/models/transaction_command.dart';
import '../../../../domain/models/transaction_type.dart';
import '../../../../domain/repositories/category_repository.dart';
import '../../../../domain/repositories/settings_repository.dart';
import '../../../../domain/repositories/transaction_repository.dart';
import '../../../../domain/usecases/create_transaction.dart';
import '../../../../domain/usecases/delete_transaction.dart';
import '../../../../domain/usecases/update_transaction.dart';
import 'add_transaction_event.dart';
import 'add_transaction_state.dart';

class AddTransactionBloc
    extends Bloc<AddTransactionEvent, AddTransactionState> {
  AddTransactionBloc({
    required TransactionRepository transactions,
    required CategoryRepository categories,
    required SettingsRepository settings,
    required CreateTransaction createTransaction,
    required UpdateTransaction updateTransaction,
    required DeleteTransaction deleteTransaction,
    this.transactionId,
  })  : _transactions = transactions,
        _categories = categories,
        _settings = settings,
        _createTransaction = createTransaction,
        _updateTransaction = updateTransaction,
        _deleteTransaction = deleteTransaction,
        super(
          AddTransactionState(
            amountText: '',
            type: TransactionType.expense,
            note: '',
            date: dateOnly(DateTime.now()),
            currencyCode: 'EGP',
            categories: const [],
            loading: transactionId != null,
            categoriesLoading: true,
          ),
        ) {
    on<AddTransactionStarted>(_onStarted);
    on<AddTransactionAmountChanged>(_onAmountChanged);
    on<AddTransactionTypeChanged>(_onTypeChanged);
    on<AddTransactionCategorySelected>(_onCategorySelected);
    on<AddTransactionNoteChanged>(_onNoteChanged);
    on<AddTransactionDateChanged>(_onDateChanged);
    on<AddTransactionSaveRequested>(_onSaveRequested);
    on<AddTransactionDeleteRequested>(_onDeleteRequested);
    on<AddTransactionCategoriesUpdated>(_onCategoriesUpdated);
    on<AddTransactionCurrencyUpdated>(_onCurrencyUpdated);
  }

  final TransactionRepository _transactions;
  final CategoryRepository _categories;
  final SettingsRepository _settings;
  final CreateTransaction _createTransaction;
  final UpdateTransaction _updateTransaction;
  final DeleteTransaction _deleteTransaction;
  final int? transactionId;

  StreamSubscription<List<Category>>? _categorySub;
  StreamSubscription<AppSettings>? _settingsSub;

  Future<void> _onStarted(
    AddTransactionStarted event,
    Emitter<AddTransactionState> emit,
  ) async {
    _settingsSub?.cancel();
    _settingsSub = _settings.watch().listen((settings) {
      if (!isClosed) add(AddTransactionCurrencyUpdated(settings.currencyCode));
    });

    final id = transactionId;
    if (id == null) {
      final settings = await _settings.get();
      if (isClosed) return;
      emit(state.copyWith(type: settings.defaultEntryType));
      _watchCategories(settings.defaultEntryType);
      return;
    }
    _watchCategories(state.type);
    final tx = await _transactions.getById(id);
    if (isClosed) return;
    if (tx == null) {
      emit(
        state.copyWith(
          loading: false,
          notFound: true,
          errorMessage: const TransactionNotFoundException().message,
        ),
      );
      return;
    }
    emit(
      state.copyWith(
        amountText: minorToInput(tx.amount),
        type: tx.type,
        categoryId: tx.categoryId,
        note: tx.note ?? '',
        date: dateOnly(tx.date),
        loading: false,
      ),
    );
    _watchCategories(tx.type);
  }

  void _onAmountChanged(
    AddTransactionAmountChanged event,
    Emitter<AddTransactionState> emit,
  ) {
    emit(state.copyWith(amountText: event.value));
  }

  void _onTypeChanged(
    AddTransactionTypeChanged event,
    Emitter<AddTransactionState> emit,
  ) {
    if (state.type == event.type) return;
    emit(state.copyWith(type: event.type, clearCategory: true));
    _watchCategories(event.type);
  }

  void _onCategorySelected(
    AddTransactionCategorySelected event,
    Emitter<AddTransactionState> emit,
  ) {
    emit(state.copyWith(categoryId: event.categoryId));
  }

  void _onNoteChanged(
    AddTransactionNoteChanged event,
    Emitter<AddTransactionState> emit,
  ) {
    emit(state.copyWith(note: event.note));
  }

  void _onDateChanged(
    AddTransactionDateChanged event,
    Emitter<AddTransactionState> emit,
  ) {
    emit(state.copyWith(date: dateOnly(event.date)));
  }

  Future<void> _onSaveRequested(
    AddTransactionSaveRequested event,
    Emitter<AddTransactionState> emit,
  ) async {
    final amount = parseMinorUnits(state.amountText) ?? 0;
    final categoryId = state.categoryId;
    if (amount <= 0 || categoryId == null) return;

    emit(state.copyWith(saving: true, saved: false, clearError: true));
    final command = TransactionCommand(
      amount: amount,
      type: state.type,
      categoryId: categoryId,
      note: state.note,
      date: state.date,
    );
    try {
      final id = transactionId;
      if (id == null) {
        await _createTransaction(command);
      } else {
        await _updateTransaction(id, command);
      }
      if (!isClosed) emit(state.copyWith(saving: false, saved: true));
    } on LedgrException catch (e) {
      if (!isClosed) {
        emit(state.copyWith(saving: false, errorMessage: e.message));
      }
    }
  }

  Future<void> _onDeleteRequested(
    AddTransactionDeleteRequested event,
    Emitter<AddTransactionState> emit,
  ) async {
    final id = transactionId;
    if (id == null) return;
    emit(state.copyWith(saving: true, clearError: true));
    try {
      await _deleteTransaction(id);
      if (!isClosed) emit(state.copyWith(saving: false, deleted: true));
    } on LedgrException catch (e) {
      if (!isClosed) {
        emit(state.copyWith(saving: false, errorMessage: e.message));
      }
    }
  }

  void _onCategoriesUpdated(
    AddTransactionCategoriesUpdated event,
    Emitter<AddTransactionState> emit,
  ) {
    emit(
      state.copyWith(
        categories: event.categories,
        categoriesLoading: false,
      ),
    );
  }

  void _onCurrencyUpdated(
    AddTransactionCurrencyUpdated event,
    Emitter<AddTransactionState> emit,
  ) {
    emit(state.copyWith(currencyCode: event.currencyCode));
  }

  void _watchCategories(TransactionType type) {
    _categorySub?.cancel();
    _categorySub = _categories.watchByType(type).listen((categories) {
      if (!isClosed) add(AddTransactionCategoriesUpdated(categories));
    });
  }

  @override
  Future<void> close() {
    _categorySub?.cancel();
    _settingsSub?.cancel();
    return super.close();
  }
}
