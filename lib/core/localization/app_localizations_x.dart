import 'package:flutter/widgets.dart';

import 'package:spendly_app/l10n/app_localizations.dart';

/// Shorthand for `AppLocalizations.of(context)!`, mirroring the
/// `context.colors` theme-access pattern used across the app.
extension AppLocalizationsX on BuildContext {
  AppLocalizations get l10n => AppLocalizations.of(this)!;
}
