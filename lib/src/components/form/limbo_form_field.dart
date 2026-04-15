import 'package:flutter/material.dart';
import 'package:limbo_ui_flutter/src/core/limbo_colors.dart';
import 'package:limbo_ui_flutter/src/core/limbo_typography.dart';

/// A styled text form field with a leading icon border, hint text, and
/// optional suffix icon, validator, and password mode.
/// Font follows [LimboConfiguration].
///
/// ```dart
/// LimboFormField(
///   controller: _emailController,
///   hintText: 'Correo electrónico',
///   icon: Icons.email,
///   validator: LimboValidators.email,
/// )
/// ```
class LimboFormField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final IconData icon;
  final Widget? suffixIcon;
  final bool isPassword;
  final FocusNode? focusNode;
  final VoidCallback? onTap;
  final bool isReadOnly;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final ValueChanged<String>? onFieldSubmitted;
  final Iterable<String>? autofillHints;
  final String? Function(String?)? validator;

  const LimboFormField({
    super.key,
    required this.controller,
    required this.hintText,
    required this.icon,
    this.suffixIcon,
    this.isPassword = false,
    this.focusNode,
    this.onTap,
    this.isReadOnly = false,
    this.keyboardType,
    this.textInputAction,
    this.onFieldSubmitted,
    this.autofillHints,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      keyboardType: keyboardType,
      textInputAction: textInputAction,
      onFieldSubmitted: onFieldSubmitted,
      autofillHints: autofillHints,
      validator: validator,
      controller: controller,
      obscureText: isPassword,
      focusNode: focusNode,
      decoration: InputDecoration(
        filled: true,
        fillColor: LimboColors.backgroundObject,
        hintText: hintText,
        hintStyle: LimboTypography.hint,
        contentPadding:
            const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
        enabledBorder: OutlineInputBorder(
          borderSide:
              const BorderSide(color: LimboColors.backgroundObjectBorder),
          borderRadius: BorderRadius.circular(12),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: LimboColors.primary, width: 1.0),
          borderRadius: BorderRadius.circular(12),
        ),
        errorBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.red),
          borderRadius: BorderRadius.circular(12),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.red, width: 1.5),
          borderRadius: BorderRadius.circular(12),
        ),
        suffixIcon: suffixIcon,
        prefixIcon: Container(
          margin: const EdgeInsets.only(right: 8, top: 8, bottom: 8),
          decoration: const BoxDecoration(
            border: Border(right: BorderSide(color: LimboColors.gray)),
          ),
          child: Icon(icon, color: LimboColors.primary),
        ),
      ),
      onTap: onTap,
      readOnly: isReadOnly,
    );
  }
}
