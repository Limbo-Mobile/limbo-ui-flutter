import 'package:flutter/material.dart';
import 'package:limbo_ui_flutter/src/core/limbo_colors.dart';
import 'package:limbo_ui_flutter/src/core/limbo_tokens.dart';
import 'package:limbo_ui_flutter/src/core/limbo_typography.dart';

/// Label on the left, value on the right. Use [emphasized] for totals and
/// [valueColor] for discounts/status values.
class LimboKeyValueRow extends StatelessWidget {
  final String label;
  final String value;
  final bool emphasized;
  final Color? valueColor;

  const LimboKeyValueRow({
    super.key,
    required this.label,
    required this.value,
    this.emphasized = false,
    this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    final base = LimboTypography.headingSmall.copyWith(
      fontSize: emphasized ? 16 : 14,
      fontWeight: emphasized ? FontWeight.w700 : FontWeight.w400,
    );
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: LimboTokens.s4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Text(
              label,
              style: base.copyWith(
                color: emphasized
                    ? LimboColors.textPrimary
                    : LimboColors.textSecondary,
              ),
            ),
          ),
          const SizedBox(width: LimboTokens.s12),
          Flexible(
            child: Text(
              value,
              textAlign: TextAlign.end,
              style: base.copyWith(
                fontWeight: FontWeight.w600,
                color: valueColor ?? LimboColors.textPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
