import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/utils/currency_formatter.dart';
import '../../../../shared/components/error/app_error_view.dart';
import '../../../../shared/components/loading/app_loading_indicator.dart';
import '../../../../shared/components/navigation/app_bottom_nav_bar.dart';
import '../mappers/calendar_day_ui.dart';
import '../viewmodel/calendar_cubit.dart';
import '../viewmodel/calendar_state.dart';
import '../widgets/day_transactions_sheet.dart';

const _kWeekdayLabels = ['T2', 'T3', 'T4', 'T5', 'T6', 'T7', 'CN'];

class CalendarPage extends StatefulWidget {
  const CalendarPage({super.key});

  @override
  State<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  @override
  void initState() {
    super.initState();
    context.read<CalendarCubit>().load(DateTime(2026, 7));
  }

  void _openDay(BuildContext context, int day, double amount, int month) {
    final cubit = context.read<CalendarCubit>();
    cubit.selectDay(day);
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) => DayTransactionsSheet(day: day, month: month, amount: amount),
    ).then((_) => cubit.closeDay());
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.screenHorizontal),
          child: BlocBuilder<CalendarCubit, CalendarState>(
            builder: (context, state) {
              return switch (state) {
                CalendarLoading() => const Padding(
                    padding: EdgeInsets.only(top: AppSpacing.xxl2),
                    child: AppLoadingIndicator(),
                  ),
                CalendarError(:final message) => AppErrorView(
                    message: message,
                    onRetry: () => context.read<CalendarCubit>().load(DateTime(2026, 7)),
                  ),
                CalendarLoaded(:final month, :final days, :final totalExpense) => Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: AppSpacing.mdLg),
                      Text('Tháng ${month.month}, ${month.year}', style: textTheme.titleLarge),
                      const SizedBox(height: 2),
                      Text(
                        'Tổng chi: ${CurrencyFormatter.format(totalExpense)}',
                        style: textTheme.bodySmall?.copyWith(color: colors.textSecondary),
                      ),
                      const SizedBox(height: AppSpacing.lg),
                      GridView.count(
                        crossAxisCount: 7,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        mainAxisSpacing: 4,
                        crossAxisSpacing: 4,
                        children: [
                          for (final label in _kWeekdayLabels)
                            Center(
                              child: Text(
                                label,
                                style: textTheme.labelSmall?.copyWith(color: colors.textTertiary),
                              ),
                            ),
                          for (var i = 0; i < _leadingBlanks(month); i++) const SizedBox.shrink(),
                          for (final day in days)
                            _DayCell(
                              day: day.day,
                              amount: day.amount,
                              onTap: () => _openDay(context, day.day, day.amount, month.month),
                            ),
                        ],
                      ),
                      const SizedBox(height: AppSpacing.lg),
                      Row(
                        children: [
                          _LegendDot(color: colors.dangerTint, ringColor: colors.danger, label: 'Chi nhiều'),
                          const SizedBox(width: AppSpacing.md),
                          _LegendDot(color: colors.successTint, ringColor: colors.success, label: 'Chi ít'),
                        ],
                      ),
                    ],
                  ),
              };
            },
          ),
        ),
      ),
      bottomNavigationBar: AppBottomNavBar(
        currentIndex: 1,
        onTabSelected: (index) => _handleTabSelected(context, index),
        onFabPressed: () => Navigator.of(context).pushNamed('/add-transaction'),
      ),
    );
  }

  void _handleTabSelected(BuildContext context, int index) {
    switch (index) {
      case 0:
        Navigator.of(context).pushReplacementNamed('/dashboard');
      case 2:
        Navigator.of(context).pushReplacementNamed('/reports');
      case 3:
        Navigator.of(context).pushReplacementNamed('/profile');
    }
  }

  int _leadingBlanks(DateTime month) => DateTime(month.year, month.month).weekday - 1;
}

class _DayCell extends StatelessWidget {
  const _DayCell({required this.day, required this.amount, required this.onTap});

  final int day;
  final double amount;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final tone = calendarDayTone(amount);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppRadius.sm - 2),
      child: Container(
        decoration: BoxDecoration(
          color: tone.background(colors),
          borderRadius: BorderRadius.circular(AppRadius.sm - 2),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '$day',
              style: Theme.of(context)
                  .textTheme
                  .labelMedium
                  ?.copyWith(fontSize: 12, fontWeight: FontWeight.w700, color: tone.foreground(colors)),
            ),
            Text(
              amount > 0 ? CurrencyFormatter.formatCompact(amount) : '—',
              style: Theme.of(context).textTheme.labelSmall?.copyWith(fontSize: 9, color: tone.foreground(colors)),
            ),
          ],
        ),
      ),
    );
  }
}

class _LegendDot extends StatelessWidget {
  const _LegendDot({required this.color, required this.ringColor, required this.label});

  final Color color;
  final Color ringColor;
  final String label;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          height: 10,
          width: 10,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(3),
            border: Border.all(color: ringColor),
          ),
        ),
        const SizedBox(width: AppSpacing.xxs),
        Text(label, style: Theme.of(context).textTheme.labelSmall?.copyWith(color: colors.textSecondary)),
      ],
    );
  }
}
