import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../transactions/domain/usecases/get_dashboard_summary_usecase.dart';
import 'dashboard_state.dart';

class DashboardCubit extends Cubit<DashboardState> {
  DashboardCubit(this._getDashboardSummaryUseCase) : super(const DashboardLoading());

  final GetDashboardSummaryUseCase _getDashboardSummaryUseCase;

  Future<void> load(DateTime month) async {
    emit(const DashboardLoading());
    final result = await _getDashboardSummaryUseCase(month);
    result.fold(
      (failure) => emit(DashboardError(failure.message)),
      (summary) => emit(DashboardLoaded(summary)),
    );
  }
}
