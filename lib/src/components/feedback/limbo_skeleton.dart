import 'package:flutter/material.dart';
import 'package:limbo_ui_flutter/src/core/limbo_colors.dart';
import 'package:limbo_ui_flutter/src/core/limbo_tokens.dart';

/// Shimmering placeholder block shown while content loads. Compose several
/// to mimic the final layout instead of showing a bare spinner.
class LimboSkeleton extends StatefulWidget {
  final double? width;
  final double height;
  final double radius;

  const LimboSkeleton({
    super.key,
    this.width,
    this.height = 16,
    this.radius = LimboTokens.rSmall,
  });

  @override
  State<LimboSkeleton> createState() => _LimboSkeletonState();
}

class _LimboSkeletonState extends State<LimboSkeleton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1400),
  )..repeat();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final base = LimboColors.backgroundObject;
    final highlight = LimboColors.white;
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        final t = _controller.value;
        return Container(
          width: widget.width,
          height: widget.height,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(widget.radius),
            gradient: LinearGradient(
              begin: Alignment(-1.5 + 3 * t, 0),
              end: Alignment(-0.5 + 3 * t, 0),
              colors: [base, highlight, base],
              stops: const [0.1, 0.5, 0.9],
            ),
          ),
        );
      },
    );
  }
}

/// A column of [LimboSkeleton] rows laid out like a list of cards.
class LimboSkeletonList extends StatelessWidget {
  final int count;
  final double itemHeight;
  final EdgeInsetsGeometry padding;

  const LimboSkeletonList({
    super.key,
    this.count = 4,
    this.itemHeight = 92,
    this.padding = const EdgeInsets.all(LimboTokens.s20),
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: Column(
        children: List.generate(
          count,
          (_) => Padding(
            padding: const EdgeInsets.only(bottom: LimboTokens.s12),
            child: LimboSkeleton(
              height: itemHeight,
              radius: LimboTokens.rMedium,
            ),
          ),
        ),
      ),
    );
  }
}
