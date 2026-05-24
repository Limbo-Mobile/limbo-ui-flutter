import 'package:flutter/material.dart';
import 'package:limbo_ui_flutter/src/core/limbo_colors.dart';
import 'package:limbo_ui_flutter/src/core/limbo_typography.dart';

/// A section title with a primary-colored bottom divider.
/// Font follows [LimboConfiguration].
///
/// ```dart
/// LimboCategoryTitle(category: 'Hombre', size: MediaQuery.of(context).size)
/// ```
class LimboCategoryTitle extends StatelessWidget {
  final String category;
  final Size size;

  const LimboCategoryTitle({
    super.key,
    required this.category,
    required this.size,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(category, style: LimboTypography.categoryTitle),
        Divider(color: LimboColors.primary, thickness: 1.5),
      ],
    );
  }
}
