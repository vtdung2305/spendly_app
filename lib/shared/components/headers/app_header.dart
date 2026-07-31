import 'package:flutter/material.dart';

import 'package:spendly_app/core/theme/app_colors.dart';

/// Shared full-bleed gradient header bar used by every screen whose design
/// matches this shape — Reports, Budget, Add/Edit Budget, Add/Edit
/// Transaction, Category List, Create/Edit Category, Edit Profile, Profile,
/// Settings, Income Management, Transaction History. Deliberately NOT used
/// by Dashboard (greeting+avatar), Calendar (prev/next month — recolored to
/// match but kept as its own bespoke widget), or the auth screens (centered
/// icon-tile) — none of those use the design's `headerBg`/`headerFg` tokens.
///
/// Per design: `background:linear-gradient(135deg, c.primary, c.splashEnd)`,
/// white title/subtitle/icons, 44×44 transparent icon buttons (`chevron_left`
/// leading, `add` trailing). The gradient bleeds under the status bar (per
/// design's full-bleed `position:sticky` header) — callers must NOT wrap
/// this widget in a top-consuming `SafeArea`; this widget adds the status
/// bar inset itself via `MediaQuery`, then 16 more, matching the design's
/// `padding:52px 16px 16px` (52 ≈ status bar + 16 on most devices).
class AppHeader extends StatelessWidget {
  const AppHeader({
    required this.title,
    required this.titleFontSize,
    this.subtitle,
    this.onBack,
    this.showLeadingSpacer = false,
    this.trailingIcon,
    this.onTrailingPressed,
    super.key,
  });

  final String title;
  final double titleFontSize;
  final String? subtitle;
  final VoidCallback? onBack;

  /// Budget's header has no back button but still needs a 44px leading gap
  /// so the centered title isn't skewed toward the trailing "+" button.
  final bool showLeadingSpacer;
  final IconData? trailingIcon;
  final VoidCallback? onTrailingPressed;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final hasLeading = onBack != null || showLeadingSpacer;
    final hasTrailing = trailingIcon != null;

    final titleColumn = Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          title,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: titleFontSize,
            fontWeight: FontWeight.w800,
            color: Colors.white,
            letterSpacing: -0.01 * titleFontSize,
          ),
        ),
        if (subtitle != null) ...[
          const SizedBox(height: 2),
          Text(
            subtitle!,
            textAlign: TextAlign.center,
            style: const TextStyle(
                fontSize: 11.5, color: Color.fromRGBO(255, 255, 255, 0.82)),
          ),
        ],
      ],
    );

    final topInset = MediaQuery.paddingOf(context).top;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(8, topInset+ 16, 8, 16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [colors.primary, colors.splashEnd],
        ),
        boxShadow: [
          BoxShadow(
            color: colors.primary.withValues(alpha: 0.22),
            blurRadius: 14,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          if (hasLeading) ...[
            onBack != null
                ? _HeaderIconButton(
                    icon: Icons.chevron_left_rounded,
                    iconSize: 32,
                    onTap: onBack,
                  )
                : const SizedBox(height: 44, width: 44),
            const SizedBox(width: 12),
          ],
          Expanded(
            child: hasLeading && !hasTrailing
                ? Padding(
                    padding: const EdgeInsets.only(right: 40),
                    child: titleColumn)
                : titleColumn,
          ),
          if (hasTrailing) ...[
            const SizedBox(width: 12),
            _HeaderIconButton(
              icon: trailingIcon!,
              iconSize: 26,
              onTap: onTrailingPressed,
            ),
          ],
        ],
      ),
    );
  }
}

class _HeaderIconButton extends StatelessWidget {
  const _HeaderIconButton({
    required this.icon,
    required this.iconSize,
    required this.onTap,
  });

  final IconData icon;
  final double iconSize;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 44,
      width: 44,
      child: Material(
        type: MaterialType.transparency,
        child: InkWell(
          onTap: onTap,
          child: Icon(icon, size: iconSize, color: Colors.white, fontWeight: FontWeight.w300),
        ),
      ),
    );
  }
}
