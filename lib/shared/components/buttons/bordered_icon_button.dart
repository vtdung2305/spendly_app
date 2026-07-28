import 'package:flutter/material.dart';

import 'package:spendly_app/core/theme/app_colors.dart';
import 'package:spendly_app/core/theme/app_radius.dart';

/// 38×38 bordered Surface square with radius 12 — the back/close icon
/// button style used on Register and Add Transaction headers (per design
/// handoff, e.g. `width:38px;height:38px;border-radius:12px;background:{{
/// c.surface }};border:1px solid {{ c.border }}`).
class BorderedIconButton extends StatelessWidget {
  const BorderedIconButton(
      {required this.icon, required this.onPressed, super.key});

  final IconData icon;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(AppRadius.sm),
      child: Container(
        height: 38,
        width: 38,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: colors.surface,
          borderRadius: BorderRadius.circular(AppRadius.sm),
          border: Border.all(color: colors.border),
        ),
        child: Icon(icon, size: 20, color: colors.textPrimary),
      ),
    );
  }
}
