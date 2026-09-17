import '../exceptions.dart';
import '../repositories/sms_inbox_repository.dart';

class DismissSms {
  const DismissSms(this._inbox);

  final SmsInboxRepository _inbox;

  Future<void> call(int inboxId) async {
    final item = await _inbox.getById(inboxId);
    if (item == null) throw const SmsNotFoundException();
    await _inbox.markDismissed(inboxId);
  }
}
