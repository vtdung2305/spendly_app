import 'package:dartz/dartz.dart';

import 'package:spendly_app/core/error/failure.dart';
import 'package:spendly_app/features/budget/domain/repositories/i_budget_repository.dart';
import 'package:spendly_app/features/transactions/domain/entities/expense_category.dart';

class AddBudgetUseCase {
  const AddBudgetUseCase(this._repository);
  final IBudgetRepository _repository;

  Future<Either<Failure, Unit>> call(ExpenseCategory category, double amount) {
    if (amount <= 0) {
      return Future.value(
          const Left(ValidationFailure('Hạn mức phải lớn hơn 0')));
    }
    return _repository.addBudget(category, amount);
  }
}
