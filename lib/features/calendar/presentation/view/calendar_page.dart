import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'package:spendly_app/core/localization/app_localizations_x.dart';
import 'package:spendly_app/core/theme/app_colors.dart';
import 'package:spendly_app/core/theme/app_radius.dart';
import 'package:spendly_app/core/theme/app_shadow.dart';
import 'package:spendly_app/core/theme/app_spacing.dart';
import 'package:spendly_app/core/theme/app_typography.dart';
import 'package:spendly_app/core/utils/currency_formatter.dart';
import 'package:spendly_app/shared/components/calendar/month_grid.dart';
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
  final _scrollController = ScrollController();
  bool _isScrolled = false;

  @override
  void initState() {
    super.initState();
    context.read<CalendarCubit>().load(_currentMonth);
    _scrollController.addListener(_handleScroll);
  }

  @override
  void dispose() {
    _scrollController
      ..removeListener(_handleScroll)
      ..dispose();
    super.dispose();
  }

  void _handleScroll() {
    final isScrolled = _scrollController.offset > 0;
    if (isScrolled != _isScrolled) setState(() => _isScrolled = isScrolled);
  }

  void _changeMonth(int delta) {
    setState(() => _currentMonth =
        DateTime(_currentMonth.year, _currentMonth.month + delta));
    context.read<CalendarCubit>().load(_currentMonth);
  }

  Future<void> _openDay(
      BuildContext context, int day, int month, int year) async {
    final cubit = context.read<CalendarCubit>();
    // Await the fetch before opening the sheet so its first frame already
    // shows the final content/height — opening it first and letting the
    // fetch resolve afterwards (while the sheet is already visible) is what
    // caused the sheet to visibly grow/shrink after appearing.
    await cubit.selectDay(day);
    if (!context.mounted) return;
    await showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      // A local ScaffoldMessenger, as an ancestor of DayTransactionsSheet's
      // own context, scopes its AppSnackbar calls to its own Scaffold —
      // without it Flutter shows the SnackBar on every registered root
      // Scaffold, duplicating it onto CalendarPage's Scaffold underneath.
      builder: (_) => ScaffoldMessenger(
        child: BlocProvider.value(
          value: cubit,
          child: DayTransactionsSheet(day: day, month: month, year: year),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final topInset = MediaQuery.paddingOf(context).top;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Scaffold(
        body: BlocBuilder<CalendarCubit, CalendarState>(
          builder: (context, state) {
            final headerHeight = state is CalendarLoaded ? topInset + 72 : 0.0;
            return SizedBox.expand(
              child: Stack(
                children: [
                  Positioned.fill(
                    top: headerHeight,
                    child: SafeArea(
                      top: false,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: AppSpacing.screenHorizontal),
                        child: RefreshIndicator(
                          onRefresh: () =>
                              context.read<CalendarCubit>().load(_currentMonth),
                          child: switch (state) {
                            CalendarLoading() => ListView(
                                padding: EdgeInsets.zero,
                                physics: const AlwaysScrollableScrollPhysics(),
                                children: const [
                                  Padding(
                                    padding:
                                        EdgeInsets.only(top: AppSpacing.xxl2),
                                    child: AppLoadingIndicator(),
                                  ),
                                ],
                              ),
                            CalendarError(:final message) => ListView(
                                padding: EdgeInsets.zero,
                                physics: const AlwaysScrollableScrollPhysics(),
                                children: [
                                  AppErrorView(
                                    message: message,
                                    onRetry: () => context
                                        .read<CalendarCubit>()
                                        .load(_currentMonth),
                                  ),
                                ],
                              ),
                            CalendarLoaded(:final month, :final days) =>
                              SingleChildScrollView(
                                controller: _scrollController,
                                physics: const AlwaysScrollableScrollPhysics(),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const SizedBox(height: AppSpacing.mdLg),
                                    Container(
                                      width: double.infinity,
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 12, vertical: 16),
                                      decoration: BoxDecoration(
                                        color: colors.surface,
                                        borderRadius: BorderRadius.circular(
                                            AppRadius.card),
                                        border:
                                            Border.all(color: colors.border),
                                        boxShadow: AppShadow.card,
                                      ),
                                      child: Column(
                                        children: [
                                          MonthGrid(
                                            month: month,
                                            daysInMonth: days.length,
                                            dayBuilder: (day) => _DayCell(
                                              day: days[day - 1],
                                              isToday: _isToday(month, day),
                                              onTap: () => _openDay(context,
                                                  day, month.month, month.year),
                                            ),
                                          ),
                                          Container(
                                            width: double.infinity,
                                            margin:
                                                const EdgeInsets.only(top: 16),
                                            padding:
                                                const EdgeInsets.only(top: 14),
                                            decoration: BoxDecoration(
                                              border: Border(
                                                  top: BorderSide(
                                                      color: colors.border)),
                                            ),
                                            child: Wrap(
                                              spacing: 16,
                                              runSpacing: 8,
                                              children: [
                                                _LegendDot(
                                                  color: colors.danger,
                                                  label: context.l10n
                                                      .calendarLegendHighSpend,
                                                ),
                                                _LegendDot(
                                                  color: colors.primary,
                                                  label: context.l10n
                                                      .calendarLegendMidSpend,
                                                ),
                                                _LegendDot(
                                                  color: colors.success,
                                                  label: context.l10n
                                                      .calendarLegendLowSpend,
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(height: AppSpacing.md),
                                    _CalendarStatsSection(
                                        month: month, days: days),
                                  ],
                                ),
                              ),
                          },
                        ),
                      ),
                    ),
                  ),
                  if (state is CalendarLoaded)
                    _CalendarHeader(
                      month: state.month,
                      totalExpense: state.totalExpense,
                      showShadow: _isScrolled,
                      onPrevMonth: () => _changeMonth(-1),
                      onNextMonth: () => _changeMonth(1),
                    ),
                ],
              ),
            );
          },
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

  bool _isToday(DateTime month, int day) {
    final now = DateTime.now();
    return now.year == month.year && now.month == month.month && now.day == day;
  }
}

class _DayCell extends StatelessWidget {
  const _DayCell({
    required this.day,
    required this.onTap,
    this.isToday = false,
  });

  final CalendarDay day;
  final VoidCallback onTap;
  final bool isToday;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final tone = calendarDayTone(day.amount);

    return MonthGridDayCell(
      onTap: onTap,
      background: tone.background(colors),
      ringColor: isToday ? colors.primary : null,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            '${day.day}',
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
                fontSize: 12.5,
                fontWeight: FontWeight.w700,
                color: tone.foreground(colors)),
          ),
          Text(
            day.amount > 0 ? CurrencyFormatter.formatCompact(day.amount) : '—',
            style: AppTypography.mono(
                fontSize: 8.5,
                fontWeight: FontWeight.w600,
                color: tone.foreground(colors)),
          ),
        ],
      ),
    );
  }
}

/// Same full-bleed gradient bar as `AppHeader` (`headerBg`/`headerFg` per
/// design) — kept as its own widget rather than `AppHeader` since its
/// prev/next-flanking-centered-title shape doesn't fit that widget's
/// leading-back/trailing-action model.
class _CalendarHeader extends StatelessWidget {
  const _CalendarHeader({
    required this.month,
    required this.totalExpense,
    required this.showShadow,
    required this.onPrevMonth,
    required this.onNextMonth,
  });

  final DateTime month;
  final double totalExpense;
  final bool showShadow;
  final VoidCallback onPrevMonth;
  final VoidCallback onNextMonth;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final topInset = MediaQuery.paddingOf(context).top;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(16, topInset + 16, 16, 16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [colors.primary, colors.splashEnd],
        ),
        boxShadow: showShadow
            ? [
                BoxShadow(
                  color: colors.primary.withValues(alpha: 0.22),
                  blurRadius: 14,
                  offset: const Offset(0, 4),
                ),
              ]
            : null,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _MonthNavButton(icon: Icons.chevron_left_rounded, onTap: onPrevMonth),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                context.l10n.monthYearHeader(
                    month.month.toString(), month.year.toString()),
                style: const TextStyle(
                  fontSize: 19,
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                  letterSpacing: -0.01 * 19,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                context.l10n.calendarTotalExpenseLabel(
                    CurrencyFormatter.format(totalExpense)),
                style: AppTypography.mono(
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                  color: const Color.fromRGBO(255, 255, 255, 0.82),
                ),
              ),
            ],
          ),
          _MonthNavButton(
              icon: Icons.chevron_right_rounded, onTap: onNextMonth),
        ],
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
    return SizedBox(
      height: 38,
      width: 38,
      child: Material(
        type: MaterialType.transparency,
        child: InkWell(
          onTap: onTap,
          child: Icon(icon, size: 20, color: Colors.white),
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
