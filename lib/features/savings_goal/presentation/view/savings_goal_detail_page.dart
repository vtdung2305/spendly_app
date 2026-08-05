import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import 'package:spendly_app/core/localization/app_localizations_x.dart';
import 'package:spendly_app/core/theme/app_colors.dart';
import 'package:spendly_app/core/theme/app_radius.dart';
import 'package:spendly_app/core/theme/app_shadow.dart';
import 'package:spendly_app/core/theme/app_spacing.dart';
import 'package:spendly_app/core/theme/app_typography.dart';
import 'package:spendly_app/core/utils/currency_formatter.dart';
import 'package:spendly_app/shared/components/empty/app_empty_view.dart';
import 'package:spendly_app/shared/components/error/app_error_view.dart';
import 'package:spendly_app/shared/components/headers/app_header.dart';
import 'package:spendly_app/shared/components/loading/app_loading_indicator.dart';
import 'package:spendly_app/features/savings_goal/domain/entities/savings_goal.dart';
import 'package:spendly_app/features/savings_goal/presentation/viewmodel/savings_goal_detail_cubit.dart';
import 'package:spendly_app/features/savings_goal/presentation/viewmodel/savings_goal_detail_state.dart';
import 'package:spendly_app/features/savings_goal/presentation/widgets/savings_contribution_row.dart';

/// Screen 9d — pushed from the Dashboard's savings goal card. Big progress
/// card + deadline/avg-per-month stats + per-month contribution history,
/// per design handoff.
class SavingsGoalDetailPage extends StatefulWidget {
  const SavingsGoalDetailPage({required this.goal, super.key});

  final SavingsGoal goal;

  @override
  State<SavingsGoalDetailPage> createState() => _SavingsGoalDetailPageState();
}

class _SavingsGoalDetailPageState extends State<SavingsGoalDetailPage> {
  @override
  void initState() {
    super.initState();
    context.read<SavingsGoalDetailCubit>().load(widget.goal);
  }

  Future<void> _openForm(BuildContext context, [SavingsGoal? existing]) async {
    await context.push('/savings-goal/form', extra: existing);
    if (context.mounted) {
      context.read<SavingsGoalDetailCubit>().load(widget.goal);
    }
  }

  @override
  Widget build(BuildContext context) {
    final headerHeight = MediaQuery.paddingOf(context).top + 76;

    return Scaffold(
      body: SizedBox.expand(
        child: Stack(
          children: [
            Positioned.fill(
              top: headerHeight,
              child: SafeArea(
                top: false,
                child: BlocBuilder<SavingsGoalDetailCubit,
                    SavingsGoalDetailState>(
                  builder: (context, state) {
                    return switch (state) {
                      SavingsGoalDetailLoading() =>
                        const Padding(
                          padding: EdgeInsets.only(top: AppSpacing.xxl2),
                          child: AppLoadingIndicator(),
                        ),
                      SavingsGoalDetailError(:final message) => AppErrorView(
                          message: message,
                          onRetry: () => context
                              .read<SavingsGoalDetailCubit>()
                              .load(widget.goal),
                        ),
                      SavingsGoalDetailLoaded(:final goal, :final history) =>
                        ListView(
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppSpacing.screenHorizontal,
                            vertical: AppSpacing.mdLg,
                          ),
                          children: [
                            _GoalProgressCard(
                              goal: goal,
                              onTap: () => _openForm(context, goal),
                            ),
                            const SizedBox(height: AppSpacing.smMd),
                            Row(
                              children: [
                                Expanded(
                                  child: _StatMiniCard(
                                    label: context
                                        .l10n.savingsGoalDetailDeadlineLabel,
                                    value: DateFormat('dd/MM/yyyy')
                                        .format(goal.deadline),
                                  ),
                                ),
                                const SizedBox(width: AppSpacing.sm),
                                Expanded(
                                  child: _StatMiniCard(
                                    label: context
                                        .l10n.savingsGoalDetailAvgPerMonthLabel,
                                    value: CurrencyFormatter.format(
                                        state.averagePerMonth),
                                    mono: true,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: AppSpacing.lgXl),
                            Row(
                              mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  context
                                      .l10n.savingsGoalDetailHistoryTitle,
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleSmall,
                                ),
                                Text(
                                  context.l10n.savingsGoalDetailHistoryCount(
                                      history.length.toString()),
                                  style: TextStyle(
                                      fontSize: 12,
                                      color: context.colors.textTertiary),
                                ),
                              ],
                            ),
                            const SizedBox(height: AppSpacing.smMd),
                            if (history.isEmpty)
                              Padding(
                                padding: const EdgeInsets.only(
                                    top: AppSpacing.lgXl),
                                child: AppEmptyView(
                                  icon: Icons.savings_rounded,
                                  message: context
                                      .l10n.savingsGoalDetailEmptyMessage,
                                ),
                              )
                            else
                              for (final contribution in history) ...[
                                SavingsContributionRow(
                                    contribution: contribution),
                                const SizedBox(height: AppSpacing.sm),
                              ],
                          ],
                        ),
                    };
                  },
                ),
              ),
            ),
            AppHeader(
              title: context.l10n.savingsGoalDetailPageTitle,
              titleFontSize: 18,
              onBack: () => Navigator.of(context).pop(),
              trailingIcon: Icons.add_rounded,
              onTrailingPressed: () => _openForm(context),
            ),
          ],
        ),
      ),
    );
  }
}

class _GoalProgressCard extends StatelessWidget {
  const _GoalProgressCard({required this.goal, required this.onTap});

  final SavingsGoal goal;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final percent = goal.percent.clamp(0, 100).round();
    final remaining = (goal.targetAmount - goal.currentAmount)
        .clamp(0, double.infinity)
        .toDouble();

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppRadius.hero),
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.xl),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppRadius.hero),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [colors.primary, colors.splashEnd],
          ),
          boxShadow: AppShadow.card,
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.flag_rounded, size: 22, color: Colors.white),
                const SizedBox(width: AppSpacing.sm),
                Text(
                  goal.name.isNotEmpty
                      ? goal.name
                      : context.l10n.dashboardSavingsGoalTitle(
                          goal.deadline.year.toString()),
                  style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: Colors.white),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.mdLg),
            Text(
              CurrencyFormatter.format(goal.currentAmount),
              style: AppTypography.mono(
                  fontSize: 32, fontWeight: FontWeight.w800, color: Colors.white),
            ),
            const SizedBox(height: 4),
            Text(
              context.l10n.savingsGoalDetailOfTarget(
                  CurrencyFormatter.format(goal.targetAmount)),
              style: TextStyle(
                  fontSize: 12, color: Colors.white.withValues(alpha: 0.75)),
            ),
            const SizedBox(height: AppSpacing.mdLg),
            ClipRRect(
              borderRadius: BorderRadius.circular(AppRadius.full),
              child: LinearProgressIndicator(
                value: (percent / 100).clamp(0, 1),
                minHeight: 10,
                backgroundColor: Colors.white.withValues(alpha: 0.28),
                valueColor: const AlwaysStoppedAnimation(Colors.white),
              ),
            ),
            const SizedBox(height: AppSpacing.xs),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  context.l10n
                      .savingsGoalDetailPercentComplete(percent.toString()),
                  style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: Colors.white),
                ),
                Text(
                  context.l10n.savingsGoalDetailRemaining(
                      CurrencyFormatter.format(remaining)),
                  style: TextStyle(
                      fontSize: 12, color: Colors.white.withValues(alpha: 0.8)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _StatMiniCard extends StatelessWidget {
  const _StatMiniCard(
      {required this.label, required this.value, this.mono = false});

  final String label;
  final String value;
  final bool mono;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(color: colors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label,
              style: TextStyle(fontSize: 11, color: colors.textSecondary)),
          const SizedBox(height: 4),
          Text(
            value,
            style: mono
                ? AppTypography.mono(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: colors.textPrimary)
                : TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: colors.textPrimary),
          ),
        ],
      ),
    );
  }
}
