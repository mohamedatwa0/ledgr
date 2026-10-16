class RawSms {
  const RawSms({
    required this.sender,
    required this.body,
    required this.receivedAt,
    this.platformMessageId,
    this.queueId,
  });

  final String sender;
  final String body;
  final DateTime receivedAt;
  final String? platformMessageId;

  /// Id in the on-device import queue. Not part of the fingerprint.
  final String? queueId;
}

/// Posted on the share channel when queued bank messages are ready to import.
const kSmsImportSignal = '__ledgr_scan__';
