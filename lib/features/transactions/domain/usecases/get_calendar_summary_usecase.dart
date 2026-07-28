import 'package:dartz/dartz.dart';

import 'package:spendly_app/core/error/failure.dart';
import 'package:spendly_app/features/transactions/domain/entities/calendar_day.dart';
import 'package:spendly_app/features/transactions/domain/repositories/i_transaction_repository.dart';

class GetCalendarSummaryUseCase {
  const GetCalendarSummaryUseCase(this._repository);
  final ITransactionRepository _repository;

  Future<Either<Failure, List<CalendarDay>>> call(DateTime month) =>
      _repository.getCalendarSummary(month);
}
