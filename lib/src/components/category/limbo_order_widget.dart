import 'package:flutter/material.dart';
import 'package:limbo_ui_flutter/src/core/limbo_colors.dart';
import 'package:limbo_ui_flutter/src/core/limbo_typography.dart';
import 'package:limbo_ui_flutter/src/components/category/limbo_options_title.dart';

/// A single sort option for [LimboOrderWidget].
class LimboSortOption {
  final IconData icon;
  final String label;

  const LimboSortOption({required this.icon, required this.label});
}

/// A sort-order selector that renders a grid of icon+label+dot options.
///
/// All options are injected via [options] — the widget has no hardcoded data.
/// [onOptionSelected] fires with the chosen index whenever a selection changes.
///
/// ```dart
/// LimboOrderWidget(
///   options: const [
///     LimboSortOption(icon: Icons.favorite,      label: 'Recomendados'),
///     LimboSortOption(icon: Icons.arrow_upward,  label: 'Precio: mayor a menor'),
///     LimboSortOption(icon: Icons.arrow_downward,label: 'Precio: menor a mayor'),
///     LimboSortOption(icon: Icons.fiber_new,     label: 'Nuevos ingresos'),
///     LimboSortOption(icon: Icons.star,          label: 'Más vendidos'),
///   ],
///   initialSelection: 0,
///   onOptionSelected: (i) => setState(() => _sort = i),
/// )
/// ```
class LimboOrderWidget extends StatefulWidget {
  final List<LimboSortOption> options;
  final int? initialSelection;
  final void Function(int)? onOptionSelected;
  final String title;
  final int crossAxisCount;

  const LimboOrderWidget({
    super.key,
    required this.options,
    this.initialSelection,
    this.onOptionSelected,
    this.title = 'ORDENAR',
    this.crossAxisCount = 2,
  });

  @override
  State<LimboOrderWidget> createState() => _LimboOrderWidgetState();
}

class _LimboOrderWidgetState extends State<LimboOrderWidget> {
  late int _selectedOption;

  @override
  void initState() {
    super.initState();
    _selectedOption = widget.initialSelection ?? 0;
  }

  void _handleSelection(int value) {
    setState(() => _selectedOption = value);
    widget.onOptionSelected?.call(value);
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Container(
      height: size.height * 0.7,
      margin: const EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 30),
          LimboOptionsTitle(name: widget.title),
          const SizedBox(height: 60),
          GridView.count(
            shrinkWrap: true,
            childAspectRatio: 1.3,
            crossAxisCount: widget.crossAxisCount,
            crossAxisSpacing: 0,
            mainAxisSpacing: 0,
            children: List.generate(
              widget.options.length,
              (i) => _OptionButton(
                index: i,
                icon: widget.options[i].icon,
                label: widget.options[i].label,
                isSelected: _selectedOption == i,
                onTap: _handleSelection,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _OptionButton extends StatelessWidget {
  final int index;
  final IconData icon;
  final String label;
  final bool isSelected;
  final void Function(int) onTap;

  const _OptionButton({
    required this.index,
    required this.icon,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onTap(index),
      child: Column(
        children: [
          Container(
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
            child: Icon(
              icon,
              size: 30,
              color: isSelected ? LimboColors.primary : Colors.black,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            textAlign: TextAlign.center,
            style: isSelected
                ? LimboTypography.sortLabelSelected
                : LimboTypography.sortLabel,
          ),
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: 14,
            height: 14,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isSelected ? LimboColors.primary : Colors.grey.shade300,
              border: Border.all(
                color: isSelected ? LimboColors.primary : Colors.grey,
                width: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
