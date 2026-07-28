import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import 'package:spendly_app/core/localization/app_localizations_x.dart';
import 'package:spendly_app/core/theme/app_colors.dart';
import 'package:spendly_app/core/theme/app_radius.dart';
import 'package:spendly_app/shared/components/dialogs/app_confirm_dialog.dart';

/// Wraps a list row with swipe-left-to-reveal delete (fixed-width red
/// button, stays open until tapped or dismissed — confirm dialog before
/// removing) and tap-to-edit — shared by Transaction History and Income
/// Management rows, per design handoff ("giống Transaction History" /
/// "implemented once and reused").
class SwipeToDelete extends StatelessWidget {
  const SwipeToDelete({
    required this.itemKey,
    required this.child,
    required this.confirmTitle,
    required this.confirmDescription,
    required this.onDelete,
    this.onTap,
    super.key,
  });

  final Key itemKey;
  final Widget child;
  final String confirmTitle;
  final String confirmDescription;
  final VoidCallback onDelete;
  final VoidCallback? onTap;

  Future<void> _confirmAndDelete(BuildContext context) async {
    final confirmed = await AppConfirmDialog.show(
      context,
      icon: Icons.delete_rounded,
      title: confirmTitle,
      description: confirmDescription,
      cancelLabel: context.l10n.commonCancel,
      confirmLabel: context.l10n.commonDelete,
    );
    if (confirmed) onDelete();
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Slidable(
      key: itemKey,
      endActionPane: ActionPane(
        motion: const ScrollMotion(),
        extentRatio: 0.22,
        children: [
          CustomSlidableAction(
            onPressed: _confirmAndDelete,
            backgroundColor: colors.danger,
            borderRadius: BorderRadius.circular(AppRadius.sm),
            child: const Icon(Icons.delete_rounded, color: Colors.white),
          ),
        ],
      ),
      child: GestureDetector(onTap: onTap, child: child),
    );
  }
}
