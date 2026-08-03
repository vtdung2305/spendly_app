import 'package:dartz/dartz.dart';

import 'package:spendly_app/core/error/failure.dart';
import 'package:spendly_app/features/category_management/domain/entities/category.dart';
import 'package:spendly_app/features/recurring_transaction/domain/entities/recurring_transaction.dart';
import 'package:spendly_app/features/recurring_transaction/domain/repositories/i_recurring_transaction_repository.dart';
import 'package:spendly_app/features/transactions/domain/entities/transaction.dart';

class AddRecurringTransactionUseCase {
  const AddRecurringTransactionUseCase(this._repository);
  final IRecurringTransactionRepository _repository;

  Future<Either<Failure, RecurringTransaction>> call({
    required TransactionType type,
    required Category category,
    required String label,
    required double amount,
    required int dayOfMonth,
    bool isActive = true,
  }) =>
      _repository.addRecurringTransaction(
        type: type,
        category: category,
        label: label,
        amount: amount,
        dayOfMonth: dayOfMonth,
        isActive: isActive,
      );
}
