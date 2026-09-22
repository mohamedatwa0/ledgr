import '../repositories/sms_inbox_repository.dart';
import '../repositories/transaction_repository.dart';

class ResetLedger {
  const ResetLedger({
    required this.transactions,
    required this.smsInbox,
  });

  final TransactionRepository transactions;
  final SmsInboxRepository smsInbox;

  Future<void> call() async {
    await transactions.deleteAll();
    await smsInbox.deleteAll();
  }
}
