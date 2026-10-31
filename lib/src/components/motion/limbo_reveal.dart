import 'package:flutter/material.dart';
import 'package:limbo_ui_flutter/src/core/limbo_tokens.dart';

/// Fades and slides its child in once, after an optional [delay]. Pass
/// `delay: LimboReveal.stagger(index)` to cascade list items.
class LimboReveal extends StatefulWidget {
  final Widget child;
  final Duration delay;
  final Offset offset;

  const LimboReveal({
    super.key,
    required this.child,
    this.delay = Duration.zero,
    this.offset = const Offset(0, 0.06),
  });

  /// Delay for the [index]-th item of a cascade (capped so long lists stay snappy).
  static Duration stagger(int index) =>
      Duration(milliseconds: 50 * (index > 8 ? 8 : index));

  @override
  State<LimboReveal> createState() => _LimboRevealState();
}

class _LimboRevealState extends State<LimboReveal>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: LimboTokens.slow,
  );
  late final Animation<double> _curve = CurvedAnimation(
    parent: _controller,
    curve: LimboTokens.emphasized,
  );

  @override
  void initState() {
    super.initState();
    Future<void>.delayed(widget.delay, () {
      if (mounted) _controller.forward();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _curve,
      child: SlideTransition(
        position: Tween<Offset>(begin: widget.offset, end: Offset.zero)
            .animate(_curve),
        child: widget.child,
      ),
    );
  }
}
