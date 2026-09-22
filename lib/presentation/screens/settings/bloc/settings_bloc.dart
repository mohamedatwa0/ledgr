import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../domain/models/app_settings.dart';
import '../../../../domain/repositories/settings_repository.dart';
import '../../../../domain/repositories/sms_inbox_repository.dart';
import '../../../../domain/usecases/reset_ledger.dart';
import 'settings_event.dart';
import 'settings_state.dart';

class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {
  SettingsBloc({
    required SettingsRepository settings,
    required SmsInboxRepository smsInbox,
    required ResetLedger resetLedger,
  })  : _settings = settings,
        _smsInbox = smsInbox,
        _resetLedger = resetLedger,
        super(SettingsState.initial) {
    on<SettingsStarted>(_onStarted);
    on<SettingsCurrencySelected>(_onCurrencySelected);
    on<SettingsThemeModeSelected>(_onThemeModeSelected);
    on<SettingsDefaultTypeSelected>(_onDefaultTypeSelected);
    on<SettingsLocaleSelected>(_onLocaleSelected);
    on<SettingsResetRequested>(_onResetRequested);
    on<SettingsUpdated>(_onUpdated);
    on<SettingsReadyCountUpdated>(_onReadyCountUpdated);
  }

  final SettingsRepository _settings;
  final SmsInboxRepository _smsInbox;
  final ResetLedger _resetLedger;
  StreamSubscription<AppSettings>? _settingsSub;
  StreamSubscription<int>? _readySub;

  void _onStarted(SettingsStarted event, Emitter<SettingsState> emit) {
    _settingsSub?.cancel();
    _readySub?.cancel();
    _settingsSub = _settings.watch().listen((settings) {
      if (!isClosed) add(SettingsUpdated(settings));
    });
    _readySub = _smsInbox.watchReadyCount().listen((count) {
      if (!isClosed) add(SettingsReadyCountUpdated(count));
    });
  }

  Future<void> _onCurrencySelected(
    SettingsCurrencySelected event,
    Emitter<SettingsState> emit,
  ) {
    return _settings.setCurrencyCode(event.currencyCode);
  }

  Future<void> _onThemeModeSelected(
    SettingsThemeModeSelected event,
    Emitter<SettingsState> emit,
  ) {
    return _settings.setThemeMode(event.themeMode);
  }

  Future<void> _onDefaultTypeSelected(
    SettingsDefaultTypeSelected event,
    Emitter<SettingsState> emit,
  ) {
    return _settings.setDefaultEntryType(event.type);
  }

  Future<void> _onLocaleSelected(
    SettingsLocaleSelected event,
    Emitter<SettingsState> emit,
  ) {
    return _settings.setLocale(event.locale);
  }

  Future<void> _onResetRequested(
    SettingsResetRequested event,
    Emitter<SettingsState> emit,
  ) {
    return _resetLedger();
  }

  void _onUpdated(SettingsUpdated event, Emitter<SettingsState> emit) {
    emit(
      state.copyWith(
        currencyCode: event.settings.currencyCode,
        themeMode: event.settings.themeMode,
        defaultEntryType: event.settings.defaultEntryType,
        locale: event.settings.locale,
        loading: false,
      ),
    );
  }

  void _onReadyCountUpdated(
    SettingsReadyCountUpdated event,
    Emitter<SettingsState> emit,
  ) {
    emit(state.copyWith(readyCount: event.readyCount, loading: false));
  }

  @override
  Future<void> close() {
    _settingsSub?.cancel();
    _readySub?.cancel();
    return super.close();
  }
}
