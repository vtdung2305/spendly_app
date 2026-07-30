import 'package:dartz/dartz.dart';

import 'package:spendly_app/core/error/failure.dart';
import 'package:spendly_app/core/network/backend_error_mapper.dart';
import 'package:spendly_app/features/savings_goal/data/datasources/backend_savings_goal_remote_datasource.dart';
import 'package:spendly_app/features/savings_goal/domain/entities/savings_goal.dart';
import 'package:spendly_app/features/savings_goal/domain/repositories/i_savings_goal_repository.dart';

class BackendSavingsGoalRepository implements ISavingsGoalRepository {
  const BackendSavingsGoalRepository(this._dataSource);

  final BackendSavingsGoalRemoteDataSource _dataSource;

  @override
  Future<Either<Failure, SavingsGoal>> getSavingsGoal(int year) async {
    try {
      return Right(await _dataSource.getSavingsGoal(year));
    } catch (e) {
      return Left(mapBackendError(e));
    }
  }

  @override
  Future<Either<Failure, SavingsGoal>> updateSavingsGoal(
      int year, double targetAmount) async {
    try {
      return Right(await _dataSource.updateSavingsGoal(year, targetAmount));
    } catch (e) {
      return Left(mapBackendError(e));
    }
  }
}
