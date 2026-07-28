import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'package:spendly_app/core/localization/app_localizations_x.dart';
import 'package:spendly_app/core/localization/weekday_labels.dart';
import 'package:spendly_app/core/theme/app_colors.dart';
import 'package:spendly_app/core/theme/app_radius.dart';
import 'package:spendly_app/core/theme/app_shadow.dart';
import 'package:spendly_app/core/theme/app_spacing.dart';
import 'package:spendly_app/core/theme/app_typography.dart';
import 'package:spendly_app/core/utils/currency_formatter.dart';
import 'package:spendly_app/shared/components/error/app_error_view.dart';
import 'package:spendly_app/shared/components/loading/app_loading_indicator.dart';
import 'package:spendly_app/shared/components/navigation/app_bottom_nav_bar.dart';
import 'package:spendly_app/shared/components/navigation/app_fab.dart';
import 'package:spendly_app/features/calendar/presentation/mappers/calendar_day_ui.dart';
import 'package:spendly_app/features/calendar/presentation/viewmodel/calendar_cubit.dart';
import 'package:spendly_app/features/calendar/presentation/viewmodel/calendar_state.dart';
import 'package:spendly_app/features/calendar/presentation/widgets/day_transactions_sheet.dart';
import 'package:spendly_app/features/transactions/domain/entities/calendar_day.dart';

class CalendarPage extends StatefulWidget {
  const CalendarPage({super.key});

  @override
  State<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  DateTime _currentMonth = DateTime(2026, 7);

  @override
  void initState() {
    super.initState();
    context.read<CalendarCubit>().load(_currentMonth);
  }

  void _changeMonth(int delta) {
    setState(() => _currentMonth =
        DateTime(_currentMonth.year, _currentMonth.month + delta));
    context.read<CalendarCubit>().load(_currentMonth);
  }

  void _openDay(BuildContext context, int day, int month, int year) {
    final cubit = context.read<CalendarCubit>();
    cubit.selectDay(day);
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => BlocProvider.value(
        value: cubit,
        child: DayTransactionsSheet(day: day, month: month, year: year),
      ),
    ).then((_) => cubit.closeDay());
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
          child: RefreshIndicator(
            onRefresh: () => context.read<CalendarCubit>().load(_currentMonth),
            child: BlocBuilder<CalendarCubit, CalendarState>(
              builder: (context, state) {
                return switch (state) {
                  CalendarLoading() => ListView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      children: const [
                        Padding(
                          padding: EdgeInsets.only(top: AppSpacing.xxl2),
                          child: AppLoadingIndicator(),
                        ),
                      ],
                    ),
                  CalendarError(:final message) => ListView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      children: [
                        AppErrorView(
                          message: message,
                          onRetry: () =>
                              context.read<CalendarCubit>().load(_currentMonth),
                        ),
                      ],
                    ),
                  CalendarLoaded(
                    :final month,
                    :final days,
                    :final totalExpense
                  ) =>
                    SingleChildScrollView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: AppSpacing.mdLg),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              _MonthNavButton(
                                icon: Icons.chevron_left_rounded,
                                onTap: () => _changeMonth(-1),
                              ),
                              Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    context.l10n.monthYearHeader(
                                        month.month.toString(),
                                        month.year.toString()),
                                    style: textTheme.titleLarge,
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    context.l10n.calendarTotalExpenseLabel(
                                        CurrencyFormatter.format(totalExpense)),
                                    style: AppTypography.mono(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w400,
                                        color: colors.textSecondary),
                                  ),
                                ],
                              ),
                              _MonthNavButton(
                                icon: Icons.chevron_right_rounded,
                                onTap: () => _changeMonth(1),
                              ),
                            ],
                          ),
                          const SizedBox(height: AppSpacing.lg),
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 16),
                            decoration: BoxDecoration(
                              color: colors.surface,
                              borderRadius:
                                  BorderRadius.circular(AppRadius.card),
                              border: Border.all(color: colors.border),
                              boxShadow: AppShadow.card,
                            ),
                            child: Column(
                              children: [
                                GridView.count(
                                  crossAxisCount: 7,
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  mainAxisSpacing: 6,
                                  crossAxisSpacing: 6,
                                  children: [
                                    for (final label in weekdayLabels(context))
                                      Center(
                                        child: Text(
                                          label,
                                          style: textTheme.labelSmall?.copyWith(
                                              fontWeight: FontWeight.w700,
                                              color: colors.textTertiary),
                                        ),
                                      ),
                                    for (var i = 0;
                                        i < _leadingBlanks(month);
                                        i++)
                                      const SizedBox.shrink(),
                                    for (final day in days)
                                      _DayCell(
                                        day: day.day,
                                        amount: day.amount,
                                        isToday: _isToday(month, day.day),
                                        onTap: () => _openDay(context, day.day,
                                            month.month, month.year),
                                      ),
                                  ],
                                ),
                                Container(
                                  width: double.infinity,
                                  margin: const EdgeInsets.only(top: 16),
                                  padding: const EdgeInsets.only(top: 14),
                                  decoration: BoxDecoration(
                                    border: Border(
                                        top: BorderSide(color: colors.border)),
                                  ),
                                  child: Wrap(
                                    spacing: 16,
                                    runSpacing: 8,
                                    children: [
                                      _LegendDot(
                                        color: colors.danger,
                                        label: context
                                            .l10n.calendarLegendHighSpend,
                                      ),
                                      _LegendDot(
                                        color: colors.primary,
                                        label:
                                            context.l10n.calendarLegendMidSpend,
                                      ),
                                      _LegendDot(
                                        color: colors.success,
                                        label:
                                            context.l10n.calendarLegendLowSpend,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: AppSpacing.md),
                          _CalendarStatsSection(month: month, days: days),
                        ],
                      ),
                    ),
                };
              },
            ),
          ),
        ),
      ),
      floatingActionButton: AppFab(
        onPressed: () async {
          await context.push('/add-transaction');
          if (context.mounted) {
            context.read<CalendarCubit>().load(_currentMonth);
          }
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      bottomNavigationBar: AppBottomNavBar(
        currentIndex: 1,
        onTabSelected: (index) => _handleTabSelected(context, index),
      ),
    );
  }

  void _handleTabSelected(BuildContext context, int index) {
    switch (index) {
      case 0:
        context.go('/dashboard');
      case 2:
        context.go('/budget');
      case 3:
        context.go('/reports');
      case 4:
        context.go('/profile');
    }
  }

  int _leadingBlanks(DateTime month) =>
      DateTime(month.year, month.month).weekday - 1;

  bool _isToday(DateTime month, int day) {
    final now = DateTime.now();
    return now.year == month.year && now.month == month.month && now.day == day;
  }
}

class _DayCell extends StatelessWidget {
  const _DayCell({
    required this.day,
    required this.amount,
    required this.onTap,
    this.isToday = false,
  });

  final int day;
  final double amount;
  final VoidCallback onTap;
  final bool isToday;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final tone = calendarDayTone(amount);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppRadius.sm),
      child: Container(
        decoration: BoxDecoration(
          color: tone.background(colors),
          borderRadius: BorderRadius.circular(AppRadius.sm),
          border: isToday ? Border.all(color: colors.primary, width: 2) : null,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '$day',
              style: Theme.of(context).textTheme.labelMedium?.copyWith(
                  fontSize: 12.5,
                  fontWeight: FontWeight.w700,
                  color: tone.foreground(colors)),
            ),
            Text(
              amount > 0 ? CurrencyFormatter.formatCompact(amount) : '—',
              style: AppTypography.mono(
                  fontSize: 8.5,
                  fontWeight: FontWeight.w600,
                  color: tone.foreground(colors)),
            ),
          ],
        ),
      ),
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

    return Material(
      color: colors.surfaceAlt,
      borderRadius: BorderRadius.circular(10),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10),
        child: SizedBox(
          height: 36,
          width: 36,
          child: Icon(icon, size: 18, color: colors.textPrimary),
        ),
      ),
    );
  }
}

class _CalendarStatsSection extends StatelessWidget {
  const _CalendarStatsSection({required this.month, required this.days});

  final DateTime month;
  final List<CalendarDay> days;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final spentDays = days.where((d) => d.amount > 0).toList()
      ..sort((a, b) => b.amount.compareTo(a.amount));
    final totalExpense = days.fold<double>(0, (sum, d) => sum + d.amount);
    final avgPerDay = days.isEmpty ? 0.0 : totalExpense / days.length;
    final maxDay = spentDays.isNotEmpty ? spentDays.first : null;
    final topDays = spentDays.take(3).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: _MiniStatCard(
                label: context.l10n.calendarAvgPerDayLabel,
                value: '${CurrencyFormatter.formatCompact(avgPerDay)} ₫',
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: _MiniStatCard(
                label: context.l10n.calendarMaxSpendDayLabel,
                value: maxDay == null
                    ? '—'
                    : context.l10n.calendarMaxSpendDayValue(
                        maxDay.day.toString(),
                        '${CurrencyFormatter.formatCompact(maxDay.amount)} ₫',
                      ),
                valueColor: maxDay == null ? null : colors.danger,
              ),
            ),
          ],
        ),
        if (topDays.isNotEmpty) ...[
          Padding(
            padding: const EdgeInsets.fromLTRB(4, 20, 4, 8),
            child: Text(
              context.l10n.calendarTopSpendingDaysTitle,
              style: AppTypography.mono(
                fontSize: 10.5,
                fontWeight: FontWeight.w600,
                color: colors.textTertiary,
                letterSpacing: 0.06 * 10.5,
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
            decoration: BoxDecoration(
              color: colors.surface,
              borderRadius: BorderRadius.circular(AppRadius.card),
              border: Border.all(color: colors.border),
              boxShadow: AppShadow.card,
            ),
            child: Column(
              children: [
                for (var i = 0; i < topDays.length; i++)
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      border: i > 0
                          ? Border(top: BorderSide(color: colors.border))
                          : null,
                    ),
                    child: Row(
                      children: [
                        Container(
                          height: 26,
                          width: 26,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: colors.dangerTint,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            '${i + 1}',
                            style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w800,
                                color: colors.danger),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            context.l10n.calendarTopSpendingDayLabel(
                              topDays[i].day.toString(),
                              month.month.toString().padLeft(2, '0'),
                            ),
                            style: const TextStyle(
                                fontSize: 13, fontWeight: FontWeight.w600),
                          ),
                        ),
                        Text(
                          CurrencyFormatter.format(topDays[i].amount),
                          style: AppTypography.mono(
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                              color: colors.danger),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        ],
      ],
    );
  }
}

class _MiniStatCard extends StatelessWidget {
  const _MiniStatCard(
      {required this.label, required this.value, this.valueColor});

  final String label;
  final String value;
  final Color? valueColor;

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
              style: Theme.of(context)
                  .textTheme
                  .labelSmall
                  ?.copyWith(fontSize: 11)),
          const SizedBox(height: 4),
          Text(
            value,
            style: AppTypography.mono(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: valueColor ?? colors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}

class _LegendDot extends StatelessWidget {
  const _LegendDot({required this.color, required this.label});

  final Color color;
  final String label;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          height: 9,
          width: 9,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 6),
        Text(label,
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
                fontWeight: FontWeight.w400, color: colors.textSecondary)),
      ],
    );
  }
}
