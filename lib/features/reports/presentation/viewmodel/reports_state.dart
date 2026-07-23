import 'package:equatable/equatable.dart';

import '../../../transactions/domain/entities/report_period.dart';
import '../../../transactions/domain/entities/report_summary.dart';

sealed class ReportsState extends Equatable {
  const ReportsState();

  ReportPeriod get period;

  @override
  List<Object?> get props => [];
}

class ReportsLoading extends ReportsState {
  const ReportsLoading(this.period);
  @override
  final ReportPeriod period;

  @override
  List<Object?> get props => [period];
}

class ReportsLoaded extends ReportsState {
  const ReportsLoaded(this.period, this.summary);
  @override
  final ReportPeriod period;
  final ReportSummary summary;

  @override
  List<Object?> get props => [period, summary];
}

class ReportsError extends ReportsState {
  const ReportsError(this.period, this.message);
  @override
  final ReportPeriod period;
  final String message;

  @override
  List<Object?> get props => [period, message];
}
