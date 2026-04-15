/// Global configuration singleton for `limbo_ui_flutter`.
///
/// Must be initialised **once** at app startup, before `runApp()`.
///
/// ```dart
/// void main() {
///   LimboConfiguration().init(fontFamily: 'Poppins');
///   runApp(const MyApp());
/// }
/// ```
///
/// After init, every [LimboTypography] style will automatically use
/// the configured font. No widget needs to be updated individually.
class LimboConfiguration {
  // Singleton
  static final LimboConfiguration _instance = LimboConfiguration._internal();
  factory LimboConfiguration() => _instance;
  LimboConfiguration._internal();

  String _fontFamily = 'Poppins';

  /// Initialises the package with the given [fontFamily].
  ///
  /// [fontFamily] must be a valid Google Fonts font name
  /// (e.g. `'Poppins'`, `'Manrope'`, `'Mulish'`, `'Inter'`).
  ///
  /// Defaults to `'Poppins'` if not called.
  void init({String fontFamily = 'Poppins'}) {
    _fontFamily = fontFamily;
  }

  /// The currently configured font family name.
  String get fontFamily => _fontFamily;
}
