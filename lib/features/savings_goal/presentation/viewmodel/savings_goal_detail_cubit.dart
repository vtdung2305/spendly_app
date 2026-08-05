import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:spendly_app/features/savings_goal/domain/entities/savings_goal.dart';
import 'package:spendly_app/features/savings_goal/domain/usecases/get_savings_contribution_history_usecase.dart';
import 'package:spendly_app/features/savings_goal/domain/usecases/refresh_savings_goal_usecase.dart';
import 'savings_goal_detail_state.dart';

class SavingsGoalDetailCubit extends Cubit<SavingsGoalDetailState> {
  SavingsGoalDetailCubit(
    this._refreshSavingsGoalUseCase,
    this._getSavingsContributionHistoryUseCase,
  ) : super(const SavingsGoalDetailLoading());

  final RefreshSavingsGoalUseCase _refreshSavingsGoalUseCase;
  final GetSavingsContributionHistoryUseCase
      _getSavingsContributionHistoryUseCase;

  Future<void> load(SavingsGoal goal) async {
    emit(const SavingsGoalDetailLoading());
    final goalResult = await _refreshSavingsGoalUseCase(goal);
    final historyResult = await _getSavingsContributionHistoryUseCase(goal);
    goalResult.fold(
      (failure) => emit(SavingsGoalDetailError(failure.message)),
      (refreshed) => historyResult.fold(
        (failure) => emit(SavingsGoalDetailError(failure.message)),
        (history) => emit(SavingsGoalDetailLoaded(refreshed, history)),
      ),
    );
  }
}
