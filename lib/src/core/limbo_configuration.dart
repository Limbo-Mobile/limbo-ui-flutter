import 'package:flutter/material.dart';

/// Global configuration singleton for `limbo_ui_flutter`.
///
/// Must be initialised **once** at app startup, before `runApp()`.
///
/// ```dart
/// void main() {
///   LimboConfiguration().init(
///     fontFamily: 'Poppins',
///     colorsJson: {
///       'primary': '#19B4B3',
///     },
///   );
///   runApp(const MyApp());
/// }
/// ```
class LimboConfiguration with ChangeNotifier {
  // Singleton
  static final LimboConfiguration _instance = LimboConfiguration._internal();
  factory LimboConfiguration() => _instance;
  LimboConfiguration._internal();

  String _fontFamily = 'Poppins';
  String? _fontFamilyFallback;

  // Colors config
  Color primaryColor = const Color(0xFF19B4B3);
  Color secondaryColor = const Color(0xFF148584);
  Color backgroundApp = const Color(0xFFFFFFFF);
  Color backgroundObject = const Color(0xFFF6F6F6);
  Color backgroundObjectBorder = const Color(0xFFE8E8E8);
  Color textPrimary = const Color(0xFF000000);
  Color textSecondary = const Color(0xFF676767);
  Color textHint = const Color(0xFFBDBDBD);
  Color icons = const Color(0xFF9C9C9C);
  Color lightGray = const Color(0xFFDEE1E1);
  Color gray = const Color(0xFFBDBDBD);
  Color darkerText = const Color(0xFF828282);
  Color normalGray = const Color(0xFFD9D9D9);
  Color darkGray = const Color(0xFFA4A4A4);
  Color black = const Color(0xFF000000);
  Color white = const Color(0xFFFFFFFF);
  Color success = const Color(0xFF4CAF50);
  Color error = const Color(0xFFF44336);
  Color disabled = const Color(0xFFBDBDBD);
  Color disabledText = const Color(0xFF9E9E9E);

  /// Initialises the package with the given [fontFamily], [fontFamilyFallback], and [colorsJson].
  ///
  /// [fontFamily] must be a valid Google Fonts font name.
  /// Defaults to `'Poppins'` if not called.
  void init({
    String fontFamily = 'Poppins',
    String? fontFamilyFallback,
    Map<String, dynamic>? colorsJson,
  }) {
    _fontFamily = fontFamily;
    _fontFamilyFallback = fontFamilyFallback;

    if (colorsJson != null) {
      final Map<String, dynamic> data = (colorsJson['data'] is Map<String, dynamic>)
          ? colorsJson['data'] as Map<String, dynamic>
          : colorsJson;
      if (data['primary'] != null) primaryColor = _parseColor(data['primary']) ?? primaryColor;
      if (data['secondary'] != null) secondaryColor = _parseColor(data['secondary']) ?? secondaryColor;
      if (data['background_app'] != null) backgroundApp = _parseColor(data['background_app']) ?? backgroundApp;
      if (data['background_object'] != null) backgroundObject = _parseColor(data['background_object']) ?? backgroundObject;
      if (data['background_object_border'] != null) backgroundObjectBorder = _parseColor(data['background_object_border']) ?? backgroundObjectBorder;
      if (data['text_primary'] != null) textPrimary = _parseColor(data['text_primary']) ?? textPrimary;
      if (data['text_secondary'] != null) textSecondary = _parseColor(data['text_secondary']) ?? textSecondary;
      if (data['text_hint'] != null) textHint = _parseColor(data['text_hint']) ?? textHint;
      if (data['icons'] != null) icons = _parseColor(data['icons']) ?? icons;
      if (data['light_gray'] != null) lightGray = _parseColor(data['light_gray']) ?? lightGray;
      if (data['gray'] != null) gray = _parseColor(data['gray']) ?? gray;
      if (data['darker_text'] != null) darkerText = _parseColor(data['darker_text']) ?? darkerText;
      if (data['normal_gray'] != null) normalGray = _parseColor(data['normal_gray']) ?? normalGray;
      if (data['dark_gray'] != null) darkGray = _parseColor(data['dark_gray']) ?? darkGray;
      if (data['black'] != null) black = _parseColor(data['black']) ?? black;
      if (data['white'] != null) white = _parseColor(data['white']) ?? white;
      if (data['success'] != null) success = _parseColor(data['success']) ?? success;
      if (data['error'] != null) error = _parseColor(data['error']) ?? error;
      if (data['disabled'] != null) disabled = _parseColor(data['disabled']) ?? disabled;
      if (data['disabled_text'] != null) disabledText = _parseColor(data['disabled_text']) ?? disabledText;
    }
  }

  /// The currently configured font family name.
  String get fontFamily => _fontFamily;

  /// The currently configured font family fallback.
  String? get fontFamilyFallback => _fontFamilyFallback;

  /// Configure typography with custom font family at runtime
  void setTypography({required String fontFamily, String? fontFamilyFallback}) {
    _fontFamily = fontFamily;
    _fontFamilyFallback = fontFamilyFallback;
    notifyListeners();
  }

  Color? _parseColor(dynamic val) {
    if (val == null) return null;
    if (val is Color) return val;
    final hexColor = val.toString().replaceAll('#', '');
    if (hexColor.isEmpty) return null;
    try {
      String hexStr = hexColor;
      if (hexStr.length == 6) {
        hexStr = 'FF$hexStr';
      }
      return Color(int.parse('0x$hexStr'));
    } catch (_) {
      return null;
    }
  }
}
