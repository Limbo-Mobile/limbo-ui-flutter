/// Common form field validators for the Limbo design system.
///
/// Each validator returns `null` on success or an error string on failure.
/// Plug them directly into [LimboFormField.validator].
///
/// ```dart
/// LimboFormField(
///   controller: _emailController,
///   hintText: 'Correo electrónico',
///   icon: Icons.email,
///   validator: LimboValidators.email,
/// )
/// ```
class LimboValidators {
  LimboValidators._();

  // ── Required ──────────────────────────────────────────────────────────────

  /// Rejects blank or whitespace-only values.
  static String? required(String? value, {String message = 'Campo requerido'}) {
    if (value == null || value.trim().isEmpty) return message;
    return null;
  }

  // ── Email ─────────────────────────────────────────────────────────────────

  static final _emailRegex = RegExp(
    r'^[a-zA-Z0-9._%+\-]+@[a-zA-Z0-9.\-]+\.[a-zA-Z]{2,}$',
  );

  /// Validates that the value is a well-formed email address.
  static String? email(String? value,
      {String message = 'Correo electrónico inválido'}) {
    if (value == null || value.trim().isEmpty) return 'Campo requerido';
    if (!_emailRegex.hasMatch(value.trim())) return message;
    return null;
  }

  // ── Password ──────────────────────────────────────────────────────────────

  /// Validates minimum password length (default: 8 characters).
  static String? Function(String?) minLength(int min,
      {String? message}) {
    return (String? value) {
      if (value == null || value.isEmpty) return 'Campo requerido';
      if (value.length < min) {
        return message ?? 'Mínimo $min caracteres';
      }
      return null;
    };
  }

  /// Validates that the password meets standard security requirements:
  /// - At least 8 characters
  /// - At least one uppercase letter
  /// - At least one lowercase letter
  /// - At least one digit
  static String? password(String? value) {
    if (value == null || value.isEmpty) return 'Campo requerido';
    if (value.length < 8) return 'Mínimo 8 caracteres';
    if (!RegExp(r'[A-Z]').hasMatch(value)) {
      return 'Debe contener al menos una mayúscula';
    }
    if (!RegExp(r'[a-z]').hasMatch(value)) {
      return 'Debe contener al menos una minúscula';
    }
    if (!RegExp(r'[0-9]').hasMatch(value)) {
      return 'Debe contener al menos un número';
    }
    return null;
  }

  /// Returns a validator that checks [value] matches [other].
  /// Useful for password confirmation fields.
  ///
  /// ```dart
  /// validator: LimboValidators.matches(
  ///   () => _passwordController.text,
  ///   message: 'Las contraseñas no coinciden',
  /// ),
  /// ```
  static String? Function(String?) matches(
    String Function() other, {
    String message = 'Los campos no coinciden',
  }) {
    return (String? value) {
      if (value == null || value.isEmpty) return 'Campo requerido';
      if (value != other()) return message;
      return null;
    };
  }

  // ── Phone ─────────────────────────────────────────────────────────────────

  static final _phoneRegex = RegExp(r'^\+?[0-9]{7,15}$');

  /// Validates that the value is a phone number (7–15 digits, optional + prefix).
  static String? phone(String? value,
      {String message = 'Número de teléfono inválido'}) {
    if (value == null || value.trim().isEmpty) return 'Campo requerido';
    if (!_phoneRegex.hasMatch(value.trim())) return message;
    return null;
  }

  // ── Numeric ───────────────────────────────────────────────────────────────

  /// Validates that the value is a valid number.
  static String? numeric(String? value,
      {String message = 'Solo se permiten números'}) {
    if (value == null || value.trim().isEmpty) return 'Campo requerido';
    if (double.tryParse(value.trim()) == null) return message;
    return null;
  }

  // ── Compose ───────────────────────────────────────────────────────────────

  /// Runs [validators] in order and returns the first error found.
  ///
  /// ```dart
  /// validator: LimboValidators.compose([
  ///   LimboValidators.required,
  ///   LimboValidators.email,
  /// ]),
  /// ```
  static String? Function(String?) compose(
    List<String? Function(String?)> validators,
  ) {
    return (String? value) {
      for (final v in validators) {
        final result = v(value);
        if (result != null) return result;
      }
      return null;
    };
  }
}
