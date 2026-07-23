import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_spacing.dart';
import '../../../../shared/components/empty/app_empty_view.dart';
import '../../../../shared/components/error/app_error_view.dart';
import '../../../../shared/components/navigation/app_bottom_nav_bar.dart';
import '../viewmodel/dashboard_cubit.dart';
import '../viewmodel/dashboard_state.dart';
import '../widgets/budget_summary_card.dart';
import '../widgets/category_pie_card.dart';
import '../widgets/daily_spend_bar_card.dart';
import '../widgets/dashboard_header.dart';
import '../widgets/dashboard_loading_view.dart';
import '../widgets/hero_savings_card.dart';
import '../widgets/recent_transactions_section.dart';

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
  @override
  void initState() {
    super.initState();
    context.read<DashboardCubit>().load(DateTime(2026, 7));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: BlocBuilder<DashboardCubit, DashboardState>(
          builder: (context, state) {
            return switch (state) {
              DashboardLoading() => const DashboardLoadingView(),
              DashboardError(:final message) => AppErrorView(
                  message: message,
                  onRetry: () => context.read<DashboardCubit>().load(DateTime(2026, 7)),
                ),
              DashboardLoaded(:final summary) => summary.recentTransactions.isEmpty &&
                      summary.totalExpense == 0 &&
                      summary.totalIncome == 0
                  ? const AppEmptyView(
                      icon: Icons.receipt_long_rounded,
                      message: 'Chưa có giao dịch nào.\nNhấn nút + để thêm giao dịch đầu tiên.',
                    )
                  : ListView(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.screenHorizontal,
                        vertical: AppSpacing.mdLg,
                      ),
                      children: [
                        DashboardHeader(userName: 'Minh Anh', monthLabel: summary.monthLabel),
                        const SizedBox(height: AppSpacing.mdLg),
                        HeroSavingsCard(
                          savings: summary.savings,
                          income: summary.totalIncome,
                          expense: summary.totalExpense,
                        ),
                        const SizedBox(height: AppSpacing.cardGap),
                        BudgetSummaryCard(
                          usedPercent: summary.budgetUsedPercent,
                          remaining: summary.budgetRemaining,
                          onTap: () => context.push('/budget'),
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
      bottomNavigationBar: AppBottomNavBar(
        currentIndex: 0,
        onTabSelected: (index) => _handleTabSelected(context, index),
        onFabPressed: () => context.push('/add-transaction'),
      ),
    );
  }

  void _handleTabSelected(BuildContext context, int index) {
    switch (index) {
      case 1:
        Navigator.of(context).pushReplacementNamed('/calendar');
      case 2:
        Navigator.of(context).pushReplacementNamed('/reports');
      case 3:
        Navigator.of(context).pushReplacementNamed('/profile');
    }
  }
}
