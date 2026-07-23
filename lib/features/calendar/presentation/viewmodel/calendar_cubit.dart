import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../transactions/domain/usecases/get_calendar_summary_usecase.dart';
import 'calendar_state.dart';

class CalendarCubit extends Cubit<CalendarState> {
  CalendarCubit(this._getCalendarSummaryUseCase) : super(const CalendarLoading());

  final GetCalendarSummaryUseCase _getCalendarSummaryUseCase;

  Future<void> load(DateTime month) async {
    emit(const CalendarLoading());
    final result = await _getCalendarSummaryUseCase(month);
    result.fold(
      (failure) => emit(CalendarError(failure.message)),
      (days) => emit(CalendarLoaded(month, days)),
    );
  }

  void selectDay(int day) {
    final current = state;
    if (current is CalendarLoaded) emit(current.copyWith(selectedDay: day));
  }

  void closeDay() {
    final current = state;
    if (current is CalendarLoaded) emit(current.copyWith(clearSelection: true));
  }
}
