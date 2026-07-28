import 'package:dartz/dartz.dart';

import 'package:spendly_app/core/error/failure.dart';
import 'package:spendly_app/features/transactions/domain/entities/transaction.dart';
import 'package:spendly_app/features/transactions/domain/repositories/i_transaction_repository.dart';

class AddTransactionUseCase {
  const AddTransactionUseCase(this._repository);
  final ITransactionRepository _repository;

  Future<Either<Failure, Transaction>> call(Transaction transaction) {
    if (transaction.amount <= 0) {
      return Future.value(
          const Left(ValidationFailure('Số tiền phải lớn hơn 0')));
    }
    return _repository.addTransaction(transaction);
  }
}
