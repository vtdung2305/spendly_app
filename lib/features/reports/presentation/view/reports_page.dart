import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'package:spendly_app/core/localization/app_localizations_x.dart';
import 'package:spendly_app/core/theme/app_colors.dart';
import 'package:spendly_app/core/theme/app_spacing.dart';
import 'package:spendly_app/core/utils/currency_formatter.dart';
import 'package:spendly_app/shared/components/error/app_error_view.dart';
import 'package:spendly_app/shared/components/loading/app_loading_indicator.dart';
import 'package:spendly_app/shared/components/navigation/app_bottom_nav_bar.dart';
import 'package:spendly_app/shared/components/navigation/app_fab.dart';
import 'package:spendly_app/features/transactions/domain/entities/report_period.dart';
import 'package:spendly_app/features/reports/presentation/viewmodel/reports_cubit.dart';
import 'package:spendly_app/features/reports/presentation/viewmodel/reports_state.dart';
import 'package:spendly_app/features/reports/presentation/widgets/report_period_tabs.dart';
import 'package:spendly_app/features/reports/presentation/widgets/report_pie_card.dart';
import 'package:spendly_app/features/reports/presentation/widgets/stat_mini_card.dart';
import 'package:spendly_app/features/reports/presentation/widgets/weekly_bar_card.dart';

class ReportsPage extends StatefulWidget {
  const ReportsPage({super.key});

  @override
  State<ReportsPage> createState() => _ReportsPageState();
}

class _ReportsPageState extends State<ReportsPage> {
  @override
  void initState() {
    super.initState();
    context.read<ReportsCubit>().load(ReportPeriod.month);
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
          child: BlocBuilder<ReportsCubit, ReportsState>(
            builder: (context, state) {
              final period = state.period;
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: AppSpacing.mdLg),
                  Text(context.l10n.reportsTitle, style: textTheme.titleLarge),
                  const SizedBox(height: AppSpacing.md),
                  ReportPeriodTabs(
                    selected: period,
                    onChanged: (p) => context.read<ReportsCubit>().load(p),
                  ),
                  Expanded(
                    child: RefreshIndicator(
                      onRefresh: () =>
                          context.read<ReportsCubit>().load(period),
                      child: switch (state) {
                        ReportsLoading() => ListView(
                            physics: const AlwaysScrollableScrollPhysics(),
                            children: const [
                              Padding(
                                padding: EdgeInsets.only(top: AppSpacing.xxl2),
                                child: AppLoadingIndicator(),
                              ),
                            ],
                          ),
                        ReportsError(:final message) => ListView(
                            physics: const AlwaysScrollableScrollPhysics(),
                            children: [
                              AppErrorView(
                                message: message,
                                onRetry: () =>
                                    context.read<ReportsCubit>().load(period),
                              ),
                            ],
                          ),
                        ReportsLoaded(:final summary) => ListView(
                            children: [
                              const SizedBox(height: AppSpacing.mdLg),
                              GridView.count(
                                crossAxisCount: 2,
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                mainAxisSpacing: AppSpacing.sm,
                                crossAxisSpacing: AppSpacing.sm,
                                childAspectRatio: 1.9,
                                children: [
                                  StatMiniCard(
                                    label: context
                                        .l10n.reportsStatTopCategoryLabel,
                                    value:
                                        summary.topCategory?.category?.label ??
                                            '—',
                                  ),
                                  StatMiniCard(
                                    label:
                                        context.l10n.reportsStatAvgPerDayLabel,
                                    value: CurrencyFormatter.format(
                                        summary.avgPerDay),
                                  ),
                                  StatMiniCard(
                                    label: context
                                        .l10n.reportsStatMaxSpendDayLabel,
                                    value: CurrencyFormatter.format(
                                        summary.maxSpendDay),
                                    valueColor: colors.danger,
                                  ),
                                  StatMiniCard(
                                    label: context
                                        .l10n.reportsStatSavingsRateLabel,
                                    value: context.l10n.percentValue(
                                        summary.savingsRatePercent.toString()),
                                    valueColor: colors.success,
                                  ),
                                ],
                              ),
                              const SizedBox(height: AppSpacing.cardGap),
                              ReportPieCard(
                                  breakdown: summary.categoryBreakdown),
                              const SizedBox(height: AppSpacing.cardGap),
                              WeeklyBarCard(bars: summary.weekBars),
                            ],
                          ),
                      },
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
      floatingActionButton: AppFab(
        onPressed: () async {
          final cubit = context.read<ReportsCubit>();
          await context.push('/add-transaction');
          if (context.mounted) cubit.load(cubit.state.period);
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      bottomNavigationBar: AppBottomNavBar(
        currentIndex: 3,
        onTabSelected: (index) => _handleTabSelected(context, index),
      ),
    );
  }

  void _handleTabSelected(BuildContext context, int index) {
    switch (index) {
      case 0:
        context.go('/dashboard');
      case 1:
        context.go('/calendar');
      case 2:
        context.go('/budget');
      case 4:
        context.go('/profile');
    }
  }
}
