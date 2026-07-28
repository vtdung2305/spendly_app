import 'package:flutter/material.dart';

import 'package:spendly_app/core/theme/app_animation.dart';
import 'package:spendly_app/core/theme/app_radius.dart';

/// Primary filled CTA button — 52px height, radius 16, spinner while
/// [isLoading], 45% opacity when [onPressed] is null (disabled).
class AppButton extends StatefulWidget {
  const AppButton({
    required this.label,
    required this.onPressed,
    super.key,
    this.isLoading = false,
    this.backgroundColor,
    this.foregroundColor,
  });

  final String label;
  final VoidCallback? onPressed;
  final bool isLoading;
  final Color? backgroundColor;
  final Color? foregroundColor;

  @override
  State<AppButton> createState() => _AppButtonState();
}

class _AppButtonState extends State<AppButton> {
  bool _pressed = false;

  bool get _enabled => widget.onPressed != null && !widget.isLoading;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final background = widget.backgroundColor ?? theme.colorScheme.primary;
    final foreground = widget.foregroundColor ?? Colors.white;

    return Opacity(
      opacity: _enabled ? 1.0 : 0.45,
      child: GestureDetector(
        onTapDown: _enabled ? (_) => setState(() => _pressed = true) : null,
        onTapCancel: () => setState(() => _pressed = false),
        onTapUp: _enabled ? (_) => setState(() => _pressed = false) : null,
        child: AnimatedScale(
          scale: _pressed ? 0.97 : 1.0,
          duration: AppAnimation.buttonPress,
          child: SizedBox(
            height: 52,
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _enabled ? widget.onPressed : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: background,
                disabledBackgroundColor: background,
                foregroundColor: foreground,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppRadius.lg),
                ),
                elevation: 0,
              ),
              child: widget.isLoading
                  ? SizedBox(
                      height: 22,
                      width: 22,
                      child: CircularProgressIndicator(
                        strokeWidth: 2.5,
                        valueColor: AlwaysStoppedAnimation(foreground),
                      ),
                    )
                  : Text(
                      widget.label,
                      style: theme.textTheme.titleSmall
                          ?.copyWith(color: foreground),
                    ),
            ),
          ),
        ),
      ),
    );
  }
}
