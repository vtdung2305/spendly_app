import 'package:dartz/dartz.dart';

import 'package:spendly_app/core/error/failure.dart';
import 'package:spendly_app/features/budget/domain/entities/budget_item.dart';
import 'package:spendly_app/features/category_management/domain/entities/category.dart';

abstract class IBudgetRepository {
  Future<Either<Failure, List<BudgetItem>>> getBudgets(DateTime month);

  Future<Either<Failure, Unit>> addBudget(Category category, double amount);

  Future<Either<Failure, Unit>> deleteBudget(Category category);
}
