import '../repositories/settings_repository.dart';
import '../sms/sms_gateway.dart';
import '../sms/sms_message.dart';
import '../sms/templates/template_registry.dart';
import 'ingest_sms.dart';

class ScanSmsInbox {
  const ScanSmsInbox(this._gateway, this._settings, this._ingest);

  final SmsGateway _gateway;
  final SettingsRepository _settings;
  final IngestSms _ingest;

  Future<int> call() async {
    if (!_gateway.inboxSupported) return 0;
    final permitted = await _gateway.hasPermission();
    if (!permitted) return 0;

    try {
      final settings = await _settings.get();
      final messages = await _gateway.readSince(
        settings.smsLastScanAt,
        smsSenderAllowlist(),
      );
      var added = 0;
      for (final message in messages) {
        final result = await _ingest(message);
        if (!result.duplicate) added++;
      }
      await _settings.setSmsLastScanAt(DateTime.now());
      return added;
    } catch (_) {
      return 0;
    }
  }
}

RawSms pasteRawSms(String body, {String sender = 'paste'}) {
  return RawSms(
    sender: sender,
    body: body,
    receivedAt: DateTime.now(),
  );
}
