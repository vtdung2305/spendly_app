import 'package:flutter/material.dart';

import 'package:spendly_app/core/theme/app_colors.dart';
import 'package:spendly_app/core/theme/app_radius.dart';

/// 40x24 pill + 18x18 white knob — the app's one on/off switch style (Profile's
/// Dark mode toggle, Recurring Transaction Form's "Đang hoạt động", Notification
/// Center's reminder toggles). Off = slate #CBD5E1, on = theme primary.
class AppToggleSwitch extends StatelessWidget {
  const AppToggleSwitch({required this.value, required this.onTap, super.key});

  final bool value;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        height: 24,
        width: 40,
        padding: const EdgeInsets.all(3),
        decoration: BoxDecoration(
          color: value ? colors.primary : const Color(0xFFCBD5E1),
          borderRadius: BorderRadius.circular(AppRadius.full),
        ),
        child: AnimatedAlign(
          duration: const Duration(milliseconds: 200),
          alignment: value ? Alignment.centerRight : Alignment.centerLeft,
          child: Container(
            height: 18,
            width: 18,
            decoration: const BoxDecoration(
                color: Colors.white, shape: BoxShape.circle),
          ),
        ),
      ),
    );
  }
}
