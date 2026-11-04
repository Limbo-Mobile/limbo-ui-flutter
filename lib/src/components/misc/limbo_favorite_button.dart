import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:limbo_ui_flutter/src/core/limbo_colors.dart';
import 'package:limbo_ui_flutter/src/core/limbo_tokens.dart';

/// Heart toggle with a springy pop when activated. Stateless: the caller owns
/// [isFavorite] and flips it in [onToggle] (optimistic update recommended).
class LimboFavoriteButton extends StatefulWidget {
  final bool isFavorite;
  final VoidCallback onToggle;
  final double size;
  final bool onSurface;

  const LimboFavoriteButton({
    super.key,
    required this.isFavorite,
    required this.onToggle,
    this.size = 22,
    this.onSurface = true,
  });

  @override
  State<LimboFavoriteButton> createState() => _LimboFavoriteButtonState();
}

class _LimboFavoriteButtonState extends State<LimboFavoriteButton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: LimboTokens.slow,
  );

  @override
  void didUpdateWidget(covariant LimboFavoriteButton old) {
    super.didUpdateWidget(old);
    if (!old.isFavorite && widget.isFavorite) _controller.forward(from: 0);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final scale = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 1.0, end: 0.7), weight: 20),
      TweenSequenceItem(
        tween: Tween(begin: 0.7, end: 1.0)
            .chain(CurveTween(curve: LimboTokens.spring)),
        weight: 80,
      ),
    ]).animate(_controller);
    return Semantics(
      button: true,
      label: widget.isFavorite ? 'Quitar de favoritos' : 'Agregar a favoritos',
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          HapticFeedback.lightImpact();
          widget.onToggle();
        },
        child: Container(
          padding: const EdgeInsets.all(8),
          decoration: widget.onSurface
              ? BoxDecoration(
                  color: LimboColors.white.withValues(alpha: 0.92),
                  shape: BoxShape.circle,
                  boxShadow: LimboTokens.shadowSoft,
                )
              : null,
          child: ScaleTransition(
            scale: scale,
            child: Icon(
              widget.isFavorite
                  ? Icons.favorite_rounded
                  : Icons.favorite_border_rounded,
              size: widget.size,
              color: widget.isFavorite ? LimboColors.error : LimboColors.icons,
            ),
          ),
        ),
      ),
    );
  }
}
