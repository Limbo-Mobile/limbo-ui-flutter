import 'package:flutter/material.dart';
import 'package:limbo_ui_flutter/src/core/limbo_colors.dart';
import 'package:limbo_ui_flutter/src/core/limbo_tokens.dart';
import 'package:limbo_ui_flutter/src/core/limbo_typography.dart';

/// Header shared by app pages (tabs, checkout, payments...): large left-aligned
/// [title], optional [leading] (e.g. [LimboBackButton]) and trailing [actions],
/// with a hairline divider underneath. Fixed height so the divider sits at the
/// same y on every page, and a plain surface, so it never tints on scroll.
///
/// It pads itself for the status bar; inside a parent that already applied the
/// top safe area (the tab shell) that padding is simply zero.
///
/// ```dart
/// Column(children: [
///   LimboPageHeader(title: 'Mis pedidos'),
///   Expanded(child: body),
/// ])
/// ```
class LimboPageHeader extends StatelessWidget {
  final String title;
  final Widget? leading;
  final List<Widget> actions;

  static const double height = 72;

  const LimboPageHeader({
    super.key,
    required this.title,
    this.leading,
    this.actions = const [],
  });

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: LimboColors.white,
      child: SafeArea(
        bottom: false,
        child: Container(
          height: height,
          padding: EdgeInsets.only(
            left: leading == null ? LimboTokens.s16 : LimboTokens.s4,
          ),
          decoration: BoxDecoration(
            border: Border(bottom: BorderSide(color: LimboTokens.hairline)),
          ),
          child: Row(
            children: [
              if (leading != null) leading!,
              Expanded(
                child: Padding(
                  padding: EdgeInsets.only(
                    left: leading == null ? 0 : LimboTokens.s8,
                  ),
                  child: Text(
                    title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: LimboTypography.headingLarge,
                  ),
                ),
              ),
              ...actions,
              const SizedBox(width: LimboTokens.s8),
            ],
          ),
        ),
      ),
    );
  }
}
