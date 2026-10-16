import '../repositories/settings_repository.dart';
import '../sms/bank_message_filter.dart';
import '../sms/sms_gateway.dart';
import '../sms/sms_message.dart';
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
        smsImportSenderAllowlist(),
      );
      final queueIds = <String>[];
      var added = 0;
      for (final message in messages) {
        final queueId = message.queueId;
        if (queueId != null && queueId.isNotEmpty) queueIds.add(queueId);
        if (!isBankOrWalletMessage(
            sender: message.sender, body: message.body)) {
          continue;
        }
        final result = await _ingest(message);
        if (!result.duplicate) added++;
      }
      if (queueIds.isNotEmpty) await _gateway.acknowledge(queueIds);
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
