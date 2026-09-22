class MonthlySummary {
  const MonthlySummary({
    required this.credits,
    required this.debits,
    required this.balance,
    this.creditCount = 0,
    this.debitCount = 0,
  });

  /// Totals in integer minor units (piasters/cents).
  final int credits;
  final int debits;
  final int balance;
  final int creditCount;
  final int debitCount;

  static const empty = MonthlySummary(credits: 0, debits: 0, balance: 0);
}
