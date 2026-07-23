import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/utils/currency_formatter.dart';

/// Gradient Primary→accent hero card — "TIẾT KIỆM THÁNG NÀY" + big amount +
/// 2-up Thu nhập/Chi tiêu mini stats, per Dashboard layout row 2.
class HeroSavingsCard extends StatelessWidget {
  const HeroSavingsCard({
    required this.savings,
    required this.income,
    required this.expense,
    super.key,
  });

  final double savings;
  final double income;
  final double expense;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Container(
      padding: const EdgeInsets.all(AppSpacing.xl),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppRadius.hero),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [colors.primary, colors.splashEnd],
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'TIẾT KIỆM THÁNG NÀY',
            style: AppTypography.mono(
              fontSize: 11,
              fontWeight: FontWeight.w500,
              color: Colors.white.withValues(alpha: 0.7),
              letterSpacing: 0.8,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            CurrencyFormatter.format(savings),
            style: AppTypography.mono(fontSize: 30, fontWeight: FontWeight.w800, color: Colors.white),
          ),
          const SizedBox(height: 18),
          Row(
            children: [
              Expanded(child: _MiniStat(label: 'Thu nhập', amount: income)),
              const SizedBox(width: 12),
              Expanded(child: _MiniStat(label: 'Chi tiêu', amount: expense)),
            ],
          ),
        ],
      ),
    );
  }
}

class _MiniStat extends StatelessWidget {
  const _MiniStat({required this.label, required this.amount});

  final String label;
  final double amount;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.14),
        borderRadius: BorderRadius.circular(AppRadius.md),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: TextStyle(fontSize: 12, color: Colors.white.withValues(alpha: 0.85))),
          const SizedBox(height: 2),
          Text(
            CurrencyFormatter.formatPlain(amount),
            style: AppTypography.mono(fontSize: 15, fontWeight: FontWeight.w700, color: Colors.white),
          ),
        ],
      ),
    );
  }
}
