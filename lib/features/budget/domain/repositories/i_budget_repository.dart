import 'package:dartz/dartz.dart';

import 'package:spendly_app/core/error/failure.dart';
import 'package:spendly_app/features/budget/domain/entities/budget_item.dart';
import 'package:spendly_app/features/transactions/domain/entities/expense_category.dart';

abstract class IBudgetRepository {
  Future<Either<Failure, List<BudgetItem>>> getBudgets();

  Future<Either<Failure, Unit>> addBudget(
      ExpenseCategory category, double amount);

  Future<Either<Failure, Unit>> deleteBudget(ExpenseCategory category);
}
