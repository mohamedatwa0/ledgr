import '../../domain/sms/sms_gateway.dart';
import '../../domain/sms/sms_message.dart';

class NoOpSmsGateway implements SmsGateway {
  const NoOpSmsGateway();

  @override
  bool get inboxSupported => false;

  @override
  Future<bool> hasPermission() async => false;

  @override
  Future<bool> requestPermission() async => false;

  @override
  Future<List<RawSms>> readSince(DateTime? since, Set<String> senders) async {
    return const [];
  }

  @override
  Stream<RawSms> get incoming => const Stream.empty();

  @override
  Stream<String> get sharedText => const Stream.empty();

  @override
  Future<String?> takeInitialSharedText() async => null;
}
