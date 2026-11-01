import 'package:flutter/material.dart';
import 'package:limbo_ui_flutter/src/components/image/limbo_network_image.dart';
import 'package:limbo_ui_flutter/src/components/misc/limbo_favorite_button.dart';
import 'package:limbo_ui_flutter/src/components/motion/limbo_pressable.dart';
import 'package:limbo_ui_flutter/src/core/limbo_configuration.dart';

/// Data model for a product displayed in [LimboItemCard].
class LimboItemData {
  /// Caller-defined identity (e.g. product id) echoed back by tap callbacks.
  final Object? id;
  final bool isFavorite;
  final String storeName;
  final String productName;

  /// Local/asset image. Provide this or [imageUrl].
  final ImageProvider? image;

  /// Remote image, rendered with [LimboNetworkImage] (shimmer + fade-in).
  final String? imageUrl;
  final double price;
  final double discount; // fraction off (0.15 = 15% off); 0.0 = none
  final List<Map<String, dynamic>> colors; // {'color': Color, 'label': String}

  const LimboItemData({
    this.id,
    this.isFavorite = false,
    required this.storeName,
    required this.productName,
    this.image,
    this.imageUrl,
    required this.price,
    this.discount = 0.0,
    this.colors = const [],
  }) : assert(
          image != null || imageUrl != null,
          'LimboItemData needs image or imageUrl',
        );
}

/// An e-commerce product card matching Limbo 2024 Figma specs.
/// Shows image, brand, name, price, and color swatches.
///
/// ```dart
/// LimboItemCard(
///   item: LimboItemData(
///     storeName: 'Sfera',
///     productName: 'Polera oversize',
///     image: AssetImage('assets/images/polera.jpg'),
///     price: 89.90,
///   ),
///   onTap: () => context.push('/details'),
/// )
/// ```
class LimboItemCard extends StatelessWidget {
  final LimboItemData item;
  final VoidCallback? onTap;

  /// When set, a heart toggle is overlaid on the image.
  final VoidCallback? onFavoriteToggle;

  static const double _radius = 6.0;

  const LimboItemCard({
    super.key,
    required this.item,
    this.onTap,
    this.onFavoriteToggle,
  });

  @override
  Widget build(BuildContext context) {
    return LimboPressable(
      onTap: onTap,
      pressedScale: 0.98,
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(_radius),
          border: Border.all(color: const Color(0xFFEFEFEF)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.08),
              blurRadius: 4,
              offset: const Offset(0, 1),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Top Image
            Expanded(
              child: Stack(
                fit: StackFit.expand,
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.only(
                      topRight: Radius.circular(_radius),
                      topLeft: Radius.circular(_radius),
                    ),
                    child: item.imageUrl != null
                        ? LimboNetworkImage(item.imageUrl!, cacheWidth: 600)
                        : Image(
                            image: item.image!,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) =>
                                Container(
                              color: const Color(0xFFF0F0F0),
                              child: const Icon(
                                Icons.image_not_supported_outlined,
                                color: Color(0xFFBBBBBB),
                                size: 40,
                              ),
                            ),
                          ),
                  ),
                  if (onFavoriteToggle != null)
                    Positioned(
                      top: 8,
                      right: 8,
                      child: LimboFavoriteButton(
                        isFavorite: item.isFavorite,
                        onToggle: onFavoriteToggle!,
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            // Store Name
            if (item.storeName.isNotEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Text(
                  item.storeName,
                  style: TextStyle(
                    fontFamily: LimboConfiguration().fontFamily,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: Colors.black,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            const SizedBox(height: 2),
            // Product Name
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Text(
                item.productName,
                style: TextStyle(
                  fontFamily: LimboConfiguration().fontFamily,
                  fontSize: 13,
                  color: const Color(0xFF555555),
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(height: 4),
            // Pricing
            if (item.discount == 0.0)
              _PriceDisplay(price: item.price)
            else
              _DiscountedPriceDisplay(item: item),
            const SizedBox(height: 4),
            // Vendor
            if (item.storeName.isNotEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Text.rich(
                  TextSpan(
                    text: 'Vendido por ',
                    children: [
                      TextSpan(
                        text: item.storeName,
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                  style: TextStyle(
                    fontFamily: LimboConfiguration().fontFamily,
                    fontSize: 10,
                    color: const Color(0xFF828282),
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            // Colors
            if (item.colors.isNotEmpty) ...[
              const SizedBox(height: 8),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: _ColorSelector(colors: item.colors),
              ),
            ],
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}

class _ColorSelector extends StatefulWidget {
  final List<Map<String, dynamic>> colors;
  const _ColorSelector({required this.colors});

  @override
  State<_ColorSelector> createState() => _ColorSelectorState();
}

class _ColorSelectorState extends State<_ColorSelector> {
  int _selected = 0;

  @override
  Widget build(BuildContext context) {
    // Custom inline swatches for the product card to match the small 18px circle spec
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(widget.colors.length, (index) {
        final isSelected = _selected == index;
        return GestureDetector(
          onTap: () => setState(() => _selected = index),
          child: Container(
            margin: const EdgeInsets.only(right: 8),
            padding: const EdgeInsets.all(2),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: isSelected ? Colors.black : Colors.transparent,
                width: 1,
              ),
            ),
            child: Container(
              width: 18,
              height: 18,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: widget.colors[index]['color'] as Color,
                border: Border.all(
                  color: const Color(0xFFEEEEEE),
                  width: 1,
                ),
              ),
            ),
          ),
        );
      }),
    );
  }
}

class _PriceDisplay extends StatelessWidget {
  final double price;
  const _PriceDisplay({required this.price});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Text(
        'S/.${price.toStringAsFixed(2)}',
        style: TextStyle(
          fontFamily: LimboConfiguration().fontFamily,
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: const Color(0xFFE60000), // Figma red
        ),
      ),
    );
  }
}

class _DiscountedPriceDisplay extends StatelessWidget {
  final LimboItemData item;
  const _DiscountedPriceDisplay({required this.item});

  @override
  Widget build(BuildContext context) {
    final discounted = item.price * (1 - item.discount);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.baseline,
        textBaseline: TextBaseline.alphabetic,
        children: [
          Text(
            'S/.${discounted.toStringAsFixed(2)}',
            style: TextStyle(
              fontFamily: LimboConfiguration().fontFamily,
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: const Color(0xFFE60000),
            ),
          ),
          const SizedBox(width: 8),
          Text(
            'S/.${item.price.toStringAsFixed(2)}',
            style: TextStyle(
              fontFamily: LimboConfiguration().fontFamily,
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF999999),
              decoration: TextDecoration.lineThrough,
            ),
          ),
        ],
      ),
    );
  }
}
