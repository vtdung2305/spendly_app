import 'package:flutter/widgets.dart';

import 'app_localizations_x.dart';

/// Mon..Sun abbreviations shared by the Calendar grid and the Add
/// Transaction date-picker sheet.
List<String> weekdayLabels(BuildContext context) => [
      context.l10n.weekdayMon,
      context.l10n.weekdayTue,
      context.l10n.weekdayWed,
      context.l10n.weekdayThu,
      context.l10n.weekdayFri,
      context.l10n.weekdaySat,
      context.l10n.weekdaySun,
    ];

/// Full weekday name (e.g. "Thứ 2", "Chủ Nhật") for [DateTime.weekday]
/// (1 = Monday .. 7 = Sunday) — used by History's date-group sticky headers.
String fullWeekdayLabel(BuildContext context, int weekday) => switch (weekday) {
      1 => context.l10n.historyGroupWeekdayMon,
      2 => context.l10n.historyGroupWeekdayTue,
      3 => context.l10n.historyGroupWeekdayWed,
      4 => context.l10n.historyGroupWeekdayThu,
      5 => context.l10n.historyGroupWeekdayFri,
      6 => context.l10n.historyGroupWeekdaySat,
      _ => context.l10n.historyGroupWeekdaySun,
    };
