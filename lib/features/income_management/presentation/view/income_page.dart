import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'package:spendly_app/core/localization/app_localizations_x.dart';
import 'package:spendly_app/core/theme/app_colors.dart';
import 'package:spendly_app/core/theme/app_spacing.dart';
import 'package:spendly_app/shared/components/dialogs/app_snackbar.dart';
import 'package:spendly_app/shared/components/empty/app_empty_view.dart';
import 'package:spendly_app/shared/components/error/app_error_view.dart';
import 'package:spendly_app/shared/components/list/swipe_to_delete.dart';
import 'package:spendly_app/shared/components/loading/app_loading_indicator.dart';
import 'package:spendly_app/shared/components/navigation/app_fab.dart';
import 'package:spendly_app/features/income_management/presentation/viewmodel/income_cubit.dart';
import 'package:spendly_app/features/income_management/presentation/viewmodel/income_state.dart';
import 'package:spendly_app/features/income_management/presentation/widgets/income_row.dart';
import 'package:spendly_app/features/income_management/presentation/widgets/month_chips_row.dart';
import 'package:spendly_app/features/transactions/domain/entities/transaction.dart';

class IncomePage extends StatefulWidget {
  const IncomePage({super.key});

  @override
  State<IncomePage> createState() => _IncomePageState();
}

class _IncomePageState extends State<IncomePage> {
  int _selectedMonthChip = 0;

  @override
  void initState() {
    super.initState();
    context.read<IncomeCubit>().load();
  }

  Future<void> _editTransaction(
      BuildContext context, Transaction transaction) async {
    await context.push('/add-transaction', extra: transaction);
    if (context.mounted) context.read<IncomeCubit>().load();
  }

  Future<void> _deleteTransaction(BuildContext context, String id) async {
    final error = await context.read<IncomeCubit>().delete(id);
    if (!context.mounted) return;
    if (error != null) {
      AppSnackbar.showError(context, error);
    } else {
      AppSnackbar.showSuccess(context, context.l10n.transactionDeletedSnackbar);
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.screenHorizontal),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: AppSpacing.mdLg),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(context.l10n.incomeManagementTitle,
                      style: textTheme.titleLarge),
                  InkWell(
                    onTap: () async {
                      await context.push('/add-transaction?type=income');
                      if (context.mounted) context.read<IncomeCubit>().load();
                    },
                    borderRadius: BorderRadius.circular(100),
                    child: Icon(Icons.add_circle_rounded,
                        size: 22, color: colors.primary),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.md),
              MonthChipsRow(
                selectedIndex: _selectedMonthChip,
                onSelected: (i) => setState(() => _selectedMonthChip = i),
              ),
              Expanded(
                child: RefreshIndicator(
                  onRefresh: () => context.read<IncomeCubit>().load(),
                  child: BlocBuilder<IncomeCubit, IncomeState>(
                    builder: (context, state) {
                      return switch (state) {
                        IncomeLoading() => ListView(
                            physics: const AlwaysScrollableScrollPhysics(),
                            children: const [
                              Padding(
                                padding: EdgeInsets.only(top: AppSpacing.xxl2),
                                child: AppLoadingIndicator(),
                              ),
                            ],
                          ),
                        IncomeError(:final message) => ListView(
                            physics: const AlwaysScrollableScrollPhysics(),
                            children: [
                              AppErrorView(
                                message: message,
                                onRetry: () =>
                                    context.read<IncomeCubit>().load(),
                              ),
                            ],
                          ),
                        IncomeLoaded(transactions: []) => LayoutBuilder(
                            builder: (context, constraints) => ListView(
                              physics: const AlwaysScrollableScrollPhysics(),
                              children: [
                                SizedBox(
                                  height: constraints.maxHeight,
                                  child: AppEmptyView(
                                    icon: Icons.savings_rounded,
                                    message: context
                                        .l10n.incomeManagementEmptyMessage,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        IncomeLoaded(:final transactions) => ListView(
                            padding:
                                const EdgeInsets.only(top: AppSpacing.mdLg),
                            children: [
                              for (final t in transactions) ...[
                                SwipeToDelete(
                                  itemKey: ValueKey(t.id),
                                  confirmTitle: context
                                      .l10n.transactionDeleteConfirmTitle,
                                  confirmDescription:
                                      context.l10n.feedbackKitConfirmDialogDesc,
                                  onTap: () => _editTransaction(context, t),
                                  onDelete: () =>
                                      _deleteTransaction(context, t.id),
                                  child: IncomeRow(transaction: t),
                                ),
                                const SizedBox(height: 10),
                              ],
                            ],
                          ),
                      };
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: AppFab(
        onPressed: () async {
          await context.push('/add-transaction?type=income');
          if (context.mounted) context.read<IncomeCubit>().load();
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
