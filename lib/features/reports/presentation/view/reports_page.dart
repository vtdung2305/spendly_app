import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/utils/currency_formatter.dart';
import '../../../../shared/components/error/app_error_view.dart';
import '../../../../shared/components/loading/app_loading_indicator.dart';
import '../../../../shared/components/navigation/app_bottom_nav_bar.dart';
import '../../../transactions/domain/entities/report_period.dart';
import '../viewmodel/reports_cubit.dart';
import '../viewmodel/reports_state.dart';
import '../widgets/report_period_tabs.dart';
import '../widgets/report_pie_card.dart';
import '../widgets/stat_mini_card.dart';
import '../widgets/weekly_bar_card.dart';

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
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.screenHorizontal),
          child: BlocBuilder<ReportsCubit, ReportsState>(
            builder: (context, state) {
              final period = state.period;
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: AppSpacing.mdLg),
                  Text('Báo cáo', style: textTheme.titleLarge),
                  const SizedBox(height: AppSpacing.md),
                  ReportPeriodTabs(
                    selected: period,
                    onChanged: (p) => context.read<ReportsCubit>().load(p),
                  ),
                  Expanded(
                    child: switch (state) {
                      ReportsLoading() => const AppLoadingIndicator(),
                      ReportsError(:final message) => AppErrorView(
                          message: message,
                          onRetry: () => context.read<ReportsCubit>().load(period),
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
                                StatMiniCard(label: 'Top danh mục', value: summary.topCategoryLabel),
                                StatMiniCard(
                                  label: 'TB mỗi ngày',
                                  value: CurrencyFormatter.format(summary.avgPerDay),
                                ),
                                StatMiniCard(
                                  label: 'Ngày chi nhiều nhất',
                                  value: CurrencyFormatter.format(summary.maxSpendDay),
                                  valueColor: colors.danger,
                                ),
                                StatMiniCard(
                                  label: 'Tỷ lệ tiết kiệm',
                                  value: '${summary.savingsRatePercent}%',
                                  valueColor: colors.success,
                                ),
                              ],
                            ),
                            const SizedBox(height: AppSpacing.cardGap),
                            ReportPieCard(breakdown: summary.categoryBreakdown),
                            const SizedBox(height: AppSpacing.cardGap),
                            WeeklyBarCard(bars: summary.weekBars),
                          ],
                        ),
                    },
                  ),
                ],
              );
            },
          ),
        ),
      ),
      bottomNavigationBar: AppBottomNavBar(
        currentIndex: 2,
        onTabSelected: (index) => _handleTabSelected(context, index),
        onFabPressed: () => Navigator.of(context).pushNamed('/add-transaction'),
      ),
    );
  }

  void _handleTabSelected(BuildContext context, int index) {
    switch (index) {
      case 0:
        Navigator.of(context).pushReplacementNamed('/dashboard');
      case 1:
        Navigator.of(context).pushReplacementNamed('/calendar');
      case 3:
        Navigator.of(context).pushReplacementNamed('/profile');
    }
  }
}
