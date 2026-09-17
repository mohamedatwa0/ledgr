import '../sms/sms_message.dart';

abstract class SmsGateway {
  bool get inboxSupported;

  Future<bool> hasPermission();

  Future<bool> requestPermission();

  Future<List<RawSms>> readSince(DateTime? since, Set<String> senders);

  Stream<RawSms> get incoming;

  Stream<String> get sharedText;

  Future<String?> takeInitialSharedText();
}