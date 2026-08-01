import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

import 'package:spendly_app/core/error/failure.dart';
import 'package:spendly_app/core/network/backend_error_mapper.dart';
import 'package:spendly_app/core/network/backend_response.dart';
import 'package:spendly_app/core/utils/num_parsing.dart';
import 'package:spendly_app/features/budget/data/datasources/backend_budget_remote_datasource.dart';
import 'package:spendly_app/features/budget/domain/entities/budget_item.dart';
import 'package:spendly_app/features/budget/domain/repositories/i_budget_repository.dart';
import 'package:spendly_app/features/category_management/data/models/category_model.dart';
import 'package:spendly_app/features/category_management/domain/entities/category.dart';

class BackendBudgetRepository implements IBudgetRepository {
  const BackendBudgetRepository(this._dataSource);

  final BackendBudgetRemoteDataSource _dataSource;

  String _currentMonth() {
    final now = DateTime.now();
    return _monthString(now);
  }

  String _monthString(DateTime month) =>
      '${month.year}-${month.month.toString().padLeft(2, '0')}';

  @override
  Future<Either<Failure, List<BudgetItem>>> getBudgets(DateTime month) async {
    try {
      final rows = await _dataSource.getBudgetRows(_monthString(month));
      final items = rows.map((row) {
        final category = CategoryModel.fromBackendJson(
                row['category'] as Map<String, dynamic>)
            .toEntity();
        return BudgetItem(
          category: category,
          budgetAmount: parseNum(row['limitAmount']),
          usedAmount: parseNum(row['spentAmount']),
        );
      }).toList();
      return Right(items);
    } catch (e) {
      return Left(mapBackendError(e));
    }
  }

  /// The domain contract is "create-or-update" (matches Supabase mode's
  /// upsert semantics — `EditBudgetCubit` also calls this to change an
  /// existing budget's amount). The backend has no upsert endpoint: POST
  /// first, and on `409 BUDGET_ALREADY_EXISTS` look up that category's
  /// existing row this month and PATCH it instead.
  @override
  Future<Either<Failure, Unit>> addBudget(
      Category category, double amount) async {
    final month = _currentMonth();
    try {
      await _dataSource.createBudget(category.id, month, amount);
      return const Right(unit);
    } on DioException catch (e) {
      if (!_isBudgetAlreadyExists(e)) return Left(mapBackendError(e));
      try {
        final rows = await _dataSource.getBudgetRows(month);
        final existing = rows.firstWhere(
          (r) => (r['category'] as Map<String, dynamic>)['id'] == category.id,
        );
        await _dataSource.updateBudget(existing['id'] as String, amount);
        return const Right(unit);
      } catch (inner) {
        return Left(mapBackendError(inner));
      }
    } catch (e) {
      return Left(mapBackendError(e));
    }
  }

  @override
  Future<Either<Failure, Unit>> deleteBudget(Category category) async {
    try {
      final rows = await _dataSource.getBudgetRows(_currentMonth());
      final existing = rows.firstWhere(
        (r) => (r['category'] as Map<String, dynamic>)['id'] == category.id,
      );
      await _dataSource.deleteBudget(existing['id'] as String);
      return const Right(unit);
    } catch (e) {
      return Left(mapBackendError(e));
    }
  }

  bool _isBudgetAlreadyExists(DioException e) {
    final body = e.response?.data;
    if (body is! Map<String, dynamic>) return false;
    try {
      unwrapBackendData(body, statusCode: e.response?.statusCode);
      return false;
    } on BackendApiException catch (apiError) {
      return apiError.code == 'BUDGET_ALREADY_EXISTS';
    }
  }
}
