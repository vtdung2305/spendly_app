import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../transactions/domain/entities/report_period.dart';
import '../../../transactions/domain/usecases/get_report_summary_usecase.dart';
import 'reports_state.dart';

class ReportsCubit extends Cubit<ReportsState> {
  ReportsCubit(this._getReportSummaryUseCase) : super(const ReportsLoading(ReportPeriod.month));

  final GetReportSummaryUseCase _getReportSummaryUseCase;

  Future<void> load(ReportPeriod period) async {
    emit(ReportsLoading(period));
    final result = await _getReportSummaryUseCase(period);
    result.fold(
      (failure) => emit(ReportsError(period, failure.message)),
      (summary) => emit(ReportsLoaded(period, summary)),
    );
  }
}
