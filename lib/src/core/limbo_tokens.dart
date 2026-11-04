import 'package:flutter/material.dart';
import 'package:limbo_ui_flutter/src/core/limbo_colors.dart';

/// Design tokens shared by every premium Limbo component: spacing, radii,
/// elevation and motion. Components must read these instead of hardcoding
/// numbers so the whole app breathes with one rhythm.
class LimboTokens {
  LimboTokens._();

  // ── Spacing (4pt grid) ────────────────────────────────────────────────────
  static const double s4 = 4;
  static const double s8 = 8;
  static const double s12 = 12;
  static const double s16 = 16;
  static const double s20 = 20;
  static const double s24 = 24;
  static const double s32 = 32;
  static const double s40 = 40;

  // ── Radii ─────────────────────────────────────────────────────────────────
  static const double rSmall = 10;
  static const double rMedium = 16;
  static const double rLarge = 24;
  static const double rPill = 999;

  // ── Brand surfaces ────────────────────────────────────────────────────────
  /// Near-black used for hero surfaces and premium headings.
  static const Color ink = Color(0xFF1F1A1A);

  /// Soft wash of the configured brand colour, used as a tinted surface
  /// behind brand content.
  static Color get brandWash =>
      Color.alphaBlend(LimboColors.primary.withValues(alpha: 0.1), LimboColors.white);

  /// Warm champagne accent for badges, highlights and rewards.
  static const Color champagne = Color(0xFFE9C46A);

  /// Hairline border for cards on white.
  static Color get hairline => LimboColors.backgroundObjectBorder;

  // ── Elevation ─────────────────────────────────────────────────────────────
  static List<BoxShadow> get shadowSoft => [
        BoxShadow(
          color: ink.withValues(alpha: 0.06),
          blurRadius: 18,
          offset: const Offset(0, 6),
        ),
      ];

  static List<BoxShadow> get shadowLifted => [
        BoxShadow(
          color: ink.withValues(alpha: 0.12),
          blurRadius: 32,
          offset: const Offset(0, 14),
        ),
      ];

  // ── Gradients ─────────────────────────────────────────────────────────────
  static LinearGradient get brandGradient => LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [LimboColors.primary, LimboColors.secondary],
      );

  // ── Motion ────────────────────────────────────────────────────────────────
  static const Duration fast = Duration(milliseconds: 140);
  static const Duration base = Duration(milliseconds: 260);
  static const Duration slow = Duration(milliseconds: 480);

  /// Default entrance curve: quick start, soft landing.
  static const Curve emphasized = Curves.easeOutCubic;

  /// Playful overshoot used for success states and favourites.
  static const Curve spring = Curves.elasticOut;
}
