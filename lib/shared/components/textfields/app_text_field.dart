import 'package:flutter/material.dart';

import 'package:spendly_app/core/theme/app_colors.dart';
import 'package:spendly_app/core/theme/app_radius.dart';

/// Outlined input field — 50px height, radius 14, Surface bg, leading icon.
/// Shows inline error text + red border when [errorText] is set.
class AppTextField extends StatelessWidget {
  const AppTextField({
    required this.hintText,
    required this.icon,
    super.key,
    this.controller,
    this.obscureText = false,
    this.keyboardType,
    this.errorText,
    this.suffixIcon,
    this.onChanged,
  });

  final String hintText;
  final IconData icon;
  final TextEditingController? controller;
  final bool obscureText;
  final TextInputType? keyboardType;
  final String? errorText;
  final Widget? suffixIcon;
  final ValueChanged<String>? onChanged;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final hasError = errorText != null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 50,
          child: TextField(
            controller: controller,
            obscureText: obscureText,
            keyboardType: keyboardType,
            onChanged: onChanged,
            style: Theme.of(context).textTheme.bodyLarge,
            decoration: InputDecoration(
              hintText: hintText,
              hintStyle: Theme.of(context)
                  .textTheme
                  .bodyLarge
                  ?.copyWith(color: colors.textTertiary),
              prefixIcon: Icon(icon, size: 20, color: colors.textSecondary),
              suffixIcon: suffixIcon,
              filled: true,
              fillColor: colors.surface,
              contentPadding: const EdgeInsets.symmetric(horizontal: 14),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppRadius.md),
                borderSide: BorderSide(
                  color: hasError ? colors.danger : colors.border,
                  width: hasError ? 1.5 : 1,
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppRadius.md),
                borderSide: BorderSide(
                  color: hasError ? colors.danger : colors.border,
                  width: hasError ? 1.5 : 1,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppRadius.md),
                borderSide: BorderSide(
                    color: hasError ? colors.danger : colors.primary,
                    width: 1.5),
              ),
            ),
          ),
        ),
        if (hasError)
          Padding(
            padding: const EdgeInsets.only(top: 6),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.error_rounded, size: 14, color: colors.danger),
                const SizedBox(width: 5),
                Flexible(
                  child: Text(
                    errorText!,
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: colors.danger,
                        fontSize: 11.5,
                        fontWeight: FontWeight.w600),
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}
