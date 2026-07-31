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

  /// Only emits [CalendarLoading] on the very first load (or after an
  /// error) — once a month is already loaded, switching months (prev/next)
  /// keeps the current month on screen until the new one resolves instead
  /// of flashing to a spinner and back, which hid the header (only shown
  /// for [CalendarLoaded]) and made month navigation look like a flicker.
  Future<void> load(DateTime month) async {
    if (state is! CalendarLoaded) emit(const CalendarLoading());
    final result = await _getCalendarSummaryUseCase(month);
    result.fold(
      (failure) => emit(CalendarError(failure.message)),
      (days) => emit(CalendarLoaded(month, days)),
    );
  }

  Future<void> selectDay(int day) async {
    final current = state;
    if (current is! CalendarLoaded) return;
    // Explicitly clear the previous day's dayTransactions — otherwise a
    // stale (possibly longer) list briefly carries over under the new day's
    // selection until the fetch below resolves, which visibly grows/shrinks
    // whatever's showing it (e.g. the calendar day bottom sheet).
    emit(current.copyWith(selectedDay: day, clearDayTransactions: true));
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

  /// Returns an error message on failure, or null on success — refreshes the
  /// month summary and the selected day's transactions in place (without
  /// ever emitting [CalendarLoading]) only when the delete actually
  /// succeeded, so the day sheet never flashes a loading spinner and the
  /// deleted row disappears from its list immediately.
  Future<String?> deleteTransaction(String id) async {
    final current = state;
    if (current is! CalendarLoaded) return null;
    final day = current.selectedDay;
    final result = await _deleteTransactionUseCase(id);
    final error = result.fold((failure) => failure.message, (_) => null);
    if (error != null) return error;

    final summaryResult = await _getCalendarSummaryUseCase(current.month);
    final latest = state;
    if (latest is! CalendarLoaded) return null;
    final days = summaryResult.fold((_) => latest.days, (days) => days);

    // Optimistically drop the deleted transaction so it disappears from the
    // day sheet immediately even if the re-fetch below fails or races.
    var dayTransactions =
        latest.dayTransactions?.where((t) => t.id != id).toList();
    if (day != null) {
      final dayResult = await _getTransactionsForDayUseCase(
        DateTime(latest.month.year, latest.month.month, day),
      );
      dayTransactions = dayResult.fold(
        (_) => dayTransactions,
        (transactions) => transactions.where((t) => t.id != id).toList(),
      );
    }

    final refreshed = state;
    if (refreshed is! CalendarLoaded) return null;
    emit(CalendarLoaded(refreshed.month, days,
        selectedDay: day, dayTransactions: dayTransactions));
    return null;
  }
}
