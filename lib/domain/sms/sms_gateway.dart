import '../sms/sms_message.dart';

abstract class SmsGateway {
  bool get inboxSupported;

  /// iPhone import is share and Shortcuts, not an inbox scan.
  bool get shareImport;

  Future<bool> hasPermission();

  Future<bool> requestPermission();

  Future<List<RawSms>> readSince(DateTime? since, Set<String> senders);

  Future<void> acknowledge(List<String> queueIds);

  Future<bool> openImportSetup();

  Stream<RawSms> get incoming;

  Stream<String> get sharedText;

  Future<String?> takeInitialSharedText();
}
