import 'package:dartz/dartz.dart';

import 'package:spendly_app/core/error/failure.dart';
import 'package:spendly_app/features/budget/domain/repositories/i_budget_repository.dart';
import 'package:spendly_app/features/transactions/domain/entities/expense_category.dart';

class DeleteBudgetUseCase {
  const DeleteBudgetUseCase(this._repository);
  final IBudgetRepository _repository;

  Future<Either<Failure, Unit>> call(ExpenseCategory category) =>
      _repository.deleteBudget(category);
}
