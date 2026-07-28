import 'package:flutter/material.dart';

/// Semantic color tokens per design handoff (light + dark).
/// Never reference these hex values directly in widgets — use
/// `Theme.of(context).extension<AppColorsExtension>()!` instead.
abstract class AppColorsLight {
  static const primary = Color(0xFF4F46E5);
  static const splashEnd = Color(0xFF8B5CF6);
  static const success = Color(0xFF22C55E);
  static const warning = Color(0xFFF59E0B);
  static const danger = Color(0xFFEF4444);
  static const background = Color(0xFFF8FAFC);
  static const surface = Color(0xFFFFFFFF);
  static const surfaceAlt = Color(0xFFF1F5F9);
  static const border = Color(0xFFE2E8F0);
  static const textPrimary = Color(0xFF1E293B);
  static const textSecondary = Color(0xFF64748B);
  static const textTertiary = Color(0xFF94A3B8);
  static const primaryTint = Color(0xFFEEF2FF);
  static const successTint = Color(0xFFECFDF5);
  static const warningTint = Color(0xFFFFFBEB);
  static const dangerTint = Color(0xFFFEF2F2);

  /// Bottom nav background — distinct from [surface] in dark mode only.
  static const navBg = Color(0xFFFFFFFF);
}

abstract class AppColorsDark {
  static const primary = Color(0xFF818CF8);
  static const splashEnd = Color(0xFF3730A3);
  static const success = Color(0xFF34D399);
  static const warning = Color(0xFFFBBF24);
  static const danger = Color(0xFFF87171);
  static const background = Color(0xFF111827);
  static const surface = Color(0xFF1F2937);
  static const surfaceAlt = Color(0xFF182234);
  static const border = Color(0xFF2D3748);
  static const textPrimary = Color(0xFFF1F5F9);
  static const textSecondary = Color(0xFF94A3B8);
  static const textTertiary = Color(0xFF64748B);
  static const primaryTint = Color(0xFF252244);
  static const successTint = Color(0xFF123024);
  static const warningTint = Color(0xFF3A2A0A);
  static const dangerTint = Color(0xFF3B1719);

  /// Bottom nav background — deliberately darker than [surface] (#151c2b vs
  /// #1F2937), per design handoff Global Chrome.
  static const navBg = Color(0xFF151C2B);
}

/// Fixed-hue category chart palette — same in light & dark (per design).
abstract class AppCategoryColors {
  static const anUong = Color(0xFF4F46E5);
  static const shopping = Color(0xFFF59E0B);
  static const diLai = Color(0xFF22C55E);
  static const giaiTri = Color(0xFFF43F5E);
  static const giaDinh = Color(0xFF8B5CF6);
  static const khac = Color(0xFF94A3B8);
}

@immutable
class AppColorsExtension extends ThemeExtension<AppColorsExtension> {
  const AppColorsExtension({
    required this.primary,
    required this.splashEnd,
    required this.success,
    required this.warning,
    required this.danger,
    required this.background,
    required this.surface,
    required this.surfaceAlt,
    required this.border,
    required this.textPrimary,
    required this.textSecondary,
    required this.textTertiary,
    required this.primaryTint,
    required this.successTint,
    required this.warningTint,
    required this.dangerTint,
    required this.navBg,
  });

  factory AppColorsExtension.light() => const AppColorsExtension(
        primary: AppColorsLight.primary,
        splashEnd: AppColorsLight.splashEnd,
        success: AppColorsLight.success,
        warning: AppColorsLight.warning,
        danger: AppColorsLight.danger,
        background: AppColorsLight.background,
        surface: AppColorsLight.surface,
        surfaceAlt: AppColorsLight.surfaceAlt,
        border: AppColorsLight.border,
        textPrimary: AppColorsLight.textPrimary,
        textSecondary: AppColorsLight.textSecondary,
        textTertiary: AppColorsLight.textTertiary,
        primaryTint: AppColorsLight.primaryTint,
        successTint: AppColorsLight.successTint,
        warningTint: AppColorsLight.warningTint,
        dangerTint: AppColorsLight.dangerTint,
        navBg: AppColorsLight.navBg,
      );

  factory AppColorsExtension.dark() => const AppColorsExtension(
        primary: AppColorsDark.primary,
        splashEnd: AppColorsDark.splashEnd,
        success: AppColorsDark.success,
        warning: AppColorsDark.warning,
        danger: AppColorsDark.danger,
        background: AppColorsDark.background,
        surface: AppColorsDark.surface,
        surfaceAlt: AppColorsDark.surfaceAlt,
        border: AppColorsDark.border,
        textPrimary: AppColorsDark.textPrimary,
        textSecondary: AppColorsDark.textSecondary,
        textTertiary: AppColorsDark.textTertiary,
        primaryTint: AppColorsDark.primaryTint,
        successTint: AppColorsDark.successTint,
        warningTint: AppColorsDark.warningTint,
        dangerTint: AppColorsDark.dangerTint,
        navBg: AppColorsDark.navBg,
      );

  final Color primary;
  final Color splashEnd;
  final Color success;
  final Color warning;
  final Color danger;
  final Color background;
  final Color surface;
  final Color surfaceAlt;
  final Color border;
  final Color textPrimary;
  final Color textSecondary;
  final Color textTertiary;
  final Color primaryTint;
  final Color successTint;
  final Color warningTint;
  final Color dangerTint;
  final Color navBg;

  @override
  AppColorsExtension copyWith({
    Color? primary,
    Color? splashEnd,
    Color? success,
    Color? warning,
    Color? danger,
    Color? background,
    Color? surface,
    Color? surfaceAlt,
    Color? border,
    Color? textPrimary,
    Color? textSecondary,
    Color? textTertiary,
    Color? primaryTint,
    Color? successTint,
    Color? warningTint,
    Color? dangerTint,
    Color? navBg,
  }) {
    return AppColorsExtension(
      primary: primary ?? this.primary,
      splashEnd: splashEnd ?? this.splashEnd,
      success: success ?? this.success,
      warning: warning ?? this.warning,
      danger: danger ?? this.danger,
      background: background ?? this.background,
      surface: surface ?? this.surface,
      surfaceAlt: surfaceAlt ?? this.surfaceAlt,
      border: border ?? this.border,
      textPrimary: textPrimary ?? this.textPrimary,
      textSecondary: textSecondary ?? this.textSecondary,
      textTertiary: textTertiary ?? this.textTertiary,
      primaryTint: primaryTint ?? this.primaryTint,
      successTint: successTint ?? this.successTint,
      warningTint: warningTint ?? this.warningTint,
      dangerTint: dangerTint ?? this.dangerTint,
      navBg: navBg ?? this.navBg,
    );
  }

  @override
  AppColorsExtension lerp(ThemeExtension<AppColorsExtension>? other, double t) {
    if (other is! AppColorsExtension) return this;
    return AppColorsExtension(
      primary: Color.lerp(primary, other.primary, t)!,
      splashEnd: Color.lerp(splashEnd, other.splashEnd, t)!,
      success: Color.lerp(success, other.success, t)!,
      warning: Color.lerp(warning, other.warning, t)!,
      danger: Color.lerp(danger, other.danger, t)!,
      background: Color.lerp(background, other.background, t)!,
      surface: Color.lerp(surface, other.surface, t)!,
      surfaceAlt: Color.lerp(surfaceAlt, other.surfaceAlt, t)!,
      border: Color.lerp(border, other.border, t)!,
      textPrimary: Color.lerp(textPrimary, other.textPrimary, t)!,
      textSecondary: Color.lerp(textSecondary, other.textSecondary, t)!,
      textTertiary: Color.lerp(textTertiary, other.textTertiary, t)!,
      primaryTint: Color.lerp(primaryTint, other.primaryTint, t)!,
      successTint: Color.lerp(successTint, other.successTint, t)!,
      warningTint: Color.lerp(warningTint, other.warningTint, t)!,
      dangerTint: Color.lerp(dangerTint, other.dangerTint, t)!,
      navBg: Color.lerp(navBg, other.navBg, t)!,
    );
  }
}

extension AppColorsContext on BuildContext {
  AppColorsExtension get colors =>
      Theme.of(this).extension<AppColorsExtension>()!;
}
