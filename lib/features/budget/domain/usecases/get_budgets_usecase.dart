import 'package:dartz/dartz.dart';

import '../../../../core/error/failure.dart';
import '../entities/budget_item.dart';
import '../repositories/i_budget_repository.dart';

class GetBudgetsUseCase {
  const GetBudgetsUseCase(this._repository);
  final IBudgetRepository _repository;

  Future<Either<Failure, List<BudgetItem>>> call() => _repository.getBudgets();
}
