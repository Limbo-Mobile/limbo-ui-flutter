import 'package:flutter/material.dart';
import 'package:limbo_ui_flutter/src/core/limbo_colors.dart';
import 'package:limbo_ui_flutter/src/core/limbo_tokens.dart';
import 'package:limbo_ui_flutter/src/core/limbo_typography.dart';

enum LimboSnackKind { info, success, error }

/// Floating, rounded snackbar with a tinted icon. Replaces ad-hoc
/// `ScaffoldMessenger...showSnackBar(SnackBar(Text(...)))` calls.
class LimboSnack {
  LimboSnack._();

  static void show(
    BuildContext context,
    String message, {
    LimboSnackKind kind = LimboSnackKind.info,
  }) {
    final (icon, color) = switch (kind) {
      LimboSnackKind.success => (Icons.check_circle_rounded, LimboColors.success),
      LimboSnackKind.error => (Icons.error_rounded, LimboColors.error),
      LimboSnackKind.info => (Icons.info_rounded, LimboColors.primary),
    };
    final messenger = ScaffoldMessenger.of(context);
    messenger
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          backgroundColor: LimboTokens.ink,
          margin: const EdgeInsets.fromLTRB(
            LimboTokens.s16,
            0,
            LimboTokens.s16,
            LimboTokens.s24,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(LimboTokens.rMedium),
          ),
          duration: const Duration(seconds: 3),
          content: Row(
            children: [
              Icon(icon, color: color, size: 22),
              const SizedBox(width: LimboTokens.s12),
              Expanded(
                child: Text(
                  message,
                  style: LimboTypography.headingSmall.copyWith(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: LimboColors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
  }
}
