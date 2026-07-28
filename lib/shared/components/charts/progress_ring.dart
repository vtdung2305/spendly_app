import 'package:flutter/material.dart';

import 'package:spendly_app/core/theme/app_animation.dart';

/// Single-value conic progress ring — used by the Dashboard budget summary
/// row ("62%" centered in a Primary-colored arc over a track).
class ProgressRing extends StatelessWidget {
  const ProgressRing({
    required this.percent,
    required this.progressColor,
    required this.trackColor,
    super.key,
    this.size = 56,
    this.strokeWidth = 6,
    this.centerLabel,
  });

  final double percent;
  final Color progressColor;
  final Color trackColor;
  final double size;
  final double strokeWidth;
  final Widget? centerLabel;

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: (percent / 100).clamp(0, 1)),
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
                painter: _ProgressRingPainter(
                  progress: value,
                  progressColor: progressColor,
                  trackColor: trackColor,
                  strokeWidth: strokeWidth,
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

class _ProgressRingPainter extends CustomPainter {
  const _ProgressRingPainter({
    required this.progress,
    required this.progressColor,
    required this.trackColor,
    required this.strokeWidth,
  });

  final double progress;
  final Color progressColor;
  final Color trackColor;
  final double strokeWidth;

  @override
  void paint(Canvas canvas, Size size) {
    final center = size.center(Offset.zero);
    final radius = (size.shortestSide - strokeWidth) / 2;

    final trackPaint = Paint()
      ..color = trackColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;
    canvas.drawCircle(center, radius, trackPaint);

    final progressPaint = Paint()
      ..color = progressColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -1.5708, // -90deg, start at top
      6.2832 * progress, // 2*pi * progress
      false,
      progressPaint,
    );
  }

  @override
  bool shouldRepaint(covariant _ProgressRingPainter oldDelegate) =>
      oldDelegate.progress != progress ||
      oldDelegate.progressColor != progressColor ||
      oldDelegate.trackColor != trackColor;
}
