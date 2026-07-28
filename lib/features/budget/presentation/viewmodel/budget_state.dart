import 'package:equatable/equatable.dart';

import 'package:spendly_app/features/budget/domain/entities/budget_item.dart';

sealed class BudgetState extends Equatable {
  const BudgetState();

  @override
  List<Object?> get props => [];
}

class BudgetLoading extends BudgetState {
  const BudgetLoading();
}

class BudgetLoaded extends BudgetState {
  const BudgetLoaded(this.items);
  final List<BudgetItem> items;

  double get totalBudget =>
      items.fold<double>(0, (sum, i) => sum + i.budgetAmount);
  double get totalUsed => items.fold<double>(0, (sum, i) => sum + i.usedAmount);
  int get totalUsedPercent =>
      totalBudget == 0 ? 0 : ((totalUsed / totalBudget) * 100).round();

  @override
  List<Object?> get props => [items];
}

class BudgetError extends BudgetState {
  const BudgetError(this.message);
  final String message;

  @override
  List<Object?> get props => [message];
}
