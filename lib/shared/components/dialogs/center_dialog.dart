import 'package:flutter/material.dart';

import 'package:spendly_app/core/theme/app_colors.dart';
import 'package:spendly_app/core/theme/app_radius.dart';
import 'package:spendly_app/core/theme/app_shadow.dart';
import 'package:spendly_app/core/theme/app_spacing.dart';

/// Generic centered dialog chrome — scrim + scale/fade-in card with a
/// title row and rounded close button, per design handoff's dialog pattern
/// (e.g. the date picker, screens 5/6). Reusable for any centered dialog:
/// pass the body via [builder] and pop `dialogContext` with a result.
class CenterDialog extends StatelessWidget {
  const CenterDialog({
    required this.title,
    required this.child,
    required this.onClose,
    super.key,
  });

  final String title;
  final Widget child;
  final VoidCallback onClose;

  /// Shows the dialog centered on screen with a scale+fade transition and
  /// a 45%-opacity scrim, resolving to whatever [builder]'s content pops
  /// the dialog route with (or null if dismissed).
  static Future<T?> show<T>(
    BuildContext context, {
    required String title,
    required WidgetBuilder builder,
    bool barrierDismissible = true,
  }) {
    return showGeneralDialog<T>(
      context: context,
      barrierDismissible: barrierDismissible,
      barrierLabel: title,
      barrierColor: Colors.black.withValues(alpha: 0.45),
      transitionDuration: const Duration(milliseconds: 220),
      pageBuilder: (dialogContext, animation, secondaryAnimation) {
        return CenterDialog(
          title: title,
          onClose: () => Navigator.of(dialogContext).pop(),
          child: builder(dialogContext),
        );
      },
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        final curved =
            CurvedAnimation(parent: animation, curve: Curves.easeOut);
        return FadeTransition(
          opacity: curved,
          child: ScaleTransition(
            scale: Tween<double>(begin: 0.92, end: 1).animate(curved),
            child: child,
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 340),
          child: Material(
            color: Colors.transparent,
            child: Container(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.lgXl,
                AppSpacing.lgXl,
                AppSpacing.lgXl,
                AppSpacing.xl2,
              ),
              decoration: BoxDecoration(
                color: colors.surface,
                borderRadius: BorderRadius.circular(AppRadius.dialog),
                boxShadow: AppShadow.card,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(title,
                          style: Theme.of(context).textTheme.titleSmall),
                      InkWell(
                        onTap: onClose,
                        borderRadius: BorderRadius.circular(AppRadius.full),
                        child: Container(
                          height: 32,
                          width: 32,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: colors.surfaceAlt,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(Icons.close_rounded,
                              size: 18, color: colors.textSecondary),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.mdLg),
                  child,
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
