import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:limbo_ui_flutter/src/components/motion/limbo_pressable.dart';
import 'package:limbo_ui_flutter/src/core/limbo_colors.dart';
import 'package:limbo_ui_flutter/src/core/limbo_configuration.dart';
import 'package:limbo_ui_flutter/src/core/limbo_tokens.dart';

/// Circular category tile: photo in a circle with the [label] below. While the
/// photo loads (or when it is missing/fails) a brand-tinted circle with the
/// label's initial is shown, so the grid never looks broken.
///
/// [selected] draws a brand ring around the photo and bolds the label.
///
/// ```dart
/// LimboCategoryCircle(
///   label: 'Camisas',
///   imageUrl: 'https://...',
///   onTap: () => context.push('/products'),
/// )
/// ```
class LimboCategoryCircle extends StatelessWidget {
  final String label;
  final String? imageUrl;
  final bool selected;
  final VoidCallback? onTap;
  final double size;

  const LimboCategoryCircle({
    super.key,
    required this.label,
    this.imageUrl,
    this.selected = false,
    this.onTap,
    this.size = 72,
  });

  @override
  Widget build(BuildContext context) {
    final url = imageUrl;
    final initial = label.trim().isEmpty ? '' : label.trim()[0].toUpperCase();
    final placeholder = ColoredBox(
      color: LimboTokens.brandWash,
      child: Center(
        child: Text(
          initial,
          style: TextStyle(
            fontFamily: LimboConfiguration().fontFamily,
            fontSize: size * 0.38,
            fontWeight: FontWeight.w700,
            color: LimboColors.primary.withValues(alpha: 0.7),
          ),
        ),
      ),
    );

    return Semantics(
      button: true,
      selected: selected,
      label: label,
      child: LimboPressable(
        onTap: onTap == null
            ? null
            : () {
                HapticFeedback.selectionClick();
                onTap!();
              },
        child: SizedBox(
          width: size + 8,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              AnimatedContainer(
                duration: LimboTokens.base,
                width: size,
                height: size,
                padding: const EdgeInsets.all(3),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: selected ? LimboColors.primary : Colors.transparent,
                    width: 2,
                  ),
                ),
                child: ClipOval(
                  child: (url == null || url.isEmpty)
                      ? placeholder
                      : Image.network(
                          url,
                          fit: BoxFit.cover,
                          cacheWidth: (size * 3).round(),
                          frameBuilder: (_, child, frame, sync) =>
                              (sync || frame != null) ? child : placeholder,
                          errorBuilder: (_, __, ___) => placeholder,
                        ),
                ),
              ),
              const SizedBox(height: LimboTokens.s8),
              Text(
                label,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: LimboConfiguration().fontFamily,
                  fontSize: 11,
                  height: 1.25,
                  fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                  color: selected ? LimboColors.primary : LimboColors.textPrimary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
