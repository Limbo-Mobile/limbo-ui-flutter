import 'package:flutter/material.dart';
import 'package:limbo_ui_flutter/src/components/motion/limbo_reveal.dart';
import 'package:limbo_ui_flutter/src/core/limbo_colors.dart';
import 'package:limbo_ui_flutter/src/core/limbo_tokens.dart';
import 'package:limbo_ui_flutter/src/core/limbo_typography.dart';

/// Centered illustration-style state for empty lists and failed loads.
/// Provide [actionLabel] + [onAction] to offer a retry or a next step.
class LimboEmptyState extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? message;
  final String? actionLabel;
  final VoidCallback? onAction;

  const LimboEmptyState({
    super.key,
    required this.icon,
    required this.title,
    this.message,
    this.actionLabel,
    this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(LimboTokens.s32),
        child: LimboReveal(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 84,
                height: 84,
                decoration: BoxDecoration(
                  color: LimboTokens.brandWash,
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, size: 38, color: LimboColors.primary),
              ),
              const SizedBox(height: LimboTokens.s20),
              Text(
                title,
                textAlign: TextAlign.center,
                style: LimboTypography.headingSmall,
              ),
              if (message != null) ...[
                const SizedBox(height: LimboTokens.s8),
                Text(
                  message!,
                  textAlign: TextAlign.center,
                  style: LimboTypography.headingSmall.copyWith(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: LimboColors.textSecondary,
                  ),
                ),
              ],
              if (actionLabel != null && onAction != null) ...[
                const SizedBox(height: LimboTokens.s20),
                TextButton(
                  onPressed: onAction,
                  child: Text(
                    actionLabel!,
                    style: TextStyle(
                      color: LimboColors.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
