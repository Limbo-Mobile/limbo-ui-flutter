import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:limbo_ui_flutter/src/core/limbo_colors.dart';
import 'package:limbo_ui_flutter/src/core/limbo_configuration.dart';
import 'package:limbo_ui_flutter/src/core/limbo_tokens.dart';

/// A rectangular category tile — photo filling the card with the label on a
/// translucent strip across the top (Limbo 2024 home design).
/// Navigation is handled externally via [onTap] callback.
///
/// ```dart
/// LimboCategoryCard(
///   label: 'Hombre',
///   imageUrl: 'https://...',
///   onTap: () => context.push('/category'),
/// )
/// ```
class LimboCategoryCard extends StatelessWidget {
  final String label;

  /// Remote photo. When null, empty or failing, a brand-tinted tile is shown.
  final String? imageUrl;
  final VoidCallback? onTap;
  final double width;
  final double height;

  const LimboCategoryCard({
    super.key,
    required this.label,
    this.imageUrl,
    this.onTap,
    this.width = 108,
    this.height = 68,
  });

  @override
  Widget build(BuildContext context) {
    final url = imageUrl;
    final placeholder = ColoredBox(
      color: LimboTokens.brandWash,
      child: Icon(
        Icons.checkroom_outlined,
        color: LimboColors.primary.withValues(alpha: 0.55),
        size: 26,
      ),
    );

    return Semantics(
      button: true,
      label: label,
      child: GestureDetector(
        onTap: () {
          HapticFeedback.lightImpact();
          onTap?.call();
        },
        behavior: HitTestBehavior.opaque,
        child: Container(
          width: width,
          height: height,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            boxShadow: [
              BoxShadow(
                color: LimboColors.black.withValues(alpha: 0.08),
                blurRadius: 4,
                offset: const Offset(0, 1),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Stack(
              fit: StackFit.expand,
              children: [
                if (url == null || url.isEmpty)
                  placeholder
                else
                  Image.network(
                    url,
                    fit: BoxFit.cover,
                    cacheWidth: (width * 3).round(),
                    errorBuilder: (_, __, ___) => placeholder,
                  ),
                Align(
                  alignment: Alignment.topCenter,
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 4,
                      vertical: 2,
                    ),
                    color: LimboColors.white.withValues(alpha: 0.72),
                    child: Text(
                      label,
                      textAlign: TextAlign.center,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontFamily: LimboConfiguration().fontFamily,
                        fontSize: 10,
                        fontWeight: FontWeight.w500,
                        color: LimboColors.textPrimary,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
