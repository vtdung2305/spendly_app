import 'package:dartz/dartz.dart';

import 'package:spendly_app/core/error/failure.dart';
import 'package:spendly_app/features/budget/domain/repositories/i_budget_repository.dart';
import 'package:spendly_app/features/category_management/domain/entities/category.dart';

class DeleteBudgetUseCase {
  const DeleteBudgetUseCase(this._repository);
  final IBudgetRepository _repository;

  Future<Either<Failure, Unit>> call(Category category) =>
      _repository.deleteBudget(category);
}
