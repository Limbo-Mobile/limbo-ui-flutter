import 'package:flutter/material.dart';
import 'package:limbo_ui_flutter/src/components/image/limbo_image_viewer.dart';
import 'package:limbo_ui_flutter/src/components/image/limbo_network_image.dart';
import 'package:limbo_ui_flutter/src/components/motion/limbo_pressable.dart';
import 'package:limbo_ui_flutter/src/core/limbo_tokens.dart';

/// Row of small square thumbnails; tapping one opens [showLimboImageViewer]
/// at that photo with a hero flight. [heroPrefix] must be unique per gallery
/// on screen (e.g. `review-42`).
class LimboPhotoThumbs extends StatelessWidget {
  final List<String> urls;
  final String heroPrefix;
  final double size;

  const LimboPhotoThumbs({
    super.key,
    required this.urls,
    required this.heroPrefix,
    this.size = 64,
  });

  @override
  Widget build(BuildContext context) {
    if (urls.isEmpty) return const SizedBox.shrink();
    return Wrap(
      spacing: LimboTokens.s8,
      runSpacing: LimboTokens.s8,
      children: [
        for (var i = 0; i < urls.length; i++)
          LimboPressable(
            semanticLabel: 'Ver foto ${i + 1} de ${urls.length}',
            onTap: () => showLimboImageViewer(
              context,
              urls: urls,
              initialIndex: i,
              heroPrefix: heroPrefix,
            ),
            child: LimboNetworkImage(
              urls[i],
              width: size,
              height: size,
              borderRadius: LimboTokens.rSmall,
              cacheWidth: (size * 3).round(),
              heroTag: limboImageHeroTag(heroPrefix, i),
            ),
          ),
      ],
    );
  }
}
