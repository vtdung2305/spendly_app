import 'package:dartz/dartz.dart';

import 'package:spendly_app/core/error/failure.dart';
import 'package:spendly_app/core/network/backend_error_mapper.dart';
import 'package:spendly_app/features/category_management/domain/entities/category.dart';
import 'package:spendly_app/features/recurring_transaction/data/datasources/backend_recurring_transaction_remote_datasource.dart';
import 'package:spendly_app/features/recurring_transaction/domain/entities/recurring_transaction.dart';
import 'package:spendly_app/features/recurring_transaction/domain/repositories/i_recurring_transaction_repository.dart';
import 'package:spendly_app/features/transactions/domain/entities/transaction.dart';

class BackendRecurringTransactionRepository
    implements IRecurringTransactionRepository {
  const BackendRecurringTransactionRepository(this._dataSource);

  final BackendRecurringTransactionRemoteDataSource _dataSource;

  @override
  Future<Either<Failure, List<RecurringTransaction>>>
      getRecurringTransactions() async {
    try {
      final rows = await _dataSource.getRecurringTransactions();
      return Right(rows.map((r) => r.toEntity()).toList());
    } catch (e) {
      return Left(mapBackendError(e));
    }
  }

  @override
  Future<Either<Failure, Unit>> addRecurringTransaction({
    required TransactionType type,
    required Category category,
    required String label,
    required double amount,
    required int dayOfMonth,
    bool isActive = true,
  }) async {
    try {
      await _dataSource.addRecurringTransaction(
        type: type,
        categoryId: category.id,
        label: label,
        amount: amount,
        dayOfMonth: dayOfMonth,
        isActive: isActive,
      );
      return const Right(unit);
    } catch (e) {
      return Left(mapBackendError(e));
    }
  }

  @override
  Future<Either<Failure, Unit>> updateRecurringTransaction(
      RecurringTransaction recurring) async {
    try {
      await _dataSource.updateRecurringTransaction(
        recurring.id,
        type: recurring.type,
        categoryId: recurring.category.id,
        label: recurring.label,
        amount: recurring.amount,
        dayOfMonth: recurring.dayOfMonth,
        isActive: recurring.isActive,
      );
      return const Right(unit);
    } catch (e) {
      return Left(mapBackendError(e));
    }
  }

  @override
  Future<Either<Failure, Unit>> deleteRecurringTransaction(String id) async {
    try {
      await _dataSource.deleteRecurringTransaction(id);
      return const Right(unit);
    } catch (e) {
      return Left(mapBackendError(e));
    }
  }
}
