import 'package:flutter/material.dart';
import 'package:limbo_ui_flutter/src/components/motion/limbo_pressable.dart';
import 'package:limbo_ui_flutter/src/core/limbo_colors.dart';
import 'package:limbo_ui_flutter/src/core/limbo_tokens.dart';
import 'package:limbo_ui_flutter/src/core/limbo_typography.dart';

/// Surface card with hairline border and soft shadow. Optional [title] adds a
/// section heading; pass [onTap] to make the whole card pressable.
class LimboCard extends StatelessWidget {
  final Widget child;
  final String? title;
  final EdgeInsetsGeometry padding;
  final VoidCallback? onTap;
  final Color? color;

  const LimboCard({
    super.key,
    required this.child,
    this.title,
    this.padding = const EdgeInsets.all(LimboTokens.s16),
    this.onTap,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final card = Container(
      width: double.infinity,
      padding: padding,
      decoration: BoxDecoration(
        color: color ?? LimboColors.white,
        borderRadius: BorderRadius.circular(LimboTokens.rMedium),
        border: Border.all(color: LimboTokens.hairline),
        boxShadow: LimboTokens.shadowSoft,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (title != null) ...[
            Text(title!, style: LimboTypography.headingSmall),
            const SizedBox(height: LimboTokens.s12),
          ],
          child,
        ],
      ),
    );
    return onTap == null ? card : LimboPressable(onTap: onTap, child: card);
  }
}
