import 'package:dartz/dartz.dart';

import 'package:spendly_app/core/error/failure.dart';
import 'package:spendly_app/features/category_management/domain/entities/category.dart';
import 'package:spendly_app/features/recurring_transaction/domain/entities/recurring_transaction.dart';
import 'package:spendly_app/features/transactions/domain/entities/transaction.dart';

abstract class IRecurringTransactionRepository {
  Future<Either<Failure, List<RecurringTransaction>>>
      getRecurringTransactions();

  Future<Either<Failure, RecurringTransaction>> addRecurringTransaction({
    required TransactionType type,
    required Category category,
    required String label,
    required double amount,
    required int dayOfMonth,
    bool isActive = true,
  });

  Future<Either<Failure, RecurringTransaction>> updateRecurringTransaction(
      RecurringTransaction recurring);

  Future<Either<Failure, Unit>> deleteRecurringTransaction(String id);
}
