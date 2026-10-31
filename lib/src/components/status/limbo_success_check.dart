import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:limbo_ui_flutter/src/core/limbo_colors.dart';
import 'package:limbo_ui_flutter/src/core/limbo_tokens.dart';

/// Brand-gradient circle with a check that pops in and draws itself. Used for
/// success states (payment completed, review sent…). Fires a success haptic.
class LimboSuccessCheck extends StatefulWidget {
  final double size;

  const LimboSuccessCheck({super.key, this.size = 96});

  @override
  State<LimboSuccessCheck> createState() => _LimboSuccessCheckState();
}

class _LimboSuccessCheckState extends State<LimboSuccessCheck>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 900),
  );
  late final Animation<double> _scale = Tween<double>(begin: 0.4, end: 1).animate(
    CurvedAnimation(
      parent: _controller,
      curve: const Interval(0, 0.55, curve: LimboTokens.spring),
    ),
  );
  late final Animation<double> _draw = CurvedAnimation(
    parent: _controller,
    curve: const Interval(0.35, 1, curve: Curves.easeOutCubic),
  );

  @override
  void initState() {
    super.initState();
    _controller.forward();
    HapticFeedback.mediumImpact();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: 'Éxito',
      child: ScaleTransition(
        scale: _scale,
        child: Container(
          width: widget.size,
          height: widget.size,
          decoration: BoxDecoration(
            gradient: LimboTokens.brandGradient,
            shape: BoxShape.circle,
            boxShadow: LimboTokens.shadowLifted,
          ),
          child: AnimatedBuilder(
            animation: _draw,
            builder: (_, __) => CustomPaint(
              painter: _CheckPainter(progress: _draw.value, color: LimboColors.white),
            ),
          ),
        ),
      ),
    );
  }
}

class _CheckPainter extends CustomPainter {
  final double progress;
  final Color color;

  _CheckPainter({required this.progress, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;
    final points = [
      Offset(w * 0.28, h * 0.52),
      Offset(w * 0.44, h * 0.68),
      Offset(w * 0.73, h * 0.36),
    ];
    final firstLen = (points[1] - points[0]).distance;
    final secondLen = (points[2] - points[1]).distance;
    final total = firstLen + secondLen;
    var drawn = total * progress;

    final path = Path()..moveTo(points[0].dx, points[0].dy);
    if (drawn <= firstLen) {
      final t = drawn / firstLen;
      final p = Offset.lerp(points[0], points[1], t)!;
      path.lineTo(p.dx, p.dy);
    } else {
      path.lineTo(points[1].dx, points[1].dy);
      drawn -= firstLen;
      final p = Offset.lerp(points[1], points[2], drawn / secondLen)!;
      path.lineTo(p.dx, p.dy);
    }

    canvas.drawPath(
      path,
      Paint()
        ..color = color
        ..style = PaintingStyle.stroke
        ..strokeWidth = w * 0.075
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round,
    );
  }

  @override
  bool shouldRepaint(covariant _CheckPainter old) => old.progress != progress;
}
