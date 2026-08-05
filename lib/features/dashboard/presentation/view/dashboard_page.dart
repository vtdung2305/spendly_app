import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'package:spendly_app/core/localization/app_localizations_x.dart';
import 'package:spendly_app/core/theme/app_spacing.dart';
import 'package:spendly_app/shared/components/empty/app_empty_view.dart';
import 'package:spendly_app/shared/components/error/app_error_view.dart';
import 'package:spendly_app/shared/components/navigation/app_bottom_nav_bar.dart';
import 'package:spendly_app/shared/components/navigation/app_fab.dart';
import 'package:spendly_app/features/authentication/presentation/viewmodel/auth_cubit.dart';
import 'package:spendly_app/features/authentication/presentation/viewmodel/auth_state.dart';
import 'package:spendly_app/features/dashboard/presentation/viewmodel/dashboard_cubit.dart';
import 'package:spendly_app/features/dashboard/presentation/viewmodel/dashboard_state.dart';
import 'package:spendly_app/features/dashboard/presentation/widgets/budget_summary_card.dart';
import 'package:spendly_app/features/dashboard/presentation/widgets/category_pie_card.dart';
import 'package:spendly_app/features/dashboard/presentation/widgets/daily_spend_bar_card.dart';
import 'package:spendly_app/features/dashboard/presentation/widgets/dashboard_header.dart';
import 'package:spendly_app/features/dashboard/presentation/widgets/dashboard_loading_view.dart';
import 'package:spendly_app/features/dashboard/presentation/widgets/hero_savings_card.dart';
import 'package:spendly_app/features/dashboard/presentation/widgets/over_budget_banner.dart';
import 'package:spendly_app/features/dashboard/presentation/widgets/quick_actions_row.dart';
import 'package:spendly_app/features/dashboard/presentation/widgets/recent_transactions_section.dart';
import 'package:spendly_app/features/dashboard/presentation/widgets/savings_goal_card.dart';
import 'package:spendly_app/features/savings_goal/domain/entities/savings_goal.dart';

/// Most important screen per design handoff — hero savings, budget summary,
/// category pie, daily spend bars, recent transactions, FAB. Presentation
/// only reads [DashboardCubit] state; all aggregation happens in
/// GetDashboardSummaryUseCase.
class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  final _month = DateTime(DateTime.now().year, DateTime.now().month);

  @override
  void initState() {
    super.initState();
    context.read<DashboardCubit>().load(_month);
  }

  Future<void> _openSavingsGoal(BuildContext context, SavingsGoal goal) async {
    await context.push('/savings-goal', extra: goal);
    if (context.mounted) context.read<DashboardCubit>().load(_month);
  }

  @override
  Widget build(BuildContext context) {
    final authState = context.watch<AuthCubit>().state;
    final userName = authState is AuthAuthenticated ? authState.user.name : '';

    return Scaffold(
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () => context.read<DashboardCubit>().load(_month),
          child: BlocBuilder<DashboardCubit, DashboardState>(
            builder: (context, state) {
              return switch (state) {
                DashboardLoading() => const DashboardLoadingView(),
                DashboardError(:final message) => AppErrorView(
                    message: message,
                    onRetry: () => context.read<DashboardCubit>().load(_month),
                  ),
                DashboardLoaded(
                  :final summary,
                  :final overBudgetItem,
                  :final savingsGoal
                ) =>
                  summary.recentTransactions.isEmpty &&
                          summary.totalExpense == 0 &&
                          summary.totalIncome == 0
                      ? LayoutBuilder(
                          builder: (context, constraints) => ListView(
                            physics: const AlwaysScrollableScrollPhysics(),
                            children: [
                              SizedBox(
                                height: constraints.maxHeight,
                                child: AppEmptyView(
                                  icon: Icons.receipt_long_rounded,
                                  message: context.l10n.dashboardEmptyMessage,
                                ),
                              ),
                            ],
                          ),
                        )
                      : ListView(
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppSpacing.screenHorizontal,
                            vertical: AppSpacing.mdLg,
                          ),
                          children: [
                            DashboardHeader(
                                userName: userName,
                                monthLabel: summary.monthLabel),
                            if (overBudgetItem != null) ...[
                              const SizedBox(height: AppSpacing.mdLg),
                              OverBudgetBanner(
                                item: overBudgetItem,
                                onTap: () => context.push('/budget'),
                              ),
                            ],
                            const SizedBox(height: AppSpacing.mdLg),
                            HeroSavingsCard(
                              savings: summary.savings,
                              income: summary.totalIncome,
                              expense: summary.totalExpense,
                            ),
                            const SizedBox(height: AppSpacing.cardGap),
                            QuickActionsRow(
                              onAddExpense: () async {
                                await context.push('/add-transaction');
                                if (context.mounted) {
                                  context.read<DashboardCubit>().load(_month);
                                }
                              },
                              onAddIncome: () async {
                                await context
                                    .push('/add-transaction?type=income');
                                if (context.mounted) {
                                  context.read<DashboardCubit>().load(_month);
                                }
                              },
                              onHistory: () => context.push('/history'),
                              onReports: () => context.go('/reports'),
                            ),
                            const SizedBox(height: AppSpacing.cardGap),
                            BudgetSummaryCard(
                              usedPercent: summary.budgetUsedPercent,
                              remaining: summary.budgetRemaining,
                              onTap: () => context.push('/budget'),
                            ),
                            const SizedBox(height: AppSpacing.cardGap),
                            SavingsGoalCard(
                              title: savingsGoal.name.isNotEmpty
                                  ? savingsGoal.name
                                  : context.l10n.dashboardSavingsGoalTitle(
                                      savingsGoal.deadline.year.toString()),
                              current: savingsGoal.currentAmount,
                              goal: savingsGoal.targetAmount,
                              onTap: () =>
                                  _openSavingsGoal(context, savingsGoal),
                            ),
                            const SizedBox(height: AppSpacing.cardGap),
                            CategoryPieCard(
                              breakdown: summary.categoryBreakdown,
                              total: summary.totalExpense,
                            ),
                            const SizedBox(height: AppSpacing.cardGap),
                            DailySpendBarCard(points: summary.dailySpend),
                            const SizedBox(height: AppSpacing.cardGap),
                            RecentTransactionsSection(
                              transactions: summary.recentTransactions,
                              onSeeAll: () => context.push('/history'),
                            ),
                          ],
                        ),
              };
            },
          ),
        ),
      ),
      floatingActionButton: AppFab(
        onPressed: () async {
          await context.push('/add-transaction');
          if (context.mounted) context.read<DashboardCubit>().load(_month);
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      bottomNavigationBar: AppBottomNavBar(
        currentIndex: 0,
        onTabSelected: (index) => _handleTabSelected(context, index),
      ),
    );
  }

  void _handleTabSelected(BuildContext context, int index) {
    switch (index) {
      case 1:
        context.go('/calendar');
      case 2:
        context.go('/budget');
      case 3:
        context.go('/reports');
      case 4:
        context.go('/profile');
    }
  }
}
