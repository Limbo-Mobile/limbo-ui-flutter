import 'package:flutter/material.dart';
import 'package:limbo_ui_flutter/src/core/limbo_colors.dart';
import 'package:limbo_ui_flutter/src/core/limbo_typography.dart';
import 'package:limbo_ui_flutter/src/components/category/limbo_options_title.dart';

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

/// A bottom-sheet style filter panel.
///
/// All tabs, price range bounds, labels, and currency symbol are injected by
/// the consuming app — the widget has no hardcoded data.
///
/// ```dart
/// LimboFilterWidget(
///   selectedRange: const RangeValues(20, 500),
///   rangeMin: 20,
///   rangeMax: 500,
///   selectedColor: null,
///   sections: [
///     LimboFilterSection(
///       label: 'Color',
///       icon: Icons.color_lens,
///       content: LimboColorFilterGrid(
///         colors: myColors,
///         selectedColor: _color,
///         onColorChanged: (c) => setState(() => _color = c),
///       ),
///     ),
///     LimboFilterSection(label: 'Talla', icon: Icons.straighten),
///   ],
///   onRangeChanged: (v) => setState(() => _range = v),
///   onApply: () => Navigator.pop(context),
///   onClear: () => setState(() { _range = const RangeValues(20, 500); }),
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
    this.title = 'FILTRAR',
    this.priceLabel = 'Escala de Precios',
    this.currencySymbol = 'S/.',
    this.applyLabel = 'Aplicar',
    this.clearLabel = 'Limpiar',
  });

  @override
  State<LimboFilterWidget> createState() => _LimboFilterWidgetState();
}

class _LimboFilterWidgetState extends State<LimboFilterWidget> {
  late RangeValues _rangeValues;

  @override
  void initState() {
    super.initState();
    _rangeValues = widget.selectedRange;
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final divisions =
        (widget.rangeMax - widget.rangeMin).clamp(1, double.infinity).toInt();

    return DefaultTabController(
      length: widget.sections.length,
      child: Container(
        height: size.height * 0.7,
        margin: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 30),
            LimboOptionsTitle(name: widget.title),
            const SizedBox(height: 30),
            Text(
              widget.priceLabel,
              style: LimboTypography.filterSectionHeading,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '${widget.currencySymbol}${_rangeValues.start.toInt()}',
                    style: LimboTypography.filterLabel,
                  ),
                  Text(
                    '${widget.currencySymbol}${_rangeValues.end.toInt()}',
                    style: LimboTypography.filterLabel,
                  ),
                ],
              ),
            ),
            SliderTheme(
              data: SliderThemeData(
                trackHeight: 0.4,
                activeTrackColor: LimboColors.black,
                inactiveTrackColor: Colors.blueGrey,
                thumbColor: Colors.white,
                overlayColor: Colors.white.withAlpha(10),
                rangeThumbShape:
                    const RoundRangeSliderThumbShape(enabledThumbRadius: 9),
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
            // Dynamic tab headers
            TabBar(
              labelColor: LimboColors.primary,
              unselectedLabelColor: Colors.black,
              indicatorColor: LimboColors.primary,
              splashFactory: NoSplash.splashFactory,
              tabs: widget.sections
                  .map((s) => Tab(text: s.label, icon: Icon(s.icon)))
                  .toList(),
            ),
            // Dynamic tab bodies
            Expanded(
              child: TabBarView(
                children: widget.sections
                    .map((s) => s.content ?? const SizedBox.shrink())
                    .toList(),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _ActionIcon(
                  icon: Icons.check,
                  label: widget.applyLabel,
                  onTap: widget.onApply,
                ),
                const SizedBox(width: 80),
                _ActionIcon(
                  icon: Icons.settings_backup_restore,
                  label: widget.clearLabel,
                  onTap: widget.onClear,
                ),
              ],
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Convenience sub-widget: color grid that can be passed as a section content
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
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        mainAxisExtent: 100,
      ),
      shrinkWrap: true,
      itemCount: colors.length,
      itemBuilder: (context, index) {
        final item = colors[index];
        final isSelected = item.color == selectedColor;
        return GestureDetector(
          onTap: () => onColorChanged(item.color),
          child: Column(
            children: [
              Container(
                width: 30,
                height: 30,
                decoration: BoxDecoration(
                  color: item.color,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color:
                        isSelected ? LimboColors.primary : Colors.transparent,
                    width: 2,
                  ),
                ),
              ),
              const SizedBox(height: 5),
              Text(
                item.name,
                style: LimboTypography.colorLabel,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        );
      },
    );
  }
}

class _ActionIcon extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback? onTap;

  const _ActionIcon({required this.icon, required this.label, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        GestureDetector(
          onTap: onTap,
          child: Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.2),
                  spreadRadius: 1,
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Icon(icon, size: 30, color: Colors.black),
          ),
        ),
        const SizedBox(height: 8),
        Text(label, style: const TextStyle(color: Colors.black)),
      ],
    );
  }
}
