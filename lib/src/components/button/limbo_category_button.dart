import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:limbo_ui_flutter/src/core/limbo_colors.dart';

/// A circular category pill — image inside a white circle, label below.
/// Navigation is handled externally via [onTap] callback.
///
/// ```dart
/// LimboCategoryButton(
///   label: 'Hombre',
///   image: NetworkImage('https://...'),
///   onTap: () => context.push('/category'),
/// )
/// ```
class LimboCategoryButton extends StatelessWidget {
  final String label;
  final ImageProvider image;
  final VoidCallback? onTap;
  final double size;

  const LimboCategoryButton({
    super.key,
    required this.label,
    required this.image,
    this.onTap,
    this.size = 68,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        HapticFeedback.lightImpact();
        onTap?.call();
      },
      behavior: HitTestBehavior.opaque,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: LimboColors.backgroundApp,
              border: Border.all(
                color: LimboColors.backgroundObjectBorder,
                width: 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: LimboColors.black.withValues(alpha: 0.06),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: ClipOval(
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Image(
                  image: image,
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ),
          const SizedBox(height: 6),
          SizedBox(
            width: size + 8,
            child: Text(
              label,
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w500,
                color: LimboColors.textPrimary,
              ),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
