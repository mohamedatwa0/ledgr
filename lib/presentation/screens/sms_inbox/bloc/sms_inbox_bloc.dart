import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../domain/exceptions.dart';
import '../../../../domain/repositories/sms_inbox_repository.dart';
import '../../../../domain/sms/sms_gateway.dart';
import '../../../../domain/sms/sms_inbox_item.dart';
import '../../../../domain/sms/sms_inbox_status.dart';
import '../../../../domain/usecases/dismiss_sms.dart';
import '../../../../domain/usecases/ingest_sms.dart';
import '../../../../domain/usecases/scan_sms_inbox.dart';
import 'sms_inbox_event.dart';
import 'sms_inbox_state.dart';

class SmsInboxBloc extends Bloc<SmsInboxEvent, SmsInboxState> {
  SmsInboxBloc({
    required SmsInboxRepository inbox,
    required SmsGateway gateway,
    required IngestSms ingestSms,
    required ScanSmsInbox scanSmsInbox,
    required DismissSms dismissSms,
  })  : _inbox = inbox,
        _gateway = gateway,
        _ingestSms = ingestSms,
        _scanSmsInbox = scanSmsInbox,
        _dismissSms = dismissSms,
        super(
          SmsInboxState(
            filter: SmsInboxFilter.toReview,
            items: const [],
            pasteText: '',
            inboxSupported: gateway.inboxSupported,
            hasPermission: false,
            loading: true,
          ),
        ) {
    on<SmsInboxStarted>(_onStarted);
    on<SmsInboxFilterChanged>(_onFilterChanged);
    on<SmsInboxPasteChanged>(_onPasteChanged);
    on<SmsInboxParseRequested>(_onParseRequested);
    on<SmsInboxScanRequested>(_onScanRequested);
    on<SmsInboxPermissionRequested>(_onPermissionRequested);
    on<SmsInboxDismissRequested>(_onDismissRequested);
    on<SmsInboxItemsUpdated>(_onItemsUpdated);
    on<SmsInboxPermissionUpdated>(_onPermissionUpdated);
  }

  final SmsInboxRepository _inbox;
  final SmsGateway _gateway;
  final IngestSms _ingestSms;
  final ScanSmsInbox _scanSmsInbox;
  final DismissSms _dismissSms;
  StreamSubscription<List<SmsInboxItem>>? _itemsSub;

  Future<void> _onStarted(
    SmsInboxStarted event,
    Emitter<SmsInboxState> emit,
  ) async {
    final granted =
        state.inboxSupported ? await _gateway.hasPermission() : false;
    emit(state.copyWith(hasPermission: granted));
    _watch(state.filter);
    if (granted) {
      await _scanSmsInbox();
    }
  }

  void _onFilterChanged(
    SmsInboxFilterChanged event,
    Emitter<SmsInboxState> emit,
  ) {
    emit(state.copyWith(filter: event.filter, loading: true));
    _watch(event.filter);
  }

  void _onPasteChanged(
    SmsInboxPasteChanged event,
    Emitter<SmsInboxState> emit,
  ) {
    emit(state.copyWith(pasteText: event.text, clearMessage: true));
  }

  Future<void> _onParseRequested(
    SmsInboxParseRequested event,
    Emitter<SmsInboxState> emit,
  ) async {
    final body = event.text.trim().isNotEmpty
        ? event.text.trim()
        : state.pasteText.trim();
    if (body.isEmpty) return;
    emit(state.copyWith(parsing: true, clearMessage: true));
    try {
      final result = await _ingestSms(pasteRawSms(body));
      if (isClosed) return;
      emit(
        state.copyWith(
          parsing: false,
          pasteText: '',
          filter: result.item.status.statusFilter,
          message: result.duplicate ? 'Already in the inbox' : null,
          clearMessage: !result.duplicate,
        ),
      );
      _watch(result.item.status.statusFilter);
    } on LedgrException catch (e) {
      if (!isClosed) {
        emit(state.copyWith(parsing: false, message: e.message));
      }
    }
  }

  Future<void> _onScanRequested(
    SmsInboxScanRequested event,
    Emitter<SmsInboxState> emit,
  ) async {
    emit(state.copyWith(scanning: true, clearMessage: true));
    final added = await _scanSmsInbox();
    if (isClosed) return;
    emit(
      state.copyWith(
        scanning: false,
        message: added == 0
            ? 'No new bank messages'
            : 'Found $added message${added == 1 ? '' : 's'} to review',
      ),
    );
  }

  Future<void> _onPermissionRequested(
    SmsInboxPermissionRequested event,
    Emitter<SmsInboxState> emit,
  ) async {
    final granted = await _gateway.requestPermission();
    if (isClosed) return;
    emit(state.copyWith(hasPermission: granted));
    if (granted) await _scanSmsInbox();
  }

  Future<void> _onDismissRequested(
    SmsInboxDismissRequested event,
    Emitter<SmsInboxState> emit,
  ) async {
    try {
      await _dismissSms(event.id);
    } on LedgrException catch (e) {
      if (!isClosed) emit(state.copyWith(message: e.message));
    }
  }

  void _onItemsUpdated(
    SmsInboxItemsUpdated event,
    Emitter<SmsInboxState> emit,
  ) {
    emit(state.copyWith(items: event.items, loading: false));
  }

  void _onPermissionUpdated(
    SmsInboxPermissionUpdated event,
    Emitter<SmsInboxState> emit,
  ) {
    emit(state.copyWith(hasPermission: event.granted));
  }

  void _watch(SmsInboxFilter filter) {
    _itemsSub?.cancel();
    _itemsSub = _inbox.watchByStatus(filter.status).listen((items) {
      if (!isClosed) add(SmsInboxItemsUpdated(items));
    });
  }

  @override
  Future<void> close() {
    _itemsSub?.cancel();
    return super.close();
  }
}

extension on SmsInboxStatus {
  SmsInboxFilter get statusFilter {
    switch (this) {
      case SmsInboxStatus.ready:
        return SmsInboxFilter.toReview;
      case SmsInboxStatus.unmatched:
        return SmsInboxFilter.unmatched;
      case SmsInboxStatus.imported:
        return SmsInboxFilter.imported;
      case SmsInboxStatus.dismissed:
      case SmsInboxStatus.duplicate:
        return SmsInboxFilter.toReview;
    }
  }
}
