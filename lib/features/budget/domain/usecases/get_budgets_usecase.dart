import 'package:dartz/dartz.dart';

import 'package:spendly_app/core/error/failure.dart';
import 'package:spendly_app/features/budget/domain/entities/budget_item.dart';
import 'package:spendly_app/features/budget/domain/repositories/i_budget_repository.dart';

class GetBudgetsUseCase {
  const GetBudgetsUseCase(this._repository);
  final IBudgetRepository _repository;

  Future<Either<Failure, List<BudgetItem>>> call(DateTime month) =>
      _repository.getBudgets(month);
}
