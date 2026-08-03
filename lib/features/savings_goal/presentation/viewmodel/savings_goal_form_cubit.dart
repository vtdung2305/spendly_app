import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:spendly_app/features/savings_goal/domain/entities/savings_goal.dart';
import 'package:spendly_app/features/savings_goal/domain/usecases/add_savings_goal_usecase.dart';
import 'package:spendly_app/features/savings_goal/domain/usecases/update_savings_goal_usecase.dart';
import 'savings_goal_form_state.dart';

class SavingsGoalFormCubit extends Cubit<SavingsGoalFormState> {
  SavingsGoalFormCubit(
    this._addSavingsGoalUseCase,
    this._updateSavingsGoalUseCase, {
    SavingsGoal? existing,
  })  : _existing = existing,
        super(existing != null
            ? SavingsGoalFormState(
                year: existing.year, targetAmount: existing.targetAmount)
            : SavingsGoalFormState(year: DateTime.now().year));

  final AddSavingsGoalUseCase _addSavingsGoalUseCase;
  final UpdateSavingsGoalUseCase _updateSavingsGoalUseCase;
  final SavingsGoal? _existing;

  bool get isEditing => _existing != null;

  void changeYear(int delta) {
    if (isEditing) return;
    final next = state.year + delta;
    if (next < DateTime.now().year) return;
    emit(state.copyWith(year: next));
  }

  void setTargetAmount(double amount) {
    emit(state.copyWith(targetAmount: amount));
  }

  Future<void> save() async {
    if (!state.isValid) return;
    emit(state.copyWith(isSaving: true, clearErrorMessage: true));

    final result = isEditing
        ? await _updateSavingsGoalUseCase(state.year, state.targetAmount)
        : await _addSavingsGoalUseCase(state.year, state.targetAmount);

    result.fold(
      (failure) =>
          emit(state.copyWith(isSaving: false, errorMessage: failure.message)),
      (_) => emit(state.copyWith(isSaving: false, saved: true)),
    );
  }
}
