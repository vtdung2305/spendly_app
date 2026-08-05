import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:spendly_app/features/savings_goal/domain/entities/savings_goal.dart';
import 'package:spendly_app/features/savings_goal/domain/usecases/add_savings_goal_usecase.dart';
import 'package:spendly_app/features/savings_goal/domain/usecases/delete_savings_goal_usecase.dart';
import 'package:spendly_app/features/savings_goal/domain/usecases/update_savings_goal_usecase.dart';
import 'savings_goal_form_state.dart';

class SavingsGoalFormCubit extends Cubit<SavingsGoalFormState> {
  SavingsGoalFormCubit(
    this._addSavingsGoalUseCase,
    this._updateSavingsGoalUseCase,
    this._deleteSavingsGoalUseCase, {
    SavingsGoal? existing,
  })  : _existing = existing,
        super(existing != null
            ? SavingsGoalFormState(
                name: existing.name,
                targetAmount: existing.targetAmount,
                initialAmount: existing.initialAmount,
                deadline: existing.deadline,
              )
            : SavingsGoalFormState(
                deadline: DateTime(DateTime.now().year, 12, 31)));

  final AddSavingsGoalUseCase _addSavingsGoalUseCase;
  final UpdateSavingsGoalUseCase _updateSavingsGoalUseCase;
  final DeleteSavingsGoalUseCase _deleteSavingsGoalUseCase;
  final SavingsGoal? _existing;

  bool get isEditing => _existing != null;

  void setName(String name) {
    emit(state.copyWith(name: name));
  }

  void setTargetAmount(double amount) {
    emit(state.copyWith(targetAmount: amount));
  }

  void setInitialAmount(double amount) {
    emit(state.copyWith(initialAmount: amount));
  }

  void setDeadline(DateTime deadline) {
    emit(state.copyWith(deadline: deadline));
  }

  Future<void> save() async {
    if (!state.isValid) return;
    emit(state.copyWith(isSaving: true, clearErrorMessage: true));

    final result = isEditing
        ? await _updateSavingsGoalUseCase(SavingsGoal(
            id: _existing!.id,
            name: state.name.trim(),
            targetAmount: state.targetAmount,
            initialAmount: state.initialAmount,
            currentAmount: _existing.currentAmount,
            percent: _existing.percent,
            deadline: state.deadline,
          ))
        : await _addSavingsGoalUseCase(
            name: state.name.trim(),
            targetAmount: state.targetAmount,
            deadline: state.deadline,
            initialAmount: state.initialAmount,
          );

    result.fold(
      (failure) =>
          emit(state.copyWith(isSaving: false, errorMessage: failure.message)),
      (_) => emit(state.copyWith(isSaving: false, saved: true)),
    );
  }

  Future<void> delete() async {
    final existing = _existing;
    if (existing == null) return;
    final result = await _deleteSavingsGoalUseCase(existing);
    result.fold(
      (failure) => emit(state.copyWith(errorMessage: failure.message)),
      (_) => emit(state.copyWith(deleted: true)),
    );
  }
}
