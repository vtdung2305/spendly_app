/// One month's net contribution (income − expense) towards a
/// [SavingsGoal] — derived from that month's transactions rather than
/// stored as its own ledger, since neither backend persists individual
/// deposits.
class SavingsContribution {
  const SavingsContribution({
    required this.year,
    required this.month,
    required this.amount,
  });

  final int year;
  final int month;
  final double amount;

  /// Last day of [month] — used for display only.
  DateTime get date => DateTime(year, month + 1, 0);
}
