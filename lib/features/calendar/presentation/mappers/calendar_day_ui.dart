import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';

enum CalendarDayTone { neutral, low, mid, high }

/// Thresholds per design handoff: ≥1.000.000₫ = high (danger), >0 and
/// ≤300.000₫ = low (success), >300.000₫ = mid (primary), 0 = neutral.
CalendarDayTone calendarDayTone(double amount) {
  if (amount >= 1000000) return CalendarDayTone.high;
  if (amount > 0 && amount <= 300000) return CalendarDayTone.low;
  if (amount > 300000) return CalendarDayTone.mid;
  return CalendarDayTone.neutral;
}

extension CalendarDayToneUi on CalendarDayTone {
  Color background(AppColorsExtension colors) => switch (this) {
        CalendarDayTone.high => colors.dangerTint,
        CalendarDayTone.low => colors.successTint,
        CalendarDayTone.mid => colors.primaryTint,
        CalendarDayTone.neutral => colors.surface,
      };

  Color foreground(AppColorsExtension colors) => switch (this) {
        CalendarDayTone.high => colors.danger,
        CalendarDayTone.low => colors.success,
        CalendarDayTone.mid => colors.primary,
        CalendarDayTone.neutral => colors.textSecondary,
      };
}
