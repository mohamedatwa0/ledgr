import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../domain/date_utils.dart';
import '../../../../domain/exceptions.dart';
import '../../../../domain/models/app_settings.dart';
import '../../../../domain/models/category.dart';
import '../../../../domain/models/transaction_type.dart';
import '../../../../domain/repositories/category_repository.dart';
import '../../../../domain/repositories/settings_repository.dart';
import '../../../../domain/repositories/sms_inbox_repository.dart';
import '../../../../domain/usecases/dismiss_sms.dart';
import '../../../../domain/usecases/import_parsed_sms.dart';
import 'sms_review_event.dart';
import 'sms_review_state.dart';

class SmsReviewBloc extends Bloc<SmsReviewEvent, SmsReviewState> {
  SmsReviewBloc({
    required this.inboxId,
    required SmsInboxRepository inbox,
    required CategoryRepository categories,
    required SettingsRepository settings,
    required ImportParsedSms importParsedSms,
    required DismissSms dismissSms,
  })  : _inbox = inbox,
        _categories = categories,
        _settings = settings,
        _importParsedSms = importParsedSms,
        _dismissSms = dismissSms,
        super(
          SmsReviewState(
            amountText: '',
            type: TransactionType.expense,
            note: '',
            date: dateOnly(DateTime.now()),
            currencyCode: 'EGP',
            categories: const [],
            body: '',
            loading: true,
            categoriesLoading: true,
          ),
        ) {
    on<SmsReviewStarted>(_onStarted);
    on<SmsReviewAmountChanged>(_onAmountChanged);
    on<SmsReviewTypeChanged>(_onTypeChanged);
    on<SmsReviewCategorySelected>(_onCategorySelected);
    on<SmsReviewNoteChanged>(_onNoteChanged);
    on<SmsReviewDateChanged>(_onDateChanged);
    on<SmsReviewSaveRequested>(_onSaveRequested);
    on<SmsReviewDismissRequested>(_onDismissRequested);
    on<SmsReviewCategoriesUpdated>(_onCategoriesUpdated);
    on<SmsReviewCurrencyUpdated>(_onCurrencyUpdated);
  }

  final int inboxId;
  final SmsInboxRepository _inbox;
  final CategoryRepository _categories;
  final SettingsRepository _settings;
  final ImportParsedSms _importParsedSms;
  final DismissSms _dismissSms;
  StreamSubscription<List<Category>>? _categorySub;
  StreamSubscription<AppSettings>? _settingsSub;

  Future<void> _onStarted(
    SmsReviewStarted event,
    Emitter<SmsReviewState> emit,
  ) async {
    _settingsSub?.cancel();
    _settingsSub = _settings.watch().listen((settings) {
      if (!isClosed) add(SmsReviewCurrencyUpdated(settings.currencyCode));
    });

    final item = await _inbox.getById(inboxId);
    if (item == null || isClosed) {
      emit(state.copyWith(loading: false, errorMessage: 'SMS not found.'));
      return;
    }

    final type = item.type ?? TransactionType.expense;
    emit(
      state.copyWith(
        amountText: item.amount == null ? '' : minorToInput(item.amount!),
        type: type,
        categoryId: item.suggestedCategoryId,
        note: item.note ?? '',
        date: dateOnly(item.valueDate ?? item.receivedAt),
        smsCurrencyCode: item.currencyCode,
        body: item.body,
        loading: false,
      ),
    );
    _watchCategories(type);
  }

  void _onAmountChanged(
    SmsReviewAmountChanged event,
    Emitter<SmsReviewState> emit,
  ) {
    emit(state.copyWith(amountText: event.value));
  }

  void _onTypeChanged(
    SmsReviewTypeChanged event,
    Emitter<SmsReviewState> emit,
  ) {
    if (state.type == event.type) return;
    emit(state.copyWith(type: event.type, clearCategory: true));
    _watchCategories(event.type);
  }

  void _onCategorySelected(
    SmsReviewCategorySelected event,
    Emitter<SmsReviewState> emit,
  ) {
    emit(state.copyWith(categoryId: event.categoryId));
  }

  void _onNoteChanged(
      SmsReviewNoteChanged event, Emitter<SmsReviewState> emit) {
    emit(state.copyWith(note: event.note));
  }

  void _onDateChanged(
      SmsReviewDateChanged event, Emitter<SmsReviewState> emit) {
    emit(state.copyWith(date: dateOnly(event.date)));
  }

  Future<void> _onSaveRequested(
    SmsReviewSaveRequested event,
    Emitter<SmsReviewState> emit,
  ) async {
    final amount = parseMinorUnits(state.amountText) ?? 0;
    final categoryId = state.categoryId;
    if (amount <= 0 || categoryId == null) return;
    emit(state.copyWith(saving: true, saved: false, clearError: true));
    try {
      await _importParsedSms(
        inboxId: inboxId,
        amount: amount,
        type: state.type,
        categoryId: categoryId,
        note: state.note,
        date: state.date,
      );
      if (!isClosed) emit(state.copyWith(saving: false, saved: true));
    } on LedgrException catch (e) {
      if (!isClosed) {
        emit(state.copyWith(saving: false, errorMessage: e.message));
      }
    }
  }

  Future<void> _onDismissRequested(
    SmsReviewDismissRequested event,
    Emitter<SmsReviewState> emit,
  ) async {
    try {
      await _dismissSms(inboxId);
      if (!isClosed) emit(state.copyWith(dismissed: true));
    } on LedgrException catch (e) {
      if (!isClosed) emit(state.copyWith(errorMessage: e.message));
    }
  }

  void _onCategoriesUpdated(
    SmsReviewCategoriesUpdated event,
    Emitter<SmsReviewState> emit,
  ) {
    emit(
      state.copyWith(categories: event.categories, categoriesLoading: false),
    );
  }

  void _onCurrencyUpdated(
    SmsReviewCurrencyUpdated event,
    Emitter<SmsReviewState> emit,
  ) {
    emit(state.copyWith(currencyCode: event.currencyCode));
  }

  void _watchCategories(TransactionType type) {
    _categorySub?.cancel();
    _categorySub = _categories.watchByType(type).listen((categories) {
      if (!isClosed) add(SmsReviewCategoriesUpdated(categories));
    });
  }

  @override
  Future<void> close() {
    _categorySub?.cancel();
    _settingsSub?.cancel();
    return super.close();
  }
}
