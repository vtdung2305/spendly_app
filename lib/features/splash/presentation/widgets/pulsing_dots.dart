import 'package:flutter/material.dart';

import '../../../../core/theme/app_animation.dart';

/// 3 dots pulsing in sequence — Splash loading indicator per design handoff.
class PulsingDots extends StatefulWidget {
  const PulsingDots({super.key});

  @override
  State<PulsingDots> createState() => _PulsingDotsState();
}

class _PulsingDotsState extends State<PulsingDots> with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: AppAnimation.dotsPulse,
  )..repeat();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(3, (index) {
        return AnimatedBuilder(
          animation: _controller,
          builder: (context, _) {
            final t = (_controller.value - index * 0.2) % 1.0;
            final opacity = 0.35 + 0.65 * (0.5 + 0.5 * (t < 0.5 ? t * 2 : (1 - t) * 2));
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: Opacity(
                opacity: opacity.clamp(0.35, 1.0),
                child: Container(
                  height: 8,
                  width: 8,
                  decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                ),
              ),
            );
          },
        );
      }),
    );
  }
}
