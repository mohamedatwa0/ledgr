import '../models/ledger_transaction.dart';
import '../models/monthly_summary.dart';
import '../models/transaction_type.dart';

class GetMonthlySummary {
  const GetMonthlySummary();

  MonthlySummary call(List<LedgerTransaction> transactions) {
    var credits = 0;
    var debits = 0;
    var creditCount = 0;
    var debitCount = 0;
    for (final transaction in transactions) {
      if (transaction.type == TransactionType.income) {
        credits += transaction.amount;
        creditCount++;
      } else {
        debits += transaction.amount;
        debitCount++;
      }
    }
    return MonthlySummary(
      credits: credits,
      debits: debits,
      balance: credits - debits,
      creditCount: creditCount,
      debitCount: debitCount,
    );
  }
}
