import 'package:flutter/material.dart';
import 'package:limbo_ui_flutter/src/core/limbo_colors.dart';

/// Data model for a single tab in [LimboTabBar].
class LimboTabItem {
  final String text;
  final IconData icon;

  const LimboTabItem({required this.text, required this.icon});
}

/// A configurable tab bar driven entirely by the provided [tabs] list.
/// Requires a [DefaultTabController] ancestor with `length == tabs.length`.
///
/// ```dart
/// DefaultTabController(
///   length: tabs.length,
///   child: Column(children: [
///     LimboTabBar(tabs: tabs),
///     Expanded(child: TabBarView(children: [...])),
///   ]),
/// )
///
/// // Tabs defined in the app:
/// const tabs = [
///   LimboTabItem(text: 'Para ti',   icon: Icons.star_sharp),
///   LimboTabItem(text: 'Tendencia', icon: Icons.trending_up),
///   LimboTabItem(text: 'Ofertas',   icon: Icons.local_offer),
///   LimboTabItem(text: 'Explora',   icon: Icons.explore),
/// ];
/// ```
class LimboTabBar extends StatelessWidget {
  final List<LimboTabItem> tabs;
  final Color? labelColor;
  final Color? indicatorColor;
  final Color? unselectedLabelColor;
  final double textScale;

  const LimboTabBar({
    super.key,
    required this.tabs,
    this.labelColor,
    this.indicatorColor,
    this.unselectedLabelColor,
    this.textScale = 0.8,
  });

  @override
  Widget build(BuildContext context) {
    return TabBar(
      labelColor: labelColor ?? LimboColors.primary,
      indicatorColor: indicatorColor ?? LimboColors.primary,
      unselectedLabelColor: unselectedLabelColor ?? Colors.grey,
      splashBorderRadius: BorderRadius.circular(12),
      textScaler: TextScaler.linear(textScale),
      tabs: tabs
          .map((t) => Tab(
                text: t.text,
                icon: Icon(t.icon),
                iconMargin: const EdgeInsets.only(bottom: 5),
              ))
          .toList(),
    );
  }
}
