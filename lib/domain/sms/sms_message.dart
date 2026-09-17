class RawSms {
  const RawSms({
    required this.sender,
    required this.body,
    required this.receivedAt,
    this.platformMessageId,
  });

  final String sender;
  final String body;
  final DateTime receivedAt;
  final String? platformMessageId;
}
