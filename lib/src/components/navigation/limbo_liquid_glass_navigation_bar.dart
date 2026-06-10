import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:limbo_ui_flutter/src/core/limbo_colors.dart';

/// Data model for a single item in [LimboLiquidGlassNavigationBar].
class LimboLiquidGlassNavItem {
  final String label;
  final IconData icon;
  final IconData selectedIcon;

  const LimboLiquidGlassNavItem({
    required this.label,
    required this.icon,
    required this.selectedIcon,
  });
}

/// Floating, translucent bottom navigation with liquid-glass styling.
///
/// Navigation is handled exclusively through [onChanged], so apps keep their
/// own routing and state ownership.
class LimboLiquidGlassNavigationBar extends StatefulWidget {
  final List<LimboLiquidGlassNavItem> items;
  final int selectedIndex;
  final ValueChanged<int> onChanged;
  final Color? activeColor;
  final Color? inactiveColor;
  final Color? surfaceColor;
  final double height;
  final double itemWidth;

  const LimboLiquidGlassNavigationBar({
    super.key,
    required this.items,
    required this.selectedIndex,
    required this.onChanged,
    this.activeColor,
    this.inactiveColor,
    this.surfaceColor,
    this.height = 68,
    this.itemWidth = 72,
  });

  @override
  State<LimboLiquidGlassNavigationBar> createState() =>
      _LimboLiquidGlassNavigationBarState();
}

class _LimboLiquidGlassNavigationBarState
    extends State<LimboLiquidGlassNavigationBar> {
  void _selectFromDx(double dx, double width) {
    if (widget.items.isEmpty || width <= 0) return;

    final next = (dx / (width / widget.items.length))
        .floor()
        .clamp(0, widget.items.length - 1);
    if (next != widget.selectedIndex) widget.onChanged(next);
  }

  @override
  Widget build(BuildContext context) {
    final surface = widget.surfaceColor ?? LimboColors.backgroundObject;
    final radius = BorderRadius.circular(widget.height / 2);

    return LayoutBuilder(
      builder: (context, constraints) {
        return GestureDetector(
          behavior: HitTestBehavior.opaque,
          onHorizontalDragDown: (details) {
            _selectFromDx(details.localPosition.dx, constraints.maxWidth);
          },
          onHorizontalDragUpdate: (details) {
            _selectFromDx(details.localPosition.dx, constraints.maxWidth);
          },
          child: ClipRRect(
            borderRadius: radius,
            child: BackdropFilter(
              filter: ui.ImageFilter.blur(sigmaX: 22, sigmaY: 22),
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: LimboColors.white.withValues(alpha: 0.54),
                  borderRadius: radius,
                  border: Border.all(
                    color: LimboColors.white.withValues(alpha: 0.78),
                    width: 1.2,
                  ),
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      LimboColors.white.withValues(alpha: 0.9),
                      LimboColors.white.withValues(alpha: 0.44),
                      surface.withValues(alpha: 0.68),
                    ],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: LimboColors.black.withValues(alpha: 0.16),
                      offset: const Offset(0, 16),
                      blurRadius: 32,
                    ),
                    BoxShadow(
                      color: LimboColors.white.withValues(alpha: 0.72),
                      offset: const Offset(-2, -2),
                      blurRadius: 9,
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    for (var index = 0; index < widget.items.length; index++)
                      _LimboLiquidGlassNavButton(
                        item: widget.items[index],
                        isSelected: widget.selectedIndex == index,
                        activeColor: widget.activeColor ?? LimboColors.primary,
                        inactiveColor:
                            widget.inactiveColor ?? LimboColors.darkerText,
                        width: widget.itemWidth,
                        onTap: () => widget.onChanged(index),
                      ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class _LimboLiquidGlassNavButton extends StatelessWidget {
  final LimboLiquidGlassNavItem item;
  final bool isSelected;
  final Color activeColor;
  final Color inactiveColor;
  final double width;
  final VoidCallback onTap;

  const _LimboLiquidGlassNavButton({
    required this.item,
    required this.isSelected,
    required this.activeColor,
    required this.inactiveColor,
    required this.width,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final color = isSelected ? activeColor : inactiveColor;

    return SizedBox(
      width: width,
      height: 62,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(28),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 220),
            curve: Curves.easeOutCubic,
            margin: const EdgeInsets.symmetric(vertical: 3),
            decoration: BoxDecoration(
              color: isSelected
                  ? LimboColors.white.withValues(alpha: 0.72)
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(28),
              border: Border.all(
                color: isSelected
                    ? LimboColors.white.withValues(alpha: 0.88)
                    : Colors.transparent,
              ),
              boxShadow: isSelected
                  ? [
                      BoxShadow(
                        color: activeColor.withValues(alpha: 0.2),
                        offset: const Offset(0, 9),
                        blurRadius: 18,
                      ),
                      BoxShadow(
                        color: LimboColors.white.withValues(alpha: 0.78),
                        offset: const Offset(-2, -2),
                        blurRadius: 8,
                      ),
                    ]
                  : null,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 160),
                  switchInCurve: Curves.easeOutCubic,
                  switchOutCurve: Curves.easeOutCubic,
                  transitionBuilder: (child, animation) {
                    return FadeTransition(
                      opacity: animation,
                      child: ScaleTransition(scale: animation, child: child),
                    );
                  },
                  child: Icon(
                    isSelected ? item.selectedIcon : item.icon,
                    key: ValueKey('${item.label}-$isSelected'),
                    size: isSelected ? 25 : 22,
                    color: color,
                    fill: isSelected ? 1 : 0,
                    weight: isSelected ? 700 : 400,
                    grade: isSelected ? 80 : 0,
                  ),
                ),
                const SizedBox(height: 1),
                Text(
                  item.label,
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 9,
                    fontWeight: isSelected ? FontWeight.w700 : FontWeight.w400,
                    height: 1,
                    color: color,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
