import 'package:dartz/dartz.dart';

import 'package:spendly_app/core/error/failure.dart';
import 'package:spendly_app/features/transactions/domain/entities/transaction.dart';
import 'package:spendly_app/features/transactions/domain/repositories/i_transaction_repository.dart';

class UpdateTransactionUseCase {
  const UpdateTransactionUseCase(this._repository);
  final ITransactionRepository _repository;

  Future<Either<Failure, Unit>> call(Transaction transaction) =>
      _repository.updateTransaction(transaction);
}
