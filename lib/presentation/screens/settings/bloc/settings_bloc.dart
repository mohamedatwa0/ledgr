import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../domain/models/app_settings.dart';
import '../../../../domain/repositories/settings_repository.dart';
import '../../../../domain/repositories/sms_inbox_repository.dart';
import 'settings_event.dart';
import 'settings_state.dart';

class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {
  SettingsBloc({
    required SettingsRepository settings,
    required SmsInboxRepository smsInbox,
  })  : _settings = settings,
        _smsInbox = smsInbox,
        super(SettingsState.initial) {
    on<SettingsStarted>(_onStarted);
    on<SettingsCurrencySelected>(_onCurrencySelected);
    on<SettingsCurrencyUpdated>(_onCurrencyUpdated);
    on<SettingsReadyCountUpdated>(_onReadyCountUpdated);
  }

  final SettingsRepository _settings;
  final SmsInboxRepository _smsInbox;
  StreamSubscription<AppSettings>? _settingsSub;
  StreamSubscription<int>? _readySub;

  void _onStarted(SettingsStarted event, Emitter<SettingsState> emit) {
    _settingsSub?.cancel();
    _readySub?.cancel();
    _settingsSub = _settings.watch().listen((settings) {
      if (!isClosed) add(SettingsCurrencyUpdated(settings.currencyCode));
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

  void _onCurrencyUpdated(
    SettingsCurrencyUpdated event,
    Emitter<SettingsState> emit,
  ) {
    emit(state.copyWith(currencyCode: event.currencyCode, loading: false));
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
