import 'package:flutter/material.dart';
import 'package:limbo_ui_flutter/src/components/item/limbo_item_card.dart';

/// A configurable grid of [LimboItemCard] widgets.
///
/// All layout parameters have sensible defaults but can be overridden.
///
/// ```dart
/// LimboItemsGrid(
///   items: myItems,
///   onItemTap: (item) => context.push('/details', extra: item),
///   crossAxisCount: 2,
///   itemHeight: 320,
/// )
/// ```
class LimboItemsGrid extends StatelessWidget {
  final List<LimboItemData> items;
  final void Function(LimboItemData item)? onItemTap;
  final int crossAxisCount;
  final double mainAxisSpacing;
  final double crossAxisSpacing;
  final double itemHeight;
  final EdgeInsetsGeometry padding;

  const LimboItemsGrid({
    super.key,
    required this.items,
    this.onItemTap,
    this.crossAxisCount = 2,
    this.mainAxisSpacing = 10,
    this.crossAxisSpacing = 10,
    this.itemHeight = 320,
    this.padding = const EdgeInsets.symmetric(vertical: 10),
  });

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        mainAxisSpacing: mainAxisSpacing,
        crossAxisSpacing: crossAxisSpacing,
        mainAxisExtent: itemHeight,
      ),
      itemCount: items.length,
      padding: padding,
      itemBuilder: (context, index) {
        return LimboItemCard(
          item: items[index],
          onTap: () => onItemTap?.call(items[index]),
        );
      },
    );
  }
}
