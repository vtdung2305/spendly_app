import 'package:intl/intl.dart';

/// Formats VND amounts consistently across the app (dashboard, history,
/// budget cards, amount input live preview).
abstract class CurrencyFormatter {
  static final _fullFormat = NumberFormat.decimalPattern('vi_VN');

  /// e.g. 26500000 -> "26.500.000 ₫"
  static String format(num amount) => '${_fullFormat.format(amount)} ₫';

  /// e.g. 26500000 -> "26.500.000" (no currency suffix, used inside inputs).
  static String formatPlain(num amount) => _fullFormat.format(amount);

  /// Compact form for tight spaces (calendar cells, mini stats):
  /// 1200000 -> "1.2M", 250000 -> "250K", 0 -> "—".
  static String formatCompact(num amount) {
    if (amount == 0) return '—';
    if (amount >= 1000000) {
      final millions = amount / 1000000;
      final rounded = (millions * 10).round() / 10;
      return '${rounded.toStringAsFixed(rounded.truncateToDouble() == rounded ? 0 : 1)}M';
    }
    if (amount >= 1000) {
      final thousands = (amount / 1000).round();
      return '${thousands}K';
    }
    return amount.toStringAsFixed(0);
  }
}
