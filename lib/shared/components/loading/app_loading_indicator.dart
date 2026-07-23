import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';

/// Standard first-load indicator — use in place of ad-hoc CircularProgressIndicator.
class AppLoadingIndicator extends StatelessWidget {
  const AppLoadingIndicator({super.key, this.size = 28});

  final double size;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        height: size,
        width: size,
        child: CircularProgressIndicator(
          strokeWidth: 2.5,
          valueColor: AlwaysStoppedAnimation(context.colors.primary),
        ),
      ),
    );
  }
}

/// Shimmer placeholder block for skeleton loading states (chart cards,
/// list rows, calendar grid) per design handoff "Loading" states.
class AppShimmerBlock extends StatefulWidget {
  const AppShimmerBlock({
    required this.height,
    super.key,
    this.width = double.infinity,
    this.radius = 12,
  });

  final double height;
  final double width;
  final double radius;

  @override
  State<AppShimmerBlock> createState() => _AppShimmerBlockState();
}

class _AppShimmerBlockState extends State<AppShimmerBlock>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1200),
  )..repeat();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final base = context.colors.surfaceAlt;
    final highlight = context.colors.border;
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        return Container(
          height: widget.height,
          width: widget.width,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(widget.radius),
            gradient: LinearGradient(
              begin: Alignment(-1 + _controller.value * 2, 0),
              end: Alignment(1 + _controller.value * 2, 0),
              colors: [base, highlight, base],
              stops: const [0.35, 0.5, 0.65],
            ),
          ),
        );
      },
    );
  }
}
