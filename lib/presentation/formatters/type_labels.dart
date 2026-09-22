import '../../domain/models/transaction_type.dart';
import '../../l10n/app_localizations.dart';

extension TransactionTypeUi on TransactionType {
  String ledgerLabel(AppLocalizations l10n) =>
      this == TransactionType.expense ? l10n.debit : l10n.credit;
}
