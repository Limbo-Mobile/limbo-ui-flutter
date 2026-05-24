import 'package:flutter/material.dart';
import 'package:limbo_ui_flutter/src/core/limbo_configuration.dart';

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
  static Color get primary => LimboConfiguration().primaryColor;

  /// Darker teal. Used as pressed/hover state for [primary].
  static Color get secondary => LimboConfiguration().secondaryColor;

  // ── Backgrounds ───────────────────────────────────────────────────────────

  /// Main app background (white).
  static Color get backgroundApp => LimboConfiguration().backgroundApp;

  /// Card / surface background. Used on text fields, list tiles, and
  /// chip containers.
  static Color get backgroundObject => LimboConfiguration().backgroundObject;

  /// Border colour for cards and surfaces.
  static Color get backgroundObjectBorder => LimboConfiguration().backgroundObjectBorder;

  // ── Text ──────────────────────────────────────────────────────────────────

  /// Primary text — headlines, labels, product names.
  static Color get textPrimary => LimboConfiguration().textPrimary;

  /// Secondary text — subtitles, metadata, "Vendido por" text.
  static Color get textSecondary => LimboConfiguration().textSecondary;

  /// Hint / placeholder text inside inputs.
  static Color get textHint => LimboConfiguration().textHint;

  // ── Grays ─────────────────────────────────────────────────────────────────

  /// Icon default colour.
  static Color get icons => LimboConfiguration().icons;

  /// Light divider / skeleton / disabled surface.
  static Color get lightGray => LimboConfiguration().lightGray;

  /// Mid-range gray — input borders, unselected items.
  static Color get gray => LimboConfiguration().gray;

  /// Muted text — timestamps, captions.
  static Color get darkerText => LimboConfiguration().darkerText;

  /// Normal gray — placeholders, empty states.
  static Color get normalGray => LimboConfiguration().normalGray;

  /// Dark gray — secondary icons, subdued text.
  static Color get darkGray => LimboConfiguration().darkGray;

  // ── Utility ───────────────────────────────────────────────────────────────

  /// Pure black reference.
  static Color get black => LimboConfiguration().black;

  /// Pure white reference.
  static Color get white => LimboConfiguration().white;

  /// Success green — price display, confirmation states.
  static Color get success => LimboConfiguration().success;

  /// Error / discount strikethrough red.
  static Color get error => LimboConfiguration().error;

  // ── Disabled state ────────────────────────────────────────────────────────

  /// Default disabled button/control background.
  static Color get disabled => LimboConfiguration().disabled;

  /// Text colour on top of a disabled surface.
  static Color get disabledText => LimboConfiguration().disabledText;
}
