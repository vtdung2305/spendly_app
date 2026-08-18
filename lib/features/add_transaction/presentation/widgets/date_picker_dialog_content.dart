import 'package:flutter/material.dart';

import 'package:spendly_app/core/localization/app_localizations_x.dart';
import 'package:spendly_app/core/theme/app_colors.dart';
import 'package:spendly_app/core/theme/app_radius.dart';
import 'package:spendly_app/core/theme/app_spacing.dart';
import 'package:spendly_app/shared/components/calendar/month_grid.dart';

/// Custom date picker for Add Transaction's date row — any past or future
/// date is selectable, unlike Flutter's built-in `showDatePicker`. Shown
/// inside a `CenterDialog`, and shares `MonthGrid`/`MonthGridDayCell` with
/// the Calendar screen so both render the exact same month-grid layout and
/// cell shape, per design handoff.
class DatePickerDialogContent extends StatefulWidget {
  const DatePickerDialogContent(
      {required this.initialDate, this.minSelectableDate, super.key});

  final DateTime initialDate;

  /// When set, days on or before this date are disabled (greyed out,
  /// untappable) — e.g. History's "Đến ngày" can't be on/before "Từ ngày".
  final DateTime? minSelectableDate;

  @override
  State<DatePickerDialogContent> createState() =>
      _DatePickerDialogContentState();
}

class _DatePickerDialogContentState extends State<DatePickerDialogContent> {
  late DateTime _selectedDate;
  late DateTime _displayedMonth;

  @override
  void initState() {
    super.initState();
    _selectedDate = widget.initialDate;
    _displayedMonth =
        DateTime(widget.initialDate.year, widget.initialDate.month);
  }

  void _changeMonth(int delta) {
    setState(() => _displayedMonth =
        DateTime(_displayedMonth.year, _displayedMonth.month + delta));
  }

  void _selectDay(int day) {
    Navigator.of(context)
        .pop(DateTime(_displayedMonth.year, _displayedMonth.month, day));
  }

  int _daysInMonth() =>
      DateTime(_displayedMonth.year, _displayedMonth.month + 1, 0).day;

  bool _isDisabled(int day) {
    final minDate = widget.minSelectableDate;
    if (minDate == null) return false;
    final candidate = DateTime(_displayedMonth.year, _displayedMonth.month, day);
    return !candidate.isAfter(
        DateTime(minDate.year, minDate.month, minDate.day));
  }

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final textTheme = Theme.of(context).textTheme;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _NavButton(
              icon: Icons.chevron_left_rounded,
              onTap: () => _changeMonth(-1),
            ),
            Text(
              context.l10n.monthYearHeader(_displayedMonth.month.toString(),
                  _displayedMonth.year.toString()),
              style: textTheme.titleSmall,
            ),
            _NavButton(
              icon: Icons.chevron_right_rounded,
              onTap: () => _changeMonth(1),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.md),
        MonthGrid(
          month: _displayedMonth,
          daysInMonth: _daysInMonth(),
          dayBuilder: (day) => _DayCell(
            day: day,
            isSelected: _selectedDate.year == _displayedMonth.year &&
                _selectedDate.month == _displayedMonth.month &&
                _selectedDate.day == day,
            isToday: now.year == _displayedMonth.year &&
                now.month == _displayedMonth.month &&
                now.day == day,
            isDisabled: _isDisabled(day),
            onTap: () => _selectDay(day),
          ),
        ),
      ],
    );
  }
}

/// 34×34 rounded-square month-nav button (per design) — deliberately not a
/// plain `IconButton`, whose 48×48 minimum tap target adds visible empty
/// space above/below this row inside the compact dialog.
class _NavButton extends StatelessWidget {
  const _NavButton({required this.icon, required this.onTap});

  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppRadius.sm),
      child: Container(
        height: 34,
        width: 34,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: colors.surfaceAlt,
          borderRadius: BorderRadius.circular(AppRadius.sm),
        ),
        child: Icon(icon, size: 18, color: colors.textPrimary),
      ),
    );
  }
}

class _DayCell extends StatelessWidget {
  const _DayCell({
    required this.day,
    required this.isSelected,
    required this.isToday,
    required this.onTap,
    this.isDisabled = false,
  });

  final int day;
  final bool isSelected;
  final bool isToday;
  final bool isDisabled;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final background = isSelected
        ? colors.primary
        : (isToday ? colors.primaryTint : colors.surfaceAlt);
    final foreground = isDisabled
        ? colors.textTertiary
        : (isSelected
            ? Colors.white
            : (isToday ? colors.primary : colors.textPrimary));

    return MonthGridDayCell(
      onTap: isDisabled ? null : onTap,
      background: isDisabled ? colors.surfaceAlt : background,
      ringColor: isToday && !isSelected && !isDisabled ? colors.primary : null,
      child: Text(
        '$day',
        style: Theme.of(context)
            .textTheme
            .bodySmall
            ?.copyWith(fontWeight: FontWeight.w700, color: foreground),
      ),
    );
  }
}
