import 'package:dartz/dartz.dart';

import 'package:spendly_app/core/error/failure.dart';
import 'package:spendly_app/features/transactions/domain/repositories/i_transaction_repository.dart';

class DeleteTransactionUseCase {
  const DeleteTransactionUseCase(this._repository);
  final ITransactionRepository _repository;

  Future<Either<Failure, Unit>> call(String id) =>
      _repository.deleteTransaction(id);
}
