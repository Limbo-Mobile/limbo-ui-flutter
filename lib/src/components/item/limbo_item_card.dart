import 'package:flutter/material.dart';
import 'package:limbo_ui_flutter/src/core/limbo_configuration.dart';

/// Data model for a product displayed in [LimboItemCard].
class LimboItemData {
  final String storeName;
  final String productName;
  final ImageProvider image;
  final double price;
  final double discount; // 0.0 = no discount, else multiplied by price
  final List<Map<String, dynamic>> colors; // {'color': Color, 'label': String}

  const LimboItemData({
    required this.storeName,
    required this.productName,
    required this.image,
    required this.price,
    this.discount = 0.0,
    this.colors = const [],
  });
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

  static const double _radius = 16.0;

  const LimboItemCard({super.key, required this.item, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(_radius),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.06),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Top Image
            Expanded(
              child: ClipRRect(
                borderRadius: const BorderRadius.only(
                  topRight: Radius.circular(_radius),
                  topLeft: Radius.circular(_radius),
                ),
                child: Image(
                  image: ResizeImage(item.image, width: 400),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(height: 12),
            // Brand Name
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Text(
                item.storeName.toUpperCase(),
                style: TextStyle(
                  fontFamily: LimboConfiguration().fontFamily,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                  letterSpacing: 0.5,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(height: 4),
            // Product Name
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Text(
                item.productName,
                style: TextStyle(
                  fontFamily: LimboConfiguration().fontFamily,
                  fontSize: 14,
                  color: const Color(0xFF666666),
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(height: 8),
            // Pricing
            if (item.discount == 0.0)
              _PriceDisplay(price: item.price)
            else
              _DiscountedPriceDisplay(item: item),
            const SizedBox(height: 8),
            // Vendor
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Text(
                'Vendido por ${item.storeName}',
                style: TextStyle(
                  fontFamily: LimboConfiguration().fontFamily,
                  fontSize: 12,
                  color: const Color(0xFF999999),
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(height: 12),
            // Colors
            if (item.colors.isNotEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: _ColorSelector(colors: item.colors),
              ),
            const SizedBox(height: 12),
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
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Text(
        'S/.${price.toStringAsFixed(2)}',
        style: TextStyle(
                  fontFamily: LimboConfiguration().fontFamily,
          fontSize: 16,
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
    final discounted = item.price * item.discount;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.baseline,
        textBaseline: TextBaseline.alphabetic,
        children: [
          Text(
            'S/.${discounted.toStringAsFixed(2)}',
            style: TextStyle(
                  fontFamily: LimboConfiguration().fontFamily,
              fontSize: 16,
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
