import 'package:flutter/material.dart';

import 'package:spendly_app/core/theme/app_colors.dart';
import 'package:spendly_app/core/theme/app_shadow.dart';

/// Floating "add transaction" button, per design handoff — 52px circle,
/// Primary bg, colored shadow, shown independently of the bottom nav bar
/// (floats bottom-right on almost every non-auth screen).
class AppFab extends StatelessWidget {
  const AppFab({required this.onPressed, super.key});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        height: 52,
        width: 52,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: colors.primary,
          shape: BoxShape.circle,
          boxShadow: AppShadow.fab,
        ),
        child: const Icon(Icons.add_rounded, color: Colors.white, size: 26),
      ),
    );
  }
}
