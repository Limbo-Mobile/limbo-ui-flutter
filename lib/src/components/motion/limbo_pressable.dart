import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:limbo_ui_flutter/src/core/limbo_tokens.dart';

/// Wraps any child with a tactile press: it scales down slightly while held
/// and fires a light haptic on tap. Use it on cards, tiles and custom buttons
/// instead of a bare [GestureDetector].
class LimboPressable extends StatefulWidget {
  final Widget child;
  final VoidCallback? onTap;
  final double pressedScale;
  final bool haptic;
  final String? semanticLabel;

  const LimboPressable({
    super.key,
    required this.child,
    this.onTap,
    this.pressedScale = 0.97,
    this.haptic = true,
    this.semanticLabel,
  });

  @override
  State<LimboPressable> createState() => _LimboPressableState();
}

class _LimboPressableState extends State<LimboPressable> {
  bool _pressed = false;

  void _set(bool value) {
    if (widget.onTap == null || _pressed == value) return;
    setState(() => _pressed = value);
  }

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: widget.onTap != null,
      label: widget.semanticLabel,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTapDown: (_) => _set(true),
        onTapCancel: () => _set(false),
        onTapUp: (_) => _set(false),
        onTap: widget.onTap == null
            ? null
            : () {
                if (widget.haptic) HapticFeedback.selectionClick();
                widget.onTap!();
              },
        child: AnimatedScale(
          scale: _pressed ? widget.pressedScale : 1,
          duration: LimboTokens.fast,
          curve: LimboTokens.emphasized,
          child: widget.child,
        ),
      ),
    );
  }
}
