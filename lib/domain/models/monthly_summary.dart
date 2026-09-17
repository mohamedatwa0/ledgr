class MonthlySummary {
  const MonthlySummary({
    required this.credits,
    required this.debits,
    required this.balance,
  });

  /// Totals in integer minor units (piasters/cents).
  final int credits;
  final int debits;
  final int balance;

  static const empty = MonthlySummary(credits: 0, debits: 0, balance: 0);
}
