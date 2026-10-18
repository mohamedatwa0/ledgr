import '../repositories/settings_repository.dart';
import '../repositories/sms_inbox_repository.dart';
import '../repositories/transaction_repository.dart';
import '../sms/sms_gateway.dart';

class ResetLedger {
  const ResetLedger({
    required this.transactions,
    required this.smsInbox,
    required this.settings,
    required this.sms,
  });

  final TransactionRepository transactions;
  final SmsInboxRepository smsInbox;
  final SettingsRepository settings;
  final SmsGateway sms;

  Future<void> call() async {
    await transactions.deleteAll();
    await smsInbox.deleteAll();
    await settings.clearSmsLastScanAt();
    await sms.clearPending();
  }
}
