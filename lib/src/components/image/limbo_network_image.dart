import 'package:flutter/material.dart';
import 'package:limbo_ui_flutter/src/components/feedback/limbo_skeleton.dart';
import 'package:limbo_ui_flutter/src/core/limbo_colors.dart';
import 'package:limbo_ui_flutter/src/core/limbo_tokens.dart';

/// Network image with a shimmer placeholder while loading, a soft fade-in once
/// the first frame is ready and a neutral error state. Use it instead of a
/// bare `Image.network` for every remote picture (products, stores, reviews).
///
/// Pass [heroTag] to make the image a [Hero] source (see `LimboImageViewer`).
/// [cacheWidth] decodes the bitmap at that logical width, which keeps memory
/// low for thumbnails.
class LimboNetworkImage extends StatelessWidget {
  final String url;
  final BoxFit fit;
  final double? width;
  final double? height;
  final double borderRadius;
  final int? cacheWidth;
  final Object? heroTag;
  final IconData errorIcon;

  const LimboNetworkImage(
    this.url, {
    super.key,
    this.fit = BoxFit.cover,
    this.width,
    this.height,
    this.borderRadius = 0,
    this.cacheWidth,
    this.heroTag,
    this.errorIcon = Icons.image_not_supported_outlined,
  });

  Widget _placeholder() => Container(
        width: width,
        height: height,
        color: LimboColors.backgroundObject,
        alignment: Alignment.center,
        child: Icon(errorIcon, color: LimboColors.normalGray, size: 32),
      );

  @override
  Widget build(BuildContext context) {
    if (url.trim().isEmpty) {
      return borderRadius > 0
          ? ClipRRect(
              borderRadius: BorderRadius.circular(borderRadius),
              child: _placeholder(),
            )
          : _placeholder();
    }
    Widget image = Image.network(
      url,
      fit: fit,
      width: width,
      height: height,
      cacheWidth: cacheWidth,
      gaplessPlayback: true,
      frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
        if (wasSynchronouslyLoaded) return child;
        return AnimatedOpacity(
          opacity: frame == null ? 0 : 1,
          duration: LimboTokens.base,
          curve: LimboTokens.emphasized,
          child: child,
        );
      },
      loadingBuilder: (context, child, progress) {
        if (progress == null) return child;
        return Stack(
          fit: StackFit.passthrough,
          children: [
            Positioned.fill(
              child: LimboSkeleton(
                width: width,
                height: height ?? double.infinity,
                radius: 0,
              ),
            ),
            Opacity(opacity: 0, child: child),
          ],
        );
      },
      errorBuilder: (context, error, stackTrace) => _placeholder(),
    );

    if (heroTag != null) image = Hero(tag: heroTag!, child: image);
    if (borderRadius > 0) {
      image = ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius),
        child: image,
      );
    }
    return image;
  }
}
