import 'package:flutter/material.dart';
import 'package:limbo_ui_flutter/src/core/limbo_colors.dart';
import 'package:limbo_ui_flutter/src/core/limbo_tokens.dart';
import 'package:limbo_ui_flutter/src/core/limbo_typography.dart';

/// Drag handle, centred [title] and hairline divider shared by the sort and
/// filter bottom panels.
class LimboPanelHeader extends StatelessWidget {
  final String title;

  const LimboPanelHeader({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const SizedBox(height: LimboTokens.s12),
        Container(
          width: 40,
          height: 4,
          decoration: BoxDecoration(
            color: LimboColors.lightGray,
            borderRadius: BorderRadius.circular(LimboTokens.rPill),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: LimboTokens.s20),
          child: Text(
            title,
            textAlign: TextAlign.center,
            style: LimboTypography.headingMedium,
          ),
        ),
        Divider(height: 1, color: LimboTokens.hairline),
      ],
    );
  }
}

/// Height shared by the sort and filter bottom panels so both sheets have the
/// same footprint.
double limboPanelHeight(BuildContext context) =>
    (MediaQuery.sizeOf(context).height * 0.82).clamp(0.0, 680.0);
