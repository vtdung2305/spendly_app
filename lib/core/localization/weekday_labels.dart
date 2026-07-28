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
