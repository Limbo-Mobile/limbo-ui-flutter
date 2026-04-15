import 'package:flutter/material.dart';

/// Limbo 2024 Design System — Color Palette
///
/// All colors extracted directly from the Limbo app source code and aligned
/// with the LIMBO-2024 Figma design. Use these constants throughout the
/// package to ensure visual consistency.
///
/// ## Usage
/// ```dart
/// Container(color: LimboColors.primary)
/// Text('...', style: TextStyle(color: LimboColors.textPrimary))
/// ```
class LimboColors {
  LimboColors._();

  // ── Brand ─────────────────────────────────────────────────────────────────

  /// Main brand teal. Used on primary buttons, active tabs, focused borders,
  /// selected color indicators, and all interactive highlights.
  static const Color primary = Color(0xFF19B4B3);

  /// Darker teal. Used as pressed/hover state for [primary].
  static const Color secondary = Color(0xFF148584);

  // ── Backgrounds ───────────────────────────────────────────────────────────

  /// Main app background (white).
  static const Color backgroundApp = Color(0xFFFFFFFF);

  /// Card / surface background. Used on text fields, list tiles, and
  /// chip containers.
  static const Color backgroundObject = Color(0xFFF6F6F6);

  /// Border colour for cards and surfaces.
  static const Color backgroundObjectBorder = Color(0xFFE8E8E8);

  // ── Text ──────────────────────────────────────────────────────────────────

  /// Primary text — headlines, labels, product names.
  static const Color textPrimary = Color(0xFF000000);

  /// Secondary text — subtitles, metadata, "Vendido por" text.
  static const Color textSecondary = Color(0xFF676767);

  /// Hint / placeholder text inside inputs.
  static const Color textHint = Color(0xFFBDBDBD);

  // ── Grays ─────────────────────────────────────────────────────────────────

  /// Icon default colour.
  static const Color icons = Color(0xFF9C9C9C);

  /// Light divider / skeleton / disabled surface.
  static const Color lightGray = Color(0xFFDEE1E1);

  /// Mid-range gray — input borders, unselected items.
  static const Color gray = Color(0xFFBDBDBD);

  /// Muted text — timestamps, captions.
  static const Color darkerText = Color(0xFF828282);

  /// Normal gray — placeholders, empty states.
  static const Color normalGray = Color(0xFFD9D9D9);

  /// Dark gray — secondary icons, subdued text.
  static const Color darkGray = Color(0xFFA4A4A4);

  // ── Utility ───────────────────────────────────────────────────────────────

  /// Pure black reference.
  static const Color black = Color(0xFF000000);

  /// Pure white reference.
  static const Color white = Color(0xFFFFFFFF);

  /// Success green — price display, confirmation states.
  static const Color success = Color(0xFF4CAF50);

  /// Error / discount strikethrough red.
  static const Color error = Color(0xFFF44336);

  // ── Disabled state ────────────────────────────────────────────────────────

  /// Default disabled button/control background.
  static const Color disabled = Color(0xFFBDBDBD);

  /// Text colour on top of a disabled surface.
  static const Color disabledText = Color(0xFF9E9E9E);
}
