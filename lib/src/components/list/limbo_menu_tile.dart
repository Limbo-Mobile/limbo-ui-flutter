import 'package:flutter/material.dart';
import 'package:limbo_ui_flutter/src/components/motion/limbo_pressable.dart';
import 'package:limbo_ui_flutter/src/core/limbo_colors.dart';
import 'package:limbo_ui_flutter/src/core/limbo_tokens.dart';
import 'package:limbo_ui_flutter/src/core/limbo_typography.dart';

/// Row used in settings-like lists: tinted icon badge, label, optional
/// subtitle and a chevron. Use [destructive] for actions like "Cerrar sesión".
class LimboMenuTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final String? subtitle;
  final VoidCallback? onTap;
  final bool destructive;
  final Widget? trailing;

  const LimboMenuTile({
    super.key,
    required this.icon,
    required this.label,
    this.subtitle,
    this.onTap,
    this.destructive = false,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    final accent = destructive ? LimboColors.error : LimboColors.primary;
    return LimboPressable(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: LimboTokens.s12),
        padding: const EdgeInsets.symmetric(
          horizontal: LimboTokens.s16,
          vertical: LimboTokens.s12,
        ),
        decoration: BoxDecoration(
          color: LimboColors.white,
          borderRadius: BorderRadius.circular(LimboTokens.rMedium),
          border: Border.all(color: LimboTokens.hairline),
        ),
        child: Row(
          children: [
            Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: accent.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(LimboTokens.rSmall + 2),
              ),
              child: Icon(icon, color: accent, size: 22),
            ),
            const SizedBox(width: LimboTokens.s16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: LimboTypography.headingSmall.copyWith(
                      color: destructive ? LimboColors.error : null,
                    ),
                  ),
                  if (subtitle != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 2),
                      child: Text(
                        subtitle!,
                        style: LimboTypography.headingSmall.copyWith(
                          fontSize: 13,
                          fontWeight: FontWeight.w400,
                          color: LimboColors.textSecondary,
                        ),
                      ),
                    ),
                ],
              ),
            ),
            trailing ??
                Icon(
                  Icons.chevron_right_rounded,
                  color: LimboColors.icons,
                ),
          ],
        ),
      ),
    );
  }
}
