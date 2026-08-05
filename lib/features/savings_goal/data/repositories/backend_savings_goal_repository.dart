import 'package:dartz/dartz.dart';

import 'package:spendly_app/core/error/failure.dart';
import 'package:spendly_app/core/network/backend_error_mapper.dart';
import 'package:spendly_app/features/savings_goal/data/datasources/backend_savings_goal_remote_datasource.dart';
import 'package:spendly_app/features/savings_goal/domain/entities/savings_contribution.dart';
import 'package:spendly_app/features/savings_goal/domain/entities/savings_goal.dart';
import 'package:spendly_app/features/savings_goal/domain/repositories/i_savings_goal_repository.dart';

class BackendSavingsGoalRepository implements ISavingsGoalRepository {
  const BackendSavingsGoalRepository(this._dataSource);

  final BackendSavingsGoalRemoteDataSource _dataSource;

  /// The Dashboard's "current" goal is whichever has the nearest deadline
  /// — the list endpoint already returns that order — [year] is unused;
  /// only Supabase mode's single year-agnostic goal needs it.
  @override
  Future<Either<Failure, SavingsGoal>> getSavingsGoal(int year) async {
    try {
      final goals = await _dataSource.getSavingsGoals();
      return Right(goals.isEmpty ? _placeholderGoal() : goals.first);
    } catch (e) {
      return Left(mapBackendError(e));
    }
  }

  @override
  Future<Either<Failure, SavingsGoal>> refreshSavingsGoal(
      SavingsGoal goal) async {
    if (goal.id.isEmpty) return getSavingsGoal(goal.deadline.year);
    try {
      return Right(await _dataSource.getSavingsGoal(goal.id));
    } catch (e) {
      return Left(mapBackendError(e));
    }
  }

  @override
  Future<Either<Failure, SavingsGoal>> addSavingsGoal({
    required String name,
    required double targetAmount,
    required DateTime deadline,
    double initialAmount = 0,
  }) async {
    try {
      return Right(await _dataSource.createSavingsGoal(
        name: name,
        targetAmount: targetAmount,
        deadline: deadline,
        initialAmount: initialAmount,
      ));
    } catch (e) {
      return Left(mapBackendError(e));
    }
  }

  @override
  Future<Either<Failure, SavingsGoal>> updateSavingsGoal(
      SavingsGoal goal) async {
    try {
      return Right(await _dataSource.updateSavingsGoal(goal));
    } catch (e) {
      return Left(mapBackendError(e));
    }
  }

  @override
  Future<Either<Failure, Unit>> deleteSavingsGoal(SavingsGoal goal) async {
    try {
      await _dataSource.deleteSavingsGoal(goal.id);
      return const Right(unit);
    } catch (e) {
      return Left(mapBackendError(e));
    }
  }

  @override
  Future<Either<Failure, List<SavingsContribution>>> getContributionHistory(
      SavingsGoal goal) async {
    // The user has no goals yet (id-less placeholder from
    // `_placeholderGoal`) — `savings-goals/` with no id would otherwise
    // hit the list endpoint instead of a detail one, returning a JSON
    // array where a map is expected.
    if (goal.id.isEmpty) return const Right([]);
    try {
      return Right(await _dataSource.getContributionHistory(goal.id));
    } catch (e) {
      return Left(mapBackendError(e));
    }
  }

  /// The user has no goals yet — a zeroed, id-less placeholder so the
  /// Dashboard card still renders something sensible.
  SavingsGoal _placeholderGoal() => SavingsGoal(
        id: '',
        name: '',
        targetAmount: 0,
        initialAmount: 0,
        currentAmount: 0,
        percent: 0,
        deadline: DateTime(DateTime.now().year, 12, 31),
      );
}
