import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../domain/models/app_settings.dart';
import '../../../../domain/repositories/settings_repository.dart';
import 'settings_event.dart';
import 'settings_state.dart';

class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {
  SettingsBloc({required SettingsRepository settings})
      : _settings = settings,
        super(SettingsState.initial) {
    on<SettingsStarted>(_onStarted);
    on<SettingsCurrencySelected>(_onCurrencySelected);
    on<SettingsUpdated>(_onUpdated);
  }

  final SettingsRepository _settings;
  StreamSubscription<AppSettings>? _subscription;

  void _onStarted(SettingsStarted event, Emitter<SettingsState> emit) {
    _subscription?.cancel();
    _subscription = _settings.watch().listen((settings) {
      if (!isClosed) add(SettingsUpdated(settings.currencyCode));
    });
  }

  Future<void> _onCurrencySelected(
    SettingsCurrencySelected event,
    Emitter<SettingsState> emit,
  ) {
    return _settings.setCurrencyCode(event.currencyCode);
  }

  void _onUpdated(SettingsUpdated event, Emitter<SettingsState> emit) {
    emit(state.copyWith(currencyCode: event.currencyCode, loading: false));
  }

  @override
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }
}
