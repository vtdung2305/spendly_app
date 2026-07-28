import 'package:flutter/material.dart';

import 'package:spendly_app/core/theme/app_animation.dart';

class DonutSlice {
  const DonutSlice({required this.color, required this.percent});
  final Color color;
  final double percent;
}

/// Multi-segment conic donut — used by category breakdown pie cards
/// (Dashboard, Reports).
class DonutChart extends StatelessWidget {
  const DonutChart({
    required this.slices,
    super.key,
    this.size = 96,
    this.strokeWidth = 16,
    this.centerLabel,
  });

  final List<DonutSlice> slices;
  final double size;
  final double strokeWidth;
  final Widget? centerLabel;

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: AppAnimation.chartValue,
      curve: Curves.easeOut,
      builder: (context, value, _) {
        return SizedBox(
          height: size,
          width: size,
          child: Stack(
            alignment: Alignment.center,
            children: [
              CustomPaint(
                size: Size(size, size),
                painter: _DonutChartPainter(
                  slices: slices,
                  strokeWidth: strokeWidth,
                  animationValue: value,
                ),
              ),
              if (centerLabel != null) centerLabel!,
            ],
          ),
        );
      },
    );
  }
}

class _DonutChartPainter extends CustomPainter {
  const _DonutChartPainter({
    required this.slices,
    required this.strokeWidth,
    required this.animationValue,
  });

  final List<DonutSlice> slices;
  final double strokeWidth;
  final double animationValue;

  @override
  void paint(Canvas canvas, Size size) {
    final center = size.center(Offset.zero);
    final radius = (size.shortestSide - strokeWidth) / 2;
    final rect = Rect.fromCircle(center: center, radius: radius);

    var startAngle = -1.5708; // -90deg
    for (final slice in slices) {
      final sweep = 6.2832 * (slice.percent / 100) * animationValue;
      final paint = Paint()
        ..color = slice.color
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth
        ..strokeCap = StrokeCap.butt;
      canvas.drawArc(rect, startAngle, sweep, false, paint);
      startAngle += sweep;
    }
  }

  @override
  bool shouldRepaint(covariant _DonutChartPainter oldDelegate) =>
      oldDelegate.slices != slices ||
      oldDelegate.animationValue != animationValue;
}
