import 'package:dartz/dartz.dart';

import 'package:spendly_app/core/error/failure.dart';
import 'package:spendly_app/features/recurring_transaction/domain/repositories/i_recurring_transaction_repository.dart';

class DeleteRecurringTransactionUseCase {
  const DeleteRecurringTransactionUseCase(this._repository);
  final IRecurringTransactionRepository _repository;

  Future<Either<Failure, Unit>> call(String id) =>
      _repository.deleteRecurringTransaction(id);
}
