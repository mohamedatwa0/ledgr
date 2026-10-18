import '../repositories/settings_repository.dart';
import '../sms/bank_message_filter.dart';
import '../sms/sms_gateway.dart';
import '../sms/sms_message.dart';
import 'ingest_sms.dart';

class ScanSmsResult {
  const ScanSmsResult({this.added = 0, this.failed = false});

  final int added;
  final bool failed;
}

class ScanSmsInbox {
  const ScanSmsInbox(this._gateway, this._settings, this._ingest);

  final SmsGateway _gateway;
  final SettingsRepository _settings;
  final IngestSms _ingest;

  Future<ScanSmsResult> call() async {
    if (!_gateway.inboxSupported) return const ScanSmsResult();
    final permitted = await _gateway.hasPermission();
    if (!permitted) return const ScanSmsResult();

    try {
      final settings = await _settings.get();
      final messages = await _gateway.readSince(
        settings.smsLastScanAt,
        smsImportSenderAllowlist(),
      );
      final queueIds = <String>[];
      var added = 0;
      DateTime? cursor;
      for (final message in messages) {
        final queueId = message.queueId;
        if (queueId != null && queueId.isNotEmpty) queueIds.add(queueId);
        if (!isBankOrWalletMessage(
            sender: message.sender, body: message.body)) {
          cursor = _later(cursor, message.receivedAt);
          continue;
        }
        final result = await _ingest(message);
        if (!result.duplicate) added++;
        cursor = _later(cursor, message.receivedAt);
      }
      if (queueIds.isNotEmpty) await _gateway.acknowledge(queueIds);
      if (cursor != null) {
        await _settings.setSmsLastScanAt(cursor);
      }
      return ScanSmsResult(added: added);
    } catch (_) {
      return const ScanSmsResult(failed: true);
    }
  }
}

DateTime _later(DateTime? current, DateTime next) {
  if (current == null || next.isAfter(current)) return next;
  return current;
}

RawSms pasteRawSms(String body, {String sender = 'paste'}) {
  return RawSms(
    sender: sender,
    body: body,
    receivedAt: DateTime.now(),
  );
}
