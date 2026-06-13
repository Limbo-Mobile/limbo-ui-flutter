import 'package:flutter/material.dart';
import 'package:limbo_ui_flutter/src/core/limbo_colors.dart';

/// A grid that displays circular category icons with optional text labels.
/// Navigation is handled by the [onItemTap] callback, keeping the widget
/// router-agnostic.
///
/// ```dart
/// LimboCircleItemGrid(
///   items: categories.map((c) => NetworkImage(c.imageUrl)).toList(),
///   labels: categories.map((c) => c.name).toList(),
///   onItemTap: (index) => context.push('/category/${categories[index].id}'),
/// )
/// ```
class LimboCircleItemGrid extends StatelessWidget {
  final List<ImageProvider> items;
  final List<String>? labels;
  final void Function(int index)? onItemTap;
  final int crossAxisCount;
  final double crossAxisSpacing;
  final double mainAxisSpacing;
  final double itemRadius;

  const LimboCircleItemGrid({
    super.key,
    required this.items,
    this.labels,
    this.onItemTap,
    this.crossAxisCount = 4,
    this.crossAxisSpacing = 10,
    this.mainAxisSpacing = 2,
    this.itemRadius = 25,
  });

  @override
  Widget build(BuildContext context) {
    final hasLabels = labels != null && labels!.isNotEmpty;
    return GridView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        crossAxisSpacing: crossAxisSpacing,
        mainAxisSpacing: mainAxisSpacing,
        childAspectRatio: hasLabels ? 0.85 : 1,
      ),
      itemCount: items.length,
      itemBuilder: (context, index) {
        final label = hasLabels && index < labels!.length ? labels![index] : null;
        return GestureDetector(
          onTap: () => onItemTap?.call(index),
          child: Column(
            children: [
              Container(
                margin: const EdgeInsets.only(bottom: 4),
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: LimboColors.backgroundObjectBorder,
                  shape: BoxShape.circle,
                ),
                child: CircleAvatar(
                  radius: itemRadius,
                  backgroundColor: LimboColors.lightGray,
                  backgroundImage: ResizeImage(items[index], width: 150),
                ),
              ),
              if (label != null)
                Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 9,
                    fontWeight: FontWeight.w400,
                    color: LimboColors.textPrimary,
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}
