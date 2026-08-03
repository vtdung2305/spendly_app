import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:spendly_app/features/savings_goal/domain/usecases/get_savings_contribution_history_usecase.dart';
import 'package:spendly_app/features/savings_goal/domain/usecases/get_savings_goal_usecase.dart';
import 'savings_goal_detail_state.dart';

class SavingsGoalDetailCubit extends Cubit<SavingsGoalDetailState> {
  SavingsGoalDetailCubit(
    this._getSavingsGoalUseCase,
    this._getSavingsContributionHistoryUseCase,
  ) : super(const SavingsGoalDetailLoading());

  final GetSavingsGoalUseCase _getSavingsGoalUseCase;
  final GetSavingsContributionHistoryUseCase
      _getSavingsContributionHistoryUseCase;

  Future<void> load(int year) async {
    emit(const SavingsGoalDetailLoading());
    final goalResult = await _getSavingsGoalUseCase(year);
    final historyResult = await _getSavingsContributionHistoryUseCase(year);
    goalResult.fold(
      (failure) => emit(SavingsGoalDetailError(failure.message)),
      (goal) => historyResult.fold(
        (failure) => emit(SavingsGoalDetailError(failure.message)),
        (history) => emit(SavingsGoalDetailLoaded(goal, history)),
      ),
    );
  }
}
