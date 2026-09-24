import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';

import '../../../../domain/date_utils.dart';
import '../../../../domain/exceptions.dart';
import '../../../../domain/models/app_settings.dart';
import '../../../../domain/models/category.dart';
import '../../../../domain/models/transaction_command.dart';
import '../../../../domain/models/transaction_type.dart';
import '../../../../domain/repositories/category_repository.dart';
import '../../../../domain/repositories/settings_repository.dart';
import '../../../../domain/repositories/transaction_repository.dart';
import '../../../../domain/usecases/create_category.dart';
import '../../../../domain/usecases/create_transaction.dart';
import '../../../../domain/usecases/delete_transaction.dart';
import '../../../../domain/usecases/update_transaction.dart';
import '../../../../domain/voice/parse_voice_entry.dart';
import '../../../widgets/category_choices.dart';
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
    required CreateCategory createCategory,
    this.transactionId,
    this.voiceDraft,
  })  : _transactions = transactions,
        _categories = categories,
        _settings = settings,
        _createTransaction = createTransaction,
        _updateTransaction = updateTransaction,
        _deleteTransaction = deleteTransaction,
        _createCategory = createCategory,
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
    on<AddTransactionPendingCategorySelected>(_onPendingCategorySelected);
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
  final CreateCategory _createCategory;
  final int? transactionId;
  final ParsedVoiceEntry? voiceDraft;

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
      final draft = voiceDraft;
      if (draft != null) {
        final type = draft.type ?? settings.defaultEntryType;
        emit(
          state.copyWith(
            type: type,
            amountText:
                draft.amountMinor == null ? '' : minorToInput(draft.amountMinor!),
            note: draft.transcript,
            requestedCategoryName: draft.categoryName,
            createIfMissing: draft.createIfMissing,
          ),
        );
        _watchCategories(type);
        return;
      }
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
    emit(
      state.copyWith(
        type: event.type,
        clearCategory: true,
        userPickedCategory: false,
      ),
    );
    _watchCategories(event.type);
  }

  void _onCategorySelected(
    AddTransactionCategorySelected event,
    Emitter<AddTransactionState> emit,
  ) {
    emit(
      state.copyWith(
        categoryId: event.categoryId,
        userPickedCategory: true,
        clearPending: true,
      ),
    );
  }

  void _onPendingCategorySelected(
    AddTransactionPendingCategorySelected event,
    Emitter<AddTransactionState> emit,
  ) {
    final name = state.requestedCategoryName;
    if (name == null || name.isEmpty) return;
    emit(
      state.copyWith(
        pendingCategoryName: name,
        userPickedCategory: true,
        clearCategory: true,
      ),
    );
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
    var categoryId = state.categoryId;
    if (amount <= 0) return;
    if (categoryId == null && !state.hasPendingCategory) return;

    emit(state.copyWith(saving: true, saved: false, clearError: true));
    try {
      if (categoryId == null) {
        final pendingName = state.pendingCategoryName!;
        final existing = await _categories.findByNameAndType(
          pendingName,
          state.type,
        );
        if (existing != null) {
          categoryId = existing.id;
        } else {
          final created = await _createCategory(
            name: pendingName,
            type: state.type,
            iconCodePoint: TablerIcons.tag.codePoint,
            colorValue: _nextCategoryColor(state.categories),
          );
          categoryId = created.id;
        }
      }
      final command = TransactionCommand(
        amount: amount,
        type: state.type,
        categoryId: categoryId,
        note: state.note,
        date: state.date,
      );
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
    emit(_resolvedCategoryState(event.categories));
  }

  AddTransactionState _resolvedCategoryState(List<Category> categories) {
    final next = state.copyWith(
      categories: categories,
      categoriesLoading: false,
    );
    if (state.userPickedCategory) return next;
    final name = state.requestedCategoryName;
    if (name == null || name.isEmpty) return next;
    for (final category in categories) {
      if (category.name.toLowerCase() == name.toLowerCase()) {
        return next.copyWith(categoryId: category.id, clearPending: true);
      }
    }
    if (state.createIfMissing) {
      return next.copyWith(pendingCategoryName: name, clearCategory: true);
    }
    for (final category in categories) {
      if (category.isFallback) {
        return next.copyWith(categoryId: category.id, clearPending: true);
      }
    }
    return next;
  }

  int _nextCategoryColor(List<Category> categories) {
    final used = categories.map((category) => category.colorValue).toSet();
    for (final color in categoryColorChoices) {
      if (!used.contains(color)) return color;
    }
    return categoryColorChoices[categories.length % categoryColorChoices.length];
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
