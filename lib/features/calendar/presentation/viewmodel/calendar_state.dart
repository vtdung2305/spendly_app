import 'package:equatable/equatable.dart';

import 'package:spendly_app/features/transactions/domain/entities/calendar_day.dart';
import 'package:spendly_app/features/transactions/domain/entities/transaction.dart';

sealed class CalendarState extends Equatable {
  const CalendarState();

  @override
  List<Object?> get props => [];
}

class CalendarLoading extends CalendarState {
  const CalendarLoading();
}

class CalendarLoaded extends CalendarState {
  const CalendarLoaded(this.month, this.days,
      {this.selectedDay, this.dayTransactions});

  final DateTime month;
  final List<CalendarDay> days;
  final int? selectedDay;
  final List<Transaction>? dayTransactions;

  double get totalExpense => days.fold<double>(0, (sum, d) => sum + d.amount);

  CalendarLoaded copyWith({
    int? selectedDay,
    bool clearSelection = false,
    List<Transaction>? dayTransactions,
  }) {
    return CalendarLoaded(
      month,
      days,
      selectedDay: clearSelection ? null : selectedDay ?? this.selectedDay,
      dayTransactions:
          clearSelection ? null : dayTransactions ?? this.dayTransactions,
    );
  }

  @override
  List<Object?> get props => [month, days, selectedDay, dayTransactions];
}

class CalendarError extends CalendarState {
  const CalendarError(this.message);
  final String message;

  @override
  List<Object?> get props => [message];
}
