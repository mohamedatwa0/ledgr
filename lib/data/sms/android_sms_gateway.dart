import 'package:flutter/services.dart';

import '../../domain/sms/sms_gateway.dart';
import '../../domain/sms/sms_message.dart';

class AndroidSmsGateway implements SmsGateway {
  AndroidSmsGateway({
    MethodChannel channel = const MethodChannel('ledgr/sms'),
    EventChannel incoming = const EventChannel('ledgr/sms/incoming'),
    EventChannel share = const EventChannel('ledgr/sms/share'),
  })  : _channel = channel,
        _incoming = incoming,
        _share = share;

  final MethodChannel _channel;
  final EventChannel _incoming;
  final EventChannel _share;
  Future<bool>? _pluginReady;

  @override
  bool get inboxSupported => true;

  Future<bool> _isPluginReady() {
    return _pluginReady ??= () async {
      try {
        await _channel.invokeMethod<bool>('hasPermission');
        return true;
      } on MissingPluginException {
        return false;
      }
    }();
  }

  Future<T?> _invoke<T>(String method, [dynamic arguments]) async {
    if (!await _isPluginReady()) return null;
    try {
      return await _channel.invokeMethod<T>(method, arguments);
    } on MissingPluginException {
      _pluginReady = Future.value(false);
      return null;
    }
  }

  @override
  Future<bool> hasPermission() async {
    return await _invoke<bool>('hasPermission') ?? false;
  }

  @override
  Future<bool> requestPermission() async {
    return await _invoke<bool>('requestPermission') ?? false;
  }

  @override
  Future<List<RawSms>> readSince(
    DateTime? since,
    Set<String> senders,
  ) async {
    final raw = await _invoke<List<dynamic>>('readSince', {
      'sinceMs': since?.millisecondsSinceEpoch,
      'senders': senders.toList(),
    });
    if (raw == null) return const [];
    return raw.map(_mapRawSms).toList();
  }

  @override
  Stream<RawSms> get incoming async* {
    if (!await _isPluginReady()) return;
    yield* _incoming.receiveBroadcastStream().map(_mapIncoming);
  }

  @override
  Stream<String> get sharedText async* {
    if (!await _isPluginReady()) return;
    yield* _share.receiveBroadcastStream().map((event) => event as String);
  }

  @override
  Future<String?> takeInitialSharedText() {
    return _invoke<String>('takeInitialSharedText');
  }

  RawSms _mapIncoming(dynamic event) {
    return _mapRawSms(event);
  }

  RawSms _mapRawSms(dynamic item) {
    final map = Map<String, dynamic>.from(item as Map);
    return RawSms(
      platformMessageId: map['id']?.toString(),
      sender: map['sender'] as String? ?? '',
      body: map['body'] as String? ?? '',
      receivedAt: DateTime.fromMillisecondsSinceEpoch(
        (map['dateMs'] as num?)?.toInt() ?? DateTime.now().millisecondsSinceEpoch,
      ),
    );
  }
}
