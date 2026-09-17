import '../sms/sms_inbox_item.dart';
import '../sms/sms_inbox_status.dart';

abstract class SmsInboxRepository {
  Stream<List<SmsInboxItem>> watchByStatus(SmsInboxStatus status);
  Stream<int> watchReadyCount();
  Future<SmsInboxItem?> getById(int id);
  Future<SmsInboxItem?> findByFingerprint(String fingerprint);
  Future<SmsInboxItem> insert(SmsInboxInsert row);
  Future<void> markImported({required int id, required int transactionId});
  Future<void> markDismissed(int id);
}