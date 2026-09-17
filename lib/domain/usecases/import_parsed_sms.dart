import '../exceptions.dart';
import '../models/ledger_transaction.dart';
import '../models/transaction_command.dart';
import '../models/transaction_source.dart';
import '../models/transaction_type.dart';
import '../repositories/sms_inbox_repository.dart';
import '../sms/sms_inbox_status.dart';
import 'create_transaction.dart';

class ImportParsedSms {
  const ImportParsedSms(this._inbox, this._createTransaction);

  final SmsInboxRepository _inbox;
  final CreateTransaction _createTransaction;

  Future<LedgerTransaction> call({
    required int inboxId,
    required int amount,
    required TransactionType type,
    required int categoryId,
    String? note,
    required DateTime date,
  }) async {
    final item = await _inbox.getById(inboxId);
    if (item == null) throw const SmsNotFoundException();
    if (item.status == SmsInboxStatus.imported) {
      throw const SmsAlreadyImportedException();
    }

    final created = await _createTransaction(
      TransactionCommand(
        amount: amount,
        type: type,
        categoryId: categoryId,
        note: note,
        date: date,
        source: TransactionSource.sms,
      ),
    );
    await _inbox.markImported(id: inboxId, transactionId: created.id);
    return created;
  }
}
