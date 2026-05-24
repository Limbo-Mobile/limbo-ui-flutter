import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:limbo_ui_flutter/src/core/limbo_colors.dart';

/// A general-purpose elevated button with haptic feedback, tooltip,
/// semantic label support, a [disabled] state, and an [isLoading] state.
///
/// When [isLoading] is `true`:
/// - A [CircularProgressIndicator] replaces the [child]
/// - [onPressed] is blocked (prevents double-clicks)
/// - Haptic feedback is suppressed
///
/// When [disabled] is `true`:
/// - [onPressed] is never called
/// - Renders with [disabledColor]
/// - Haptic feedback is suppressed
///
/// Use [LimboButton] for ALL async actions to prevent double-clicks.
///
/// ```dart
/// LimboButton(
///   onPressed: _submit,
///   isLoading: _isSubmitting,
///   disabled: !_formIsValid,
///   child: const Text('Confirmar'),
/// )
/// ```
class LimboButton extends StatelessWidget {
  final VoidCallback onPressed;
  final Widget child;
  final double widthSize;
  final Color? backgroundColor;
  final Color? disabledColor;
  final Color loadingIndicatorColor;
  final bool disabled;
  final bool isLoading;
  final String? semanticLabel;
  final String? tooltip;

  const LimboButton({
    super.key,
    required this.onPressed,
    required this.child,
    this.widthSize = double.infinity,
    this.backgroundColor,
    this.disabledColor,
    this.loadingIndicatorColor = Colors.white,
    this.disabled = false,
    this.isLoading = false,
    this.semanticLabel,
    this.tooltip,
  });

  bool get _isInteractive => !disabled && !isLoading;

  void _handlePress() {
    if (!_isInteractive) return;
    HapticFeedback.mediumImpact();
    onPressed();
  }

  @override
  Widget build(BuildContext context) {
    final bgColor = backgroundColor ?? LimboColors.primary;
    final dbColor = disabledColor ?? LimboColors.disabled;

    Widget button = ElevatedButton(
      onPressed: _isInteractive ? _handlePress : null,
      style: ElevatedButton.styleFrom(
        backgroundColor: disabled ? dbColor : bgColor,
        disabledBackgroundColor: dbColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        minimumSize: Size(widthSize, 45),
      ),
      child: Semantics(
        label: semanticLabel,
        button: true,
        enabled: _isInteractive,
        child: isLoading
            ? SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2.5,
                  valueColor:
                      AlwaysStoppedAnimation<Color>(loadingIndicatorColor),
                ),
              )
            : child,
      ),
    );

    if (tooltip != null) {
      button = Tooltip(message: tooltip, child: button);
    }

    return button;
  }
}
