import 'package:flutter/material.dart';

import 'package:spendly_app/core/theme/app_colors.dart';

/// Maps the backend's free-form `icon` string (a Material Symbols name) to
/// [IconData] — scoped to notifications rather than reusing
/// `categoryIconFor`, since the two features draw from different icon
/// sets.
const Map<String, IconData> _kNotificationIconMap = {
  'warning': Icons.warning_rounded,
  'edit_note': Icons.edit_note_rounded,
  'event_repeat': Icons.event_repeat_rounded,
  'flag': Icons.flag_rounded,
  'savings': Icons.savings_rounded,
};

IconData notificationIconFor(String icon) =>
    _kNotificationIconMap[icon] ?? Icons.notifications_rounded;

/// Maps the backend's `tone` string to this app's semantic color pair.
(Color, Color) notificationToneColors(AppColorsExtension colors, String tone) =>
    switch (tone) {
      'warning' => (colors.warning, colors.warningTint),
      'success' => (colors.success, colors.successTint),
      _ => (colors.primary, colors.primaryTint),
    };
