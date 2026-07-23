import 'package:dartz/dartz.dart';

import '../../../../core/error/failure.dart';
import '../entities/calendar_day.dart';
import '../repositories/i_transaction_repository.dart';

class GetCalendarSummaryUseCase {
  const GetCalendarSummaryUseCase(this._repository);
  final ITransactionRepository _repository;

  Future<Either<Failure, List<CalendarDay>>> call(DateTime month) =>
      _repository.getCalendarSummary(month);
}
