import 'package:equatable/equatable.dart';

import '../../../transactions/domain/entities/calendar_day.dart';

sealed class CalendarState extends Equatable {
  const CalendarState();

  @override
  List<Object?> get props => [];
}

class CalendarLoading extends CalendarState {
  const CalendarLoading();
}

class CalendarLoaded extends CalendarState {
  const CalendarLoaded(this.month, this.days, {this.selectedDay});

  final DateTime month;
  final List<CalendarDay> days;
  final int? selectedDay;

  double get totalExpense => days.fold<double>(0, (sum, d) => sum + d.amount);

  CalendarLoaded copyWith({int? selectedDay, bool clearSelection = false}) {
    return CalendarLoaded(
      month,
      days,
      selectedDay: clearSelection ? null : selectedDay ?? this.selectedDay,
    );
  }

  @override
  List<Object?> get props => [month, days, selectedDay];
}

class CalendarError extends CalendarState {
  const CalendarError(this.message);
  final String message;

  @override
  List<Object?> get props => [message];
}
