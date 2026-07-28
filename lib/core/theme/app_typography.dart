import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Type scale per design handoff: Inter for UI text, IBM Plex Mono for
/// monetary amounts / meta labels. Use `Theme.of(context).textTheme.*` in
/// widgets — never construct a raw `TextStyle` inline.
abstract class AppTypography {
  static TextTheme textTheme(Color textPrimary, Color textSecondary) {
    final base = GoogleFonts.interTextTheme();
    return base.copyWith(
      // Hero numbers / headlines 22-30px.
      headlineLarge: GoogleFonts.inter(
        fontSize: 30,
        fontWeight: FontWeight.w800,
        color: textPrimary,
      ),
      headlineMedium: GoogleFonts.inter(
        fontSize: 26,
        fontWeight: FontWeight.w800,
        color: textPrimary,
      ),
      headlineSmall: GoogleFonts.inter(
        fontSize: 22,
        fontWeight: FontWeight.w800,
        color: textPrimary,
      ),
      // Screen titles 17-19px.
      titleLarge: GoogleFonts.inter(
        fontSize: 19,
        fontWeight: FontWeight.w700,
        color: textPrimary,
      ),
      titleMedium: GoogleFonts.inter(
        fontSize: 17,
        fontWeight: FontWeight.w700,
        color: textPrimary,
      ),
      titleSmall: GoogleFonts.inter(
        fontSize: 15,
        fontWeight: FontWeight.w600,
        color: textPrimary,
      ),
      // Body/labels 14-15px.
      bodyLarge: GoogleFonts.inter(
        fontSize: 15,
        fontWeight: FontWeight.w500,
        color: textPrimary,
      ),
      bodyMedium: GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: textPrimary,
      ),
      // Secondary/body-small 12-13px.
      bodySmall: GoogleFonts.inter(
        fontSize: 13,
        fontWeight: FontWeight.w400,
        color: textSecondary,
      ),
      labelLarge: GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: textPrimary,
      ),
      labelMedium: GoogleFonts.inter(
        fontSize: 12,
        fontWeight: FontWeight.w600,
        color: textSecondary,
      ),
      // Meta/chips 10-11px.
      labelSmall: GoogleFonts.inter(
        fontSize: 11,
        fontWeight: FontWeight.w600,
        color: textSecondary,
      ),
    );
  }

  /// Monospace style for monetary amounts — pass size/weight/color per usage.
  static TextStyle mono({
    required double fontSize,
    required FontWeight fontWeight,
    required Color color,
    double? letterSpacing,
  }) {
    return GoogleFonts.ibmPlexMono(
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color,
      letterSpacing: letterSpacing,
    );
  }
}
