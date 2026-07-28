import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:spendly_app/core/localization/app_localizations_x.dart';
import 'package:spendly_app/core/theme/app_colors.dart';
import 'package:spendly_app/core/theme/app_spacing.dart';
import 'package:spendly_app/shared/components/buttons/app_button.dart';
import 'package:spendly_app/shared/components/buttons/bordered_icon_button.dart';
import 'package:spendly_app/shared/components/dialogs/app_snackbar.dart';
import 'package:spendly_app/features/add_transaction/presentation/widgets/amount_input.dart';
import 'package:spendly_app/features/add_transaction/presentation/widgets/expense_category_grid.dart';
import 'package:spendly_app/features/budget/presentation/viewmodel/add_budget_cubit.dart';
import 'package:spendly_app/features/budget/presentation/viewmodel/add_budget_state.dart';

/// Screen 9b — set a new monthly limit for a category without one yet.
/// Presented as a full-screen push (not a bottom sheet), per design handoff.
class AddBudgetPage extends StatelessWidget {
  const AddBudgetPage({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return MultiBlocListener(
      listeners: [
        BlocListener<AddBudgetCubit, AddBudgetState>(
          listenWhen: (previous, current) => !previous.saved && current.saved,
          listener: (context, state) {
            Navigator.of(context).pop();
            AppSnackbar.showSuccess(
                context, context.l10n.budgetAddSavedSnackbar);
          },
        ),
        BlocListener<AddBudgetCubit, AddBudgetState>(
          listenWhen: (previous, current) =>
              current.errorMessage != null &&
              current.errorMessage != previous.errorMessage,
          listener: (context, state) =>
              AppSnackbar.showError(context, state.errorMessage!),
        ),
      ],
      child: Scaffold(
        backgroundColor: colors.background,
        body: SafeArea(
          child: BlocBuilder<AddBudgetCubit, AddBudgetState>(
            builder: (context, state) {
              final cubit = context.read<AddBudgetCubit>();
              return Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(
                      AppSpacing.screenHorizontal,
                      AppSpacing.mdLg,
                      AppSpacing.screenHorizontal,
                      0,
                    ),
                    child: Row(
                      children: [
                        BorderedIconButton(
                          icon: Icons.close_rounded,
                          onPressed: () => Navigator.of(context).pop(),
                        ),
                        const SizedBox(width: AppSpacing.md),
                        Text(context.l10n.budgetAddPageTitle,
                            style: Theme.of(context).textTheme.titleMedium),
                      ],
                    ),
                  ),
                  Expanded(
                    child: ListView(
                      padding: const EdgeInsets.symmetric(
                          horizontal: AppSpacing.screenHorizontal),
                      children: [
                        const SizedBox(height: AppSpacing.lg),
                        Text(
                          context.l10n.budgetAddCategoryLabel,
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: colors.textSecondary,
                          ),
                        ),
                        const SizedBox(height: AppSpacing.smMd),
                        ExpenseCategoryGrid(
                          selected: state.category,
                          onSelected: cubit.selectCategory,
                        ),
                        const SizedBox(height: AppSpacing.xl),
                        Text(
                          context.l10n.budgetAddMonthlyLimitLabel,
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: colors.textSecondary,
                          ),
                        ),
                        const SizedBox(height: AppSpacing.xs),
                        AmountInput(onChanged: cubit.setAmount),
                        const SizedBox(height: AppSpacing.xl),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(
                      AppSpacing.screenHorizontal,
                      0,
                      AppSpacing.screenHorizontal,
                      AppSpacing.mdLg,
                    ),
                    child: AppButton(
                      label: context.l10n.budgetAddSaveButton,
                      isLoading: state.isSaving,
                      onPressed: state.isValid ? cubit.save : null,
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
