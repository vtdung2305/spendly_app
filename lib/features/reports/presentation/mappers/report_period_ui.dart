import 'package:flutter/widgets.dart';

import 'package:spendly_app/core/localization/app_localizations_x.dart';
import 'package:spendly_app/features/transactions/domain/entities/report_period.dart';

extension ReportPeriodUi on ReportPeriod {
  String labelText(BuildContext context) => switch (this) {
        ReportPeriod.week => context.l10n.reportPeriodWeek,
        ReportPeriod.month => context.l10n.reportPeriodMonth,
        ReportPeriod.year => context.l10n.reportPeriodYear,
      };
}
