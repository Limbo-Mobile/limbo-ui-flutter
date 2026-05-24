import 'package:flutter/material.dart';
import 'package:limbo_ui_flutter/src/core/limbo_colors.dart';

/// A grid that displays circular category icons. Navigation is handled by
/// the [onItemTap] callback, keeping the widget router-agnostic.
///
/// [items] is a list of [ImageProvider]s.
///
/// ```dart
/// LimboCircleItemGrid(
///   items: [AssetImage('assets/cat1.png'), AssetImage('assets/cat2.png')],
///   onItemTap: (index) => context.push('/category/$index'),
/// )
/// ```
class LimboCircleItemGrid extends StatelessWidget {
  final List<ImageProvider> items;
  final void Function(int index)? onItemTap;
  final int crossAxisCount;
  final double crossAxisSpacing;
  final double mainAxisSpacing;

  const LimboCircleItemGrid({
    super.key,
    required this.items,
    this.onItemTap,
    this.crossAxisCount = 4,
    this.crossAxisSpacing = 10,
    this.mainAxisSpacing = 2,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        crossAxisSpacing: crossAxisSpacing,
        mainAxisSpacing: mainAxisSpacing,
        childAspectRatio: 1,
      ),
      itemCount: items.length,
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: () => onItemTap?.call(index),
          child: Container(
            margin: const EdgeInsets.only(bottom: 10),
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: LimboColors.backgroundObjectBorder,
              shape: BoxShape.circle,
            ),
            child: CircleAvatar(
              radius: 31,
              backgroundImage:
                  ResizeImage(items[index], width: 150),
            ),
          ),
        );
      },
    );
  }
}
