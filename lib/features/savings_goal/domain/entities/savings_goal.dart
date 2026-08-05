import 'package:equatable/equatable.dart';

/// A savings goal — matches the custom backend's `/api/v1/savings-goals`
/// resource (v3): id-keyed, one user can have several in parallel, each
/// with its own [name] and free-form [deadline] (not fixed to Dec 31).
/// Supabase mode still only stores a single year-agnostic target
/// (`profiles.savings_goal_amount`) and adapts to this same shape with a
/// fixed [id], an empty [name], and [deadline] always Dec 31 of whatever
/// year it's asked for — see `SavingsGoalRepository`.
class SavingsGoal extends Equatable {
  const SavingsGoal({
    required this.id,
    required this.name,
    required this.targetAmount,
    required this.initialAmount,
    required this.currentAmount,
    required this.percent,
    required this.deadline,
  });

  final String id;
  final String name;
  final double targetAmount;

  /// "Đã tiết kiệm" — entered once at creation, added into [currentAmount]
  /// server-side; not editable after via anything but a full update.
  final double initialAmount;
  final double currentAmount;
  final double percent;
  final DateTime deadline;

  @override
  List<Object?> get props => [
        id,
        name,
        targetAmount,
        initialAmount,
        currentAmount,
        percent,
        deadline,
      ];
}
