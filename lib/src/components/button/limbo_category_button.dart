import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:limbo_ui_flutter/src/core/limbo_colors.dart';

/// A category tile with a background image and a label overlay.
/// Navigation is handled externally via [onTap] callback.
///
/// ```dart
/// LimboCategoryButton(
///   label: 'Hombre',
///   image: AssetImage('assets/images/hombre.jpg'),
///   onTap: () => context.push('/category'),
/// )
/// ```
class LimboCategoryButton extends StatelessWidget {
  final String label;
  final ImageProvider image;
  final VoidCallback? onTap;

  const LimboCategoryButton({
    super.key,
    required this.label,
    required this.image,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Flexible(
      flex: 1,
      child: Tooltip(
        message: 'Ver categoría $label',
        child: Stack(
          children: [
            // Background Image
            Container(
              height: 80,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(15),
                image: DecorationImage(
                  image: ResizeImage(image, width: 500),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            // Label overlay
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: LimboColors.backgroundObject.withValues(alpha: 0.8),
                  borderRadius: const BorderRadius.only(
                    topRight: Radius.circular(15),
                    topLeft: Radius.circular(15),
                  ),
                ),
                child: Text(
                  label,
                  style: const TextStyle(fontSize: 15, color: Colors.black),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            // Tap overlay
            Positioned.fill(
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.circular(15),
                  onTap: () {
                    HapticFeedback.lightImpact();
                    onTap?.call();
                  },
                  child: Semantics(
                    label: 'Ir a categoría $label',
                    button: true,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
