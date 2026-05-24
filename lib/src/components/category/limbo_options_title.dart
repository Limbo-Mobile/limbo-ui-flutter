import 'package:flutter/material.dart';
import 'package:limbo_ui_flutter/src/core/limbo_colors.dart';
import 'package:limbo_ui_flutter/src/core/limbo_typography.dart';

/// A decorative section title with primary-coloured dividers on both sides.
/// Font follows [LimboConfiguration].
///
/// ```dart
/// LimboOptionsTitle(name: 'FILTRAR')
/// ```
class LimboOptionsTitle extends StatelessWidget {
  final String name;

  const LimboOptionsTitle({super.key, required this.name});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Divider(
            color: LimboColors.primary,
            thickness: 1,
            indent: 15,
            endIndent: 15,
          ),
        ),
        Text(name, style: LimboTypography.sectionTitle, textAlign: TextAlign.center),
        Expanded(
          child: Divider(
            color: LimboColors.primary,
            thickness: 1,
            indent: 15,
            endIndent: 15,
          ),
        ),
      ],
    );
  }
}
