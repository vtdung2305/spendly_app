import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'package:spendly_app/core/localization/app_localizations_x.dart';
import 'package:spendly_app/core/theme/app_colors.dart';
import 'package:spendly_app/core/theme/app_radius.dart';
import 'package:spendly_app/core/theme/app_spacing.dart';
import 'package:spendly_app/core/utils/currency_formatter.dart';
import 'package:spendly_app/shared/components/empty/app_empty_view.dart';
import 'package:spendly_app/shared/components/error/app_error_view.dart';
import 'package:spendly_app/shared/components/headers/app_header.dart';
import 'package:spendly_app/shared/components/loading/app_loading_indicator.dart';
import 'package:spendly_app/shared/components/navigation/app_bottom_nav_bar.dart';
import 'package:spendly_app/shared/components/navigation/app_fab.dart';
import 'package:spendly_app/features/budget/domain/entities/budget_item.dart';
import 'package:spendly_app/features/budget/presentation/viewmodel/budget_cubit.dart';
import 'package:spendly_app/features/budget/presentation/viewmodel/budget_state.dart';
import 'package:spendly_app/features/budget/presentation/widgets/budget_item_card.dart';

/// Screen 9 — no back arrow in the design (reached via Dashboard's budget
/// row or Profile menu; the platform back gesture/button returns).
class BudgetPage extends StatefulWidget {
  const BudgetPage({super.key});

  @override
  State<BudgetPage> createState() => _BudgetPageState();
}

class _BudgetPageState extends State<BudgetPage> {
  DateTime _currentMonth = DateTime(DateTime.now().year, DateTime.now().month);

  @override
  void initState() {
    super.initState();
    context.read<BudgetCubit>().load(_currentMonth);
  }

  void _changeMonth(int delta) {
    setState(() => _currentMonth =
        DateTime(_currentMonth.year, _currentMonth.month + delta));
    context.read<BudgetCubit>().load(_currentMonth);
  }

  Future<void> _editBudget(BuildContext context, BudgetItem item) async {
    await context.push('/edit-budget', extra: item);
    if (context.mounted) context.read<BudgetCubit>().load(_currentMonth);
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final textTheme = Theme.of(context).textTheme;
    // Header has leading spacer + trailing icon (44px row), taller than a
    // title-only header.
    final headerHeight = MediaQuery.paddingOf(context).top + 76;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Scaffold(
        body: SizedBox.expand(
          child: Stack(
            children: [
              Positioned.fill(
                top: headerHeight,
                child: SafeArea(
                  top: false,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(
                        AppSpacing.screenHorizontal,
                        AppSpacing.sm,
                        AppSpacing.screenHorizontal,
                        0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _MonthSelector(
                          month: _currentMonth,
                          onPrevMonth: () => _changeMonth(-1),
                          onNextMonth: () => _changeMonth(1),
                        ),
                        const SizedBox(height: AppSpacing.mdLg),
                        Expanded(
                          child: RefreshIndicator(
                            onRefresh: () =>
                                context.read<BudgetCubit>().load(_currentMonth),
                            child: BlocBuilder<BudgetCubit, BudgetState>(
                              builder: (context, state) {
                                return switch (state) {
                                  BudgetLoading() => ListView(
                                      padding: EdgeInsets.zero,
                                      physics:
                                          const AlwaysScrollableScrollPhysics(),
                                      children: const [
                                        Padding(
                                          padding: EdgeInsets.only(
                                              top: AppSpacing.xxl2),
                                          child: AppLoadingIndicator(),
                                        ),
                                      ],
                                    ),
                                  BudgetError(:final message) => ListView(
                                      padding: EdgeInsets.zero,
                                      physics:
                                          const AlwaysScrollableScrollPhysics(),
                                      children: [
                                        AppErrorView(
                                          message: message,
                                          onRetry: () => context
                                              .read<BudgetCubit>()
                                              .load(_currentMonth),
                                        ),
                                      ],
                                    ),
                                  BudgetLoaded(items: []) => LayoutBuilder(
                                      builder: (context, constraints) =>
                                          ListView(
                                        padding: EdgeInsets.zero,
                                        physics:
                                            const AlwaysScrollableScrollPhysics(),
                                        children: [
                                          SizedBox(
                                            height: constraints.maxHeight,
                                            child: AppEmptyView(
                                              icon: Icons
                                                  .account_balance_wallet_rounded,
                                              message: context
                                                  .l10n.budgetEmptyMessage,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  BudgetLoaded(
                                    :final items,
                                    :final totalBudget,
                                    :final totalUsedPercent
                                  ) =>
                                    ListView(
                                      padding: EdgeInsets.zero,
                                      children: [
                                        const SizedBox(height: 2),
                                        Text(
                                          context.l10n.budgetSummaryLine(
                                            CurrencyFormatter.format(
                                                totalBudget),
                                            totalUsedPercent.toString(),
                                          ),
                                          style: textTheme.bodySmall?.copyWith(
                                              color: colors.textSecondary),
                                        ),
                                        const SizedBox(
                                            height: AppSpacing.mdLg),
                                        for (final item in items) ...[
                                          BudgetItemCard(
                                            item: item,
                                            onTap: () =>
                                                _editBudget(context, item),
                                          ),
                                          const SizedBox(
                                              height: AppSpacing.smMd),
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
              ),
              AppHeader(
                title: context.l10n.budgetPageTitle,
                titleFontSize: 20,
                showLeadingSpacer: true,
                trailingIcon: Icons.add_rounded,
                onTrailingPressed: () async {
                  await context.push('/add-budget');
                  if (context.mounted) {
                    context.read<BudgetCubit>().load(_currentMonth);
                  }
                },
              ),
            ],
          ),
        ),
        floatingActionButton: AppFab(
          onPressed: () async {
            await context.push('/add-transaction');
            if (context.mounted) {
              context.read<BudgetCubit>().load(_currentMonth);
            }
          },
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
        bottomNavigationBar: AppBottomNavBar(
          currentIndex: 2,
          onTabSelected: (index) => _handleTabSelected(context, index),
        ),
      ),
    );
  }

  void _handleTabSelected(BuildContext context, int index) {
    switch (index) {
      case 0:
        context.go('/dashboard');
      case 1:
        context.go('/calendar');
      case 3:
        context.go('/reports');
      case 4:
        context.go('/profile');
    }
  }
}

class _MonthSelector extends StatelessWidget {
  const _MonthSelector({
    required this.month,
    required this.onPrevMonth,
    required this.onNextMonth,
  });

  final DateTime month;
  final VoidCallback onPrevMonth;
  final VoidCallback onNextMonth;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _MonthNavButton(icon: Icons.chevron_left_rounded, onTap: onPrevMonth),
        const SizedBox(width: AppSpacing.xs),
        SizedBox(
          width: 120,
          child: Text(
            context.l10n
                .monthYearHeader(month.month.toString(), month.year.toString()),
            textAlign: TextAlign.center,
            style: Theme.of(context)
                .textTheme
                .titleSmall
                ?.copyWith(color: colors.textPrimary, fontWeight: FontWeight.w800),
          ),
        ),
        const SizedBox(width: AppSpacing.xs),
        _MonthNavButton(icon: Icons.chevron_right_rounded, onTap: onNextMonth),
      ],
    );
  }
}

class _MonthNavButton extends StatelessWidget {
  const _MonthNavButton({required this.icon, required this.onTap});

  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return SizedBox(
      height: 34,
      width: 34,
      child: Material(
        color: colors.surfaceAlt,
        borderRadius: BorderRadius.circular(AppRadius.sm),
        child: InkWell(
          borderRadius: BorderRadius.circular(AppRadius.sm),
          onTap: onTap,
          child: Icon(icon, size: 18, color: colors.textPrimary),
        ),
      ),
    );
  }
}
