import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../shared/components/buttons/app_button.dart';
import '../../../../shared/components/buttons/bordered_icon_button.dart';
import '../../../../shared/components/dialogs/app_snackbar.dart';
import '../../../transactions/domain/entities/transaction.dart';
import '../viewmodel/add_transaction_cubit.dart';
import '../viewmodel/add_transaction_state.dart';
import '../widgets/amount_input.dart';
import '../widgets/date_row.dart';
import '../widgets/expense_category_grid.dart';
import '../widgets/income_source_list.dart';
import '../widgets/transaction_type_segmented_control.dart';

/// Unified Add Expense/Income screen (screens 5 & 6 in the design handoff) —
/// entry point sets the default tab via [AddTransactionCubit]'s initialTab.
/// Presented as a bottom-sheet-style push (slide-up) per design.
class AddTransactionPage extends StatelessWidget {
  const AddTransactionPage({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return BlocListener<AddTransactionCubit, AddTransactionState>(
      listenWhen: (previous, current) => !previous.saved && current.saved,
      listener: (context, state) {
        Navigator.of(context).pop();
        AppSnackbar.showSuccess(
          context,
          state.type == TransactionType.expense ? 'Đã lưu khoản chi' : 'Đã lưu khoản thu',
        );
      },
      child: Scaffold(
        backgroundColor: colors.background,
        body: SafeArea(
          child: BlocBuilder<AddTransactionCubit, AddTransactionState>(
            builder: (context, state) {
              final cubit = context.read<AddTransactionCubit>();
              return Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(
                      AppSpacing.screenHorizontal, AppSpacing.mdLg, AppSpacing.screenHorizontal, 0,
                    ),
                    child: Row(
                      children: [
                        BorderedIconButton(
                          icon: Icons.close_rounded,
                          onPressed: () => Navigator.of(context).pop(),
                        ),
                        const SizedBox(width: AppSpacing.md),
                        Text('Thêm giao dịch', style: Theme.of(context).textTheme.titleMedium),
                      ],
                    ),
                  ),
                  Expanded(
                    child: ListView(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.screenHorizontal,
                      ),
                      children: [
                        const SizedBox(height: AppSpacing.lg),
                        TransactionTypeSegmentedControl(
                          selected: state.type,
                          onChanged: cubit.selectTab,
                        ),
                        const SizedBox(height: AppSpacing.lgXl),
                        _buildCategorySection(context, state, cubit),
                        const SizedBox(height: AppSpacing.xl),
                        Text('Số tiền', style: Theme.of(context).textTheme.titleSmall),
                        const SizedBox(height: AppSpacing.xs),
                        AmountInput(onChanged: cubit.setAmount),
                        const SizedBox(height: AppSpacing.smMd),
                        DateRow(date: state.date ?? DateTime.now(), onTap: () {}),
                        const SizedBox(height: AppSpacing.smMd),
                        Text('Ghi chú', style: Theme.of(context).textTheme.titleSmall),
                        const SizedBox(height: AppSpacing.xs),
                        TextField(
                          onChanged: cubit.setNote,
                          decoration: const InputDecoration(hintText: 'Thêm ghi chú (không bắt buộc)'),
                        ),
                        const SizedBox(height: AppSpacing.xl),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(
                      AppSpacing.screenHorizontal, 0, AppSpacing.screenHorizontal, AppSpacing.mdLg,
                    ),
                    child: AppButton(
                      label: 'Lưu giao dịch',
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

  Widget _buildCategorySection(
    BuildContext context,
    AddTransactionState state,
    AddTransactionCubit cubit,
  ) {
    final label = state.type == TransactionType.expense ? 'Danh mục' : 'Nguồn thu';
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: Theme.of(context).textTheme.titleSmall),
        const SizedBox(height: AppSpacing.smMd),
        if (state.type == TransactionType.expense)
          ExpenseCategoryGrid(
            selected: state.expenseCategory,
            onSelected: cubit.selectExpenseCategory,
          )
        else
          IncomeSourceList(
            selected: state.incomeSource,
            onSelected: cubit.selectIncomeSource,
          ),
      ],
    );
  }
}
