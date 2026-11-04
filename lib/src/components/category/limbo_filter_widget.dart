import 'package:flutter/material.dart';
import 'package:limbo_ui_flutter/src/components/category/limbo_panel_header.dart';
import 'package:limbo_ui_flutter/src/core/limbo_colors.dart';
import 'package:limbo_ui_flutter/src/core/limbo_tokens.dart';
import 'package:limbo_ui_flutter/src/core/limbo_typography.dart';

/// Data model for a color option inside [LimboFilterWidget].
class LimboFilterColor {
  final Color color;
  final String name;

  const LimboFilterColor({required this.color, required this.name});
}

/// A single tab section in [LimboFilterWidget].
///
/// [label] and [icon] define the tab header.
/// [content] is the widget shown in the tab body — pass `null` to show an
/// empty placeholder (coming-soon tab).
class LimboFilterSection {
  final String label;
  final IconData icon;
  final Widget? content;

  const LimboFilterSection({
    required this.label,
    required this.icon,
    this.content,
  });
}

/// Bottom-sheet filter panel: price range on top, one tab per
/// [LimboFilterSection] (colour, size, ...) and a fixed footer with the clear
/// and apply actions.
///
/// All tabs, price range bounds, labels, and currency symbol are injected by
/// the consuming app — the widget has no hardcoded data.
///
/// ```dart
/// LimboFilterWidget(
///   selectedRange: const RangeValues(20, 500),
///   rangeMin: 20,
///   rangeMax: 500,
///   sections: [
///     LimboFilterSection(
///       label: 'Color',
///       icon: Icons.palette_outlined,
///       content: LimboColorFilterGrid(
///         colors: myColors,
///         selectedColor: _color,
///         onColorChanged: (c) => setState(() => _color = c),
///       ),
///     ),
///   ],
///   onRangeChanged: (v) => setState(() => _range = v),
///   onApply: () => Navigator.pop(context),
///   onClear: () => setState(() => _range = const RangeValues(20, 500)),
/// )
/// ```
class LimboFilterWidget extends StatefulWidget {
  final RangeValues selectedRange;
  final double rangeMin;
  final double rangeMax;
  final List<LimboFilterSection> sections;
  final void Function(RangeValues) onRangeChanged;
  final VoidCallback? onApply;
  final VoidCallback? onClear;
  final String title;
  final String priceLabel;
  final String currencySymbol;
  final String applyLabel;
  final String clearLabel;

  const LimboFilterWidget({
    super.key,
    required this.selectedRange,
    required this.sections,
    required this.onRangeChanged,
    this.rangeMin = 0,
    this.rangeMax = 1000,
    this.onApply,
    this.onClear,
    this.title = 'Filtro de búsqueda',
    this.priceLabel = 'Escala de precios',
    this.currencySymbol = 'S/',
    this.applyLabel = 'Aplicar filtros',
    this.clearLabel = 'Limpiar filtros',
  });

  @override
  State<LimboFilterWidget> createState() => _LimboFilterWidgetState();
}

class _LimboFilterWidgetState extends State<LimboFilterWidget> {
  late RangeValues _rangeValues = widget.selectedRange;

  @override
  void didUpdateWidget(LimboFilterWidget old) {
    super.didUpdateWidget(old);
    // The host resets the range on "clear"; follow it.
    if (old.selectedRange != widget.selectedRange) {
      _rangeValues = widget.selectedRange;
    }
  }

  String _price(double v) => '${widget.currencySymbol}${v.toInt()}';

  @override
  Widget build(BuildContext context) {
    final height = limboPanelHeight(context);
    final divisions =
        (widget.rangeMax - widget.rangeMin).clamp(1, double.infinity).toInt();

    return DefaultTabController(
      length: widget.sections.length,
      child: Material(
        color: LimboColors.white,
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(LimboTokens.rLarge),
        ),
        clipBehavior: Clip.antiAlias,
        child: SizedBox(
          height: height,
          child: Column(
            children: [
              LimboPanelHeader(title: widget.title),
              Padding(
                padding: const EdgeInsets.fromLTRB(
                  LimboTokens.s24,
                  LimboTokens.s20,
                  LimboTokens.s24,
                  0,
                ),
                child: Column(
                  children: [
                    Text(
                      widget.priceLabel,
                      style: LimboTypography.filterSectionHeading,
                    ),
                    const SizedBox(height: LimboTokens.s12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          _price(_rangeValues.start),
                          style: LimboTypography.filterLabel,
                        ),
                        Text(
                          _price(_rangeValues.end),
                          style: LimboTypography.filterLabel,
                        ),
                      ],
                    ),
                    SliderTheme(
                      data: SliderThemeData(
                        trackHeight: 2,
                        activeTrackColor: LimboColors.primary,
                        inactiveTrackColor: LimboColors.lightGray,
                        thumbColor: LimboColors.white,
                        overlayColor: LimboColors.primary.withValues(alpha: 0.12),
                        rangeThumbShape: const RoundRangeSliderThumbShape(
                          enabledThumbRadius: 10,
                          elevation: 2,
                        ),
                      ),
                      child: RangeSlider(
                        values: _rangeValues,
                        min: widget.rangeMin,
                        max: widget.rangeMax,
                        divisions: divisions,
                        onChanged: (v) {
                          setState(() => _rangeValues = v);
                          widget.onRangeChanged(v);
                        },
                      ),
                    ),
                  ],
                ),
              ),
              TabBar(
                labelColor: LimboColors.primary,
                unselectedLabelColor: LimboColors.black,
                indicatorColor: LimboColors.primary,
                dividerColor: LimboTokens.hairline,
                splashFactory: NoSplash.splashFactory,
                labelStyle:
                    const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                unselectedLabelStyle:
                    const TextStyle(fontSize: 12, fontWeight: FontWeight.w400),
                tabs: widget.sections
                    .map((s) => Tab(
                          text: s.label,
                          icon: Icon(s.icon, size: 22),
                          iconMargin: const EdgeInsets.only(bottom: 4),
                        ))
                    .toList(),
              ),
              Expanded(
                child: TabBarView(
                  children: widget.sections
                      .map((s) => s.content ?? const SizedBox.shrink())
                      .toList(),
                ),
              ),
              Divider(height: 1, color: LimboTokens.hairline),
              SafeArea(
                top: false,
                child: Padding(
                  padding: const EdgeInsets.all(LimboTokens.s16),
                  child: Row(
                    children: [
                      Expanded(
                        child: _FooterButton(
                          label: widget.clearLabel,
                          filled: false,
                          onTap: widget.onClear,
                        ),
                      ),
                      const SizedBox(width: LimboTokens.s12),
                      Expanded(
                        child: _FooterButton(
                          label: widget.applyLabel,
                          filled: true,
                          onTap: widget.onApply,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _FooterButton extends StatelessWidget {
  final String label;
  final bool filled;
  final VoidCallback? onTap;

  const _FooterButton({
    required this.label,
    required this.filled,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final shape = RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(LimboTokens.rPill),
    );
    final text = Text(
      label,
      style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
    );

    return SizedBox(
      height: 44,
      child: filled
          ? FilledButton(
              onPressed: onTap,
              style: FilledButton.styleFrom(
                backgroundColor: LimboColors.primary,
                foregroundColor: LimboColors.white,
                shape: shape,
              ),
              child: text,
            )
          : OutlinedButton(
              onPressed: onTap,
              style: OutlinedButton.styleFrom(
                foregroundColor: LimboColors.primary,
                side: BorderSide(color: LimboColors.primary),
                shape: shape,
              ),
              child: text,
            ),
    );
  }
}

// ---------------------------------------------------------------------------
// Convenience sub-widgets that can be passed as a section content
// ---------------------------------------------------------------------------

/// A grid of selectable color circles. Intended as [LimboFilterSection.content]
/// inside [LimboFilterWidget].
class LimboColorFilterGrid extends StatelessWidget {
  final List<LimboFilterColor> colors;
  final Color? selectedColor;
  final void Function(Color) onColorChanged;
  final int crossAxisCount;

  const LimboColorFilterGrid({
    super.key,
    required this.colors,
    required this.selectedColor,
    required this.onColorChanged,
    this.crossAxisCount = 5,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.all(LimboTokens.s16),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        mainAxisExtent: 84,
      ),
      itemCount: colors.length,
      itemBuilder: (context, index) {
        final item = colors[index];
        final isSelected = item.color == selectedColor;
        return GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () => onColorChanged(item.color),
          child: Column(
            children: [
              AnimatedContainer(
                duration: LimboTokens.fast,
                width: 40,
                height: 40,
                padding: const EdgeInsets.all(3),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: isSelected ? LimboColors.primary : Colors.transparent,
                    width: 2,
                  ),
                ),
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: item.color,
                    shape: BoxShape.circle,
                    border: Border.all(color: LimboColors.lightGray),
                  ),
                ),
              ),
              const SizedBox(height: 6),
              Text(
                item.name,
                style: LimboTypography.colorLabel,
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        );
      },
    );
  }
}

/// Wrap of outlined, toggleable chips (sizes, fits, materials). Intended as
/// [LimboFilterSection.content].
class LimboChipFilterGrid extends StatelessWidget {
  final List<({int id, String label})> items;
  final Set<int> selectedIds;
  final ValueChanged<int> onToggle;

  const LimboChipFilterGrid({
    super.key,
    required this.items,
    required this.selectedIds,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(LimboTokens.s24),
      child: Wrap(
        spacing: LimboTokens.s12,
        runSpacing: LimboTokens.s12,
        children: [
          for (final item in items)
            _FilterChip(
              label: item.label,
              selected: selectedIds.contains(item.id),
              onTap: () => onToggle(item.id),
            ),
        ],
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _FilterChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: LimboTokens.fast,
        height: 36,
        padding: const EdgeInsets.symmetric(horizontal: LimboTokens.s16),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: selected
              ? LimboColors.primary.withValues(alpha: 0.08)
              : LimboColors.white,
          borderRadius: BorderRadius.circular(LimboTokens.rSmall),
          border: Border.all(
            color: selected ? LimboColors.primary : LimboColors.gray,
            width: selected ? 1.5 : 1,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 14,
            fontWeight: selected ? FontWeight.w600 : FontWeight.w500,
            color: selected ? LimboColors.primary : LimboColors.black,
          ),
        ),
      ),
    );
  }
}
