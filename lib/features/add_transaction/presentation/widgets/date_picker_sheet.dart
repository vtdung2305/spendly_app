import 'package:flutter/material.dart';

import 'package:spendly_app/core/localization/app_localizations_x.dart';
import 'package:spendly_app/core/localization/weekday_labels.dart';
import 'package:spendly_app/core/theme/app_colors.dart';
import 'package:spendly_app/core/theme/app_radius.dart';
import 'package:spendly_app/core/theme/app_spacing.dart';

/// Custom date-picker bottom sheet for Add Transaction's date row — any past
/// or future date is selectable, unlike Flutter's built-in `showDatePicker`.
/// Pops with the selected [DateTime], or null if dismissed.
class DatePickerSheet extends StatefulWidget {
  const DatePickerSheet({required this.initialDate, super.key});

  final DateTime initialDate;

  @override
  State<DatePickerSheet> createState() => _DatePickerSheetState();
}

class _DatePickerSheetState extends State<DatePickerSheet> {
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

  int _leadingBlanks() =>
      DateTime(_displayedMonth.year, _displayedMonth.month).weekday - 1;

  int _daysInMonth() =>
      DateTime(_displayedMonth.year, _displayedMonth.month + 1, 0).day;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final now = DateTime.now();
    final textTheme = Theme.of(context).textTheme;

    return Container(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.screenHorizontal,
        AppSpacing.md,
        AppSpacing.screenHorizontal,
        AppSpacing.xxl,
      ),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius:
            const BorderRadius.vertical(top: Radius.circular(AppRadius.sheet)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Center(
            child: Container(
              height: 4,
              width: 36,
              decoration: BoxDecoration(
                  color: colors.border,
                  borderRadius: BorderRadius.circular(AppRadius.full)),
            ),
          ),
          const SizedBox(height: AppSpacing.smMd),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(context.l10n.addTransactionDatePickerTitle,
                  style: textTheme.titleSmall),
              InkWell(
                onTap: () => Navigator.of(context).pop(),
                borderRadius: BorderRadius.circular(AppRadius.full),
                child: Icon(Icons.close_rounded,
                    size: 22, color: colors.textSecondary),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.mdLg),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                onPressed: () => _changeMonth(-1),
                icon:
                    Icon(Icons.chevron_left_rounded, color: colors.textPrimary),
              ),
              Text(
                context.l10n.monthYearHeader(_displayedMonth.month.toString(),
                    _displayedMonth.year.toString()),
                style: textTheme.titleSmall,
              ),
              IconButton(
                onPressed: () => _changeMonth(1),
                icon: Icon(Icons.chevron_right_rounded,
                    color: colors.textPrimary),
              ),
            ],
          ),
          GridView.count(
            crossAxisCount: 7,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            mainAxisSpacing: 4,
            crossAxisSpacing: 4,
            children: [
              for (final label in weekdayLabels(context))
                Center(
                  child: Text(label,
                      style: textTheme.labelSmall
                          ?.copyWith(color: colors.textTertiary)),
                ),
              for (var i = 0; i < _leadingBlanks(); i++)
                const SizedBox.shrink(),
              for (var day = 1; day <= _daysInMonth(); day++)
                _DayCell(
                  day: day,
                  isSelected: _selectedDate.year == _displayedMonth.year &&
                      _selectedDate.month == _displayedMonth.month &&
                      _selectedDate.day == day,
                  isToday: now.year == _displayedMonth.year &&
                      now.month == _displayedMonth.month &&
                      now.day == day,
                  onTap: () => _selectDay(day),
                ),
            ],
          ),
        ],
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
  });

  final int day;
  final bool isSelected;
  final bool isToday;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppRadius.full),
      child: Center(
        child: Container(
          height: 32,
          width: 32,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isSelected ? colors.primary : null,
            border: !isSelected && isToday
                ? Border.all(color: colors.primary, width: 1.5)
                : null,
          ),
          child: Center(
            child: Text(
              '$day',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: isSelected ? Colors.white : colors.textPrimary,
                  ),
            ),
          ),
        ),
      ),
    );
  }
}
