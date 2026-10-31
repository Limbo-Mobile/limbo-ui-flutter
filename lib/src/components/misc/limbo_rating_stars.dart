import 'package:flutter/material.dart';
import 'package:limbo_ui_flutter/src/core/limbo_tokens.dart';

/// Read-only row of stars; supports half stars via fractional [rating].
class LimboRatingStars extends StatelessWidget {
  final double rating;
  final double size;
  final int max;

  const LimboRatingStars({
    super.key,
    required this.rating,
    this.size = 16,
    this.max = 5,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(max, (i) {
        final icon = rating >= i + 1
            ? Icons.star_rounded
            : rating >= i + 0.5
                ? Icons.star_half_rounded
                : Icons.star_outline_rounded;
        return Icon(icon, size: size, color: LimboTokens.champagne);
      }),
    );
  }
}
