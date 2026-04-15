import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:limbo_ui_flutter/src/core/limbo_colors.dart';
import 'package:limbo_ui_flutter/src/core/limbo_configuration.dart';

/// A centralised typography scale for `limbo_ui_flutter`.
///
/// Every style uses the font family configured via [LimboConfiguration].
/// Components must use these styles instead of calling [GoogleFonts] directly.
///
/// ```dart
/// // In main.dart (app side):
/// LimboConfiguration().init(fontFamily: 'Manrope');
///
/// // In any widget:
/// Text('Hola', style: LimboTypography.bodyMedium)
/// ```
class LimboTypography {
  LimboTypography._();

  static String get _font => LimboConfiguration().fontFamily;

  // ── Heading ───────────────────────────────────────────────────────────────

  /// Large page/screen title. 22sp, bold.
  static TextStyle get headingLarge => GoogleFonts.getFont(
        _font,
        fontSize: 22,
        fontWeight: FontWeight.bold,
        color: LimboColors.black,
      );

  /// Section heading. 18sp, bold.
  static TextStyle get headingMedium => GoogleFonts.getFont(
        _font,
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: LimboColors.black,
      );

  /// Sub-section heading. 16sp, semibold.
  static TextStyle get headingSmall => GoogleFonts.getFont(
        _font,
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: LimboColors.black,
      );

  // ── Section title (with dividers) ─────────────────────────────────────────

  /// Used in [LimboOptionsTitle]. 24sp, medium weight, primary color.
  static TextStyle get sectionTitle => GoogleFonts.getFont(
        _font,
        fontSize: 24,
        fontWeight: FontWeight.w500,
        color: LimboColors.primary,
      );

  /// Used in [LimboCategoryTitle]. 18sp, normal weight.
  static TextStyle get categoryTitle => GoogleFonts.getFont(
        _font,
        fontSize: 18,
        letterSpacing: 0.4,
        color: LimboColors.black,
      );

  // ── Body ──────────────────────────────────────────────────────────────────

  /// Standard body text. 16sp.
  static TextStyle get bodyLarge => GoogleFonts.getFont(
        _font,
        fontSize: 16,
        color: LimboColors.black,
      );

  /// Secondary body text. 14sp.
  static TextStyle get bodyMedium => GoogleFonts.getFont(
        _font,
        fontSize: 14,
        color: LimboColors.black,
      );

  /// Small body text. 13sp.
  static TextStyle get bodySmall => GoogleFonts.getFont(
        _font,
        fontSize: 13,
        color: LimboColors.darkerText,
      );

  // ── Label / Filter ────────────────────────────────────────────────────────

  /// Filter/slider price labels. 14sp.
  static TextStyle get filterLabel => GoogleFonts.getFont(
        _font,
        fontSize: 14,
        color: LimboColors.black,
      );

  /// Filter section heading (e.g. "Escala de Precios"). 17sp.
  static TextStyle get filterSectionHeading => GoogleFonts.getFont(
        _font,
        fontSize: 17,
        color: LimboColors.black,
      );

  /// Color grid label. 11sp.
  static TextStyle get colorLabel => GoogleFonts.getFont(
        _font,
        fontSize: 11,
        color: LimboColors.black,
      );

  // ── Button ────────────────────────────────────────────────────────────────

  /// Text inside [LimboButton]. 16sp, bold, white.
  static TextStyle get button => GoogleFonts.getFont(
        _font,
        fontSize: 16,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      );

  /// Auth button text. 15sp, bold, white.
  static TextStyle get authButton => GoogleFonts.getFont(
        _font,
        fontSize: 15,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      );

  // ── Form ──────────────────────────────────────────────────────────────────

  /// Input hint text. 14sp, gray.
  static TextStyle get hint => GoogleFonts.getFont(
        _font,
        fontSize: 14,
        color: LimboColors.gray,
      );

  // ── Sort options ──────────────────────────────────────────────────────────

  /// Sort-option label. 15sp.
  static TextStyle get sortLabel => GoogleFonts.getFont(
        _font,
        fontSize: 15,
        color: LimboColors.black,
      );

  /// Sort-option label when selected. 15sp, bold.
  static TextStyle get sortLabelSelected => GoogleFonts.getFont(
        _font,
        fontSize: 15,
        fontWeight: FontWeight.bold,
        color: LimboColors.black,
      );
}
