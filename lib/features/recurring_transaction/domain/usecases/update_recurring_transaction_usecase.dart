import 'package:dartz/dartz.dart';

import 'package:spendly_app/core/error/failure.dart';
import 'package:spendly_app/features/recurring_transaction/domain/entities/recurring_transaction.dart';
import 'package:spendly_app/features/recurring_transaction/domain/repositories/i_recurring_transaction_repository.dart';

class UpdateRecurringTransactionUseCase {
  const UpdateRecurringTransactionUseCase(this._repository);
  final IRecurringTransactionRepository _repository;

  Future<Either<Failure, Unit>> call(RecurringTransaction recurring) =>
      _repository.updateRecurringTransaction(recurring);
}
