import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:spendly_app/features/transactions/domain/usecases/delete_transaction_usecase.dart';
import 'package:spendly_app/features/transactions/domain/usecases/get_calendar_summary_usecase.dart';
import 'package:spendly_app/features/transactions/domain/usecases/get_transactions_for_day_usecase.dart';
import 'calendar_state.dart';

class CalendarCubit extends Cubit<CalendarState> {
  CalendarCubit(
    this._getCalendarSummaryUseCase,
    this._getTransactionsForDayUseCase,
    this._deleteTransactionUseCase,
  ) : super(const CalendarLoading());

  final GetCalendarSummaryUseCase _getCalendarSummaryUseCase;
  final GetTransactionsForDayUseCase _getTransactionsForDayUseCase;
  final DeleteTransactionUseCase _deleteTransactionUseCase;

  Future<void> load(DateTime month) async {
    emit(const CalendarLoading());
    final result = await _getCalendarSummaryUseCase(month);
    result.fold(
      (failure) => emit(CalendarError(failure.message)),
      (days) => emit(CalendarLoaded(month, days)),
    );
  }

  Future<void> selectDay(int day) async {
    final current = state;
    if (current is! CalendarLoaded) return;
    emit(current.copyWith(selectedDay: day));
    final result = await _getTransactionsForDayUseCase(
      DateTime(current.month.year, current.month.month, day),
    );
    final refreshed = state;
    if (refreshed is! CalendarLoaded || refreshed.selectedDay != day) return;
    result.fold(
      (failure) => null,
      (transactions) => emit(refreshed.copyWith(dayTransactions: transactions)),
    );
  }

  void closeDay() {
    final current = state;
    if (current is CalendarLoaded) emit(current.copyWith(clearSelection: true));
  }

  Future<void> deleteTransaction(String id) async {
    final current = state;
    if (current is! CalendarLoaded) return;
    final day = current.selectedDay;
    final result = await _deleteTransactionUseCase(id);
    if (result.isLeft()) return;
    await load(current.month);
    if (day != null) await selectDay(day);
  }
}
