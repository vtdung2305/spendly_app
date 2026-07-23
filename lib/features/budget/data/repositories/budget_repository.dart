import 'package:dartz/dartz.dart';

import '../../../../core/error/failure.dart';
import '../../domain/entities/budget_item.dart';
import '../../domain/repositories/i_budget_repository.dart';
import '../datasources/budget_mock_datasource.dart';

class BudgetRepository implements IBudgetRepository {
  const BudgetRepository(this._dataSource);
  final BudgetMockDataSource _dataSource;

  @override
  Future<Either<Failure, List<BudgetItem>>> getBudgets() async {
    try {
      final rows = await _dataSource.getBudgets();
      return Right(rows.map((r) => r.toEntity()).toList());
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }
}
