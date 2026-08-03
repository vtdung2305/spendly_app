import 'package:dartz/dartz.dart';

import 'package:spendly_app/core/error/failure.dart';
import 'package:spendly_app/features/savings_goal/domain/entities/savings_contribution.dart';
import 'package:spendly_app/features/savings_goal/domain/repositories/i_savings_goal_repository.dart';

class GetSavingsContributionHistoryUseCase {
  const GetSavingsContributionHistoryUseCase(this._repository);
  final ISavingsGoalRepository _repository;

  Future<Either<Failure, List<SavingsContribution>>> call(int year) =>
      _repository.getContributionHistory(year);
}
