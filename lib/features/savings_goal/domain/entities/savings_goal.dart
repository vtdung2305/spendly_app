/// The Dashboard "Mục tiêu tiết kiệm {year}" progress card's data — one
/// per-year target vs. actual net savings (income − expense from Jan 1
/// through today), matching the custom backend's `/savings-goals/:year`
/// resource. Supabase mode still stores a single year-agnostic target
/// (`profiles.savings_goal_amount`) but resolves it through this same shape.
class SavingsGoal {
  const SavingsGoal({
    required this.year,
    required this.targetAmount,
    required this.currentAmount,
    required this.percent,
  });

  final int year;
  final double targetAmount;
  final double currentAmount;
  final double percent;
}
