import 'package:flutter/material.dart';
import 'package:limbo_ui_flutter/src/components/image/limbo_network_image.dart';
import 'package:limbo_ui_flutter/src/core/limbo_colors.dart';
import 'package:limbo_ui_flutter/src/core/limbo_tokens.dart';

/// Circular avatar: network [imageUrl] when available, otherwise the first
/// letter of [name] on a brand gradient. Pass [onEdit] to show a camera badge.
class LimboAvatar extends StatelessWidget {
  final String name;
  final String? imageUrl;
  final double size;
  final VoidCallback? onEdit;

  const LimboAvatar({
    super.key,
    required this.name,
    this.imageUrl,
    this.size = 72,
    this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    final initial = name.trim().isNotEmpty ? name.trim()[0].toUpperCase() : 'U';
    final hasImage = imageUrl != null && imageUrl!.isNotEmpty;
    final avatar = Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LimboTokens.brandGradient,
        boxShadow: LimboTokens.shadowSoft,
      ),
      alignment: Alignment.center,
      clipBehavior: Clip.antiAlias,
      child: hasImage
          ? LimboNetworkImage(
              imageUrl!,
              width: size,
              height: size,
              cacheWidth: (size * 3).round(),
              errorIcon: Icons.person_rounded,
            )
          : Text(
              initial,
              style: TextStyle(
                color: LimboColors.white,
                fontSize: size * 0.4,
                fontWeight: FontWeight.bold,
              ),
            ),
    );
    if (onEdit == null) return avatar;
    return GestureDetector(
      onTap: onEdit,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          avatar,
          Positioned(
            right: -2,
            bottom: -2,
            child: Container(
              width: size * 0.32,
              height: size * 0.32,
              decoration: BoxDecoration(
                color: LimboTokens.ink,
                shape: BoxShape.circle,
                border: Border.all(color: LimboColors.white, width: 2),
              ),
              child: Icon(
                Icons.camera_alt_rounded,
                size: size * 0.17,
                color: LimboColors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
