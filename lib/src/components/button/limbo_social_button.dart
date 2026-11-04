import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:limbo_ui_flutter/src/components/motion/limbo_pressable.dart';
import 'package:limbo_ui_flutter/src/core/limbo_colors.dart';
import 'package:limbo_ui_flutter/src/core/limbo_tokens.dart';
import 'package:limbo_ui_flutter/src/core/limbo_typography.dart';

/// Full-width outlined button for third-party sign-in ("Continuar con …").
/// Shows a spinner instead of the [leading] glyph while [isLoading].
class LimboSocialButton extends StatelessWidget {
  final String label;
  final Widget leading;
  final VoidCallback onPressed;
  final bool isLoading;

  const LimboSocialButton({
    super.key,
    required this.label,
    required this.leading,
    required this.onPressed,
    this.isLoading = false,
  });

  /// Google-branded variant.
  const LimboSocialButton.google({
    super.key,
    required this.onPressed,
    this.label = 'Continuar con Google',
    this.isLoading = false,
  }) : leading = const LimboGoogleGlyph();

  @override
  Widget build(BuildContext context) {
    return LimboPressable(
      onTap: isLoading ? null : onPressed,
      semanticLabel: label,
      child: Container(
        height: 52,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: LimboColors.white,
          borderRadius: BorderRadius.circular(LimboTokens.rMedium - 2),
          border: Border.all(color: LimboTokens.hairline),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: 22,
              height: 22,
              child: isLoading
                  ? CircularProgressIndicator(
                      strokeWidth: 2.2,
                      color: LimboColors.primary,
                    )
                  : leading,
            ),
            const SizedBox(width: LimboTokens.s12),
            Text(
              label,
              style: LimboTypography.headingSmall.copyWith(
                fontSize: 15,
                color: LimboTokens.ink,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Google "G" mark drawn with four coloured arcs and a blue bar (no asset).
class LimboGoogleGlyph extends StatelessWidget {
  final double size;

  const LimboGoogleGlyph({super.key, this.size = 22});

  @override
  Widget build(BuildContext context) =>
      CustomPaint(size: Size.square(size), painter: _GoogleGlyphPainter());
}

class _GoogleGlyphPainter extends CustomPainter {
  static const _red = Color(0xFFEA4335);
  static const _yellow = Color(0xFFFBBC05);
  static const _green = Color(0xFF34A853);
  static const _blue = Color(0xFF4285F4);

  @override
  void paint(Canvas canvas, Size size) {
    final stroke = size.width * 0.22;
    final rect = Rect.fromCircle(
      center: size.center(Offset.zero),
      radius: (size.width - stroke) / 2,
    );
    Paint paint(Color color) => Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = stroke
      ..strokeCap = StrokeCap.butt;

    const deg = math.pi / 180;
    // Angles measured clockwise from 3 o'clock; the gap on the right-top is
    // where the "G" opens.
    canvas.drawArc(rect, -45 * deg, -90 * deg, false, paint(_red));
    canvas.drawArc(rect, -135 * deg, -45 * deg, false, paint(_yellow));
    canvas.drawArc(rect, 180 * deg, -90 * deg, false, paint(_yellow));
    canvas.drawArc(rect, 90 * deg, 90 * deg, false, paint(_green));
    canvas.drawArc(rect, 0, 45 * deg, false, paint(_blue));

    final bar = Paint()
      ..color = _blue
      ..style = PaintingStyle.fill;
    canvas.drawRect(
      Rect.fromLTWH(
        size.width * 0.5,
        size.height * 0.5 - stroke / 2,
        size.width * 0.46,
        stroke,
      ),
      bar,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
