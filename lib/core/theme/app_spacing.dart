/// Spacing scale — base unit 2px, per design handoff common paddings.
abstract class AppSpacing {
  static const xxs = 4.0;
  static const xs = 8.0;
  static const sm = 10.0;
  static const smMd = 12.0;
  static const md = 14.0;
  static const mdLg = 16.0;
  static const lg = 18.0;
  static const lgXl = 20.0;
  static const xl = 22.0;
  static const xl2 = 24.0;
  static const xxl = 28.0;
  static const xxl2 = 32.0;

  /// Screen horizontal padding (Dashboard/Calendar/Reports/... — 16px).
  static const screenHorizontal = 16.0;

  /// Login/Register side padding — wider than the standard screen gutter (18px).
  static const authHorizontal = 18.0;

  /// Gap between stacked cards.
  static const cardGap = 14.0;
}
