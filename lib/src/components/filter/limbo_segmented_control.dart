import 'package:flutter/material.dart';
import 'package:limbo_ui_flutter/src/core/limbo_colors.dart';
import 'package:limbo_ui_flutter/src/core/limbo_configuration.dart';

/// A full-width segmented control with animated selection.
///
/// Renders [options] as equal-width tap targets inside a rounded container.
/// The selected segment is filled with [LimboColors.primary]; unselected
/// segments are transparent.
///
/// ```dart
/// LimboSegmentedControl<MyEnum>(
///   options: MyEnum.values,
///   selected: currentValue,
///   labelOf: (v) => v.label,
///   onSelected: (v) => setState(() => currentValue = v),
/// )
/// ```
class LimboSegmentedControl<T> extends StatelessWidget {
  final List<T> options;
  final T selected;
  final String Function(T) labelOf;
  final void Function(T) onSelected;

  const LimboSegmentedControl({
    super.key,
    required this.options,
    required this.selected,
    required this.labelOf,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: LimboColors.lightGray,
        borderRadius: BorderRadius.circular(10),
      ),
      padding: const EdgeInsets.all(3),
      child: Row(
        children: options.map((option) {
          final isSelected = option == selected;
          return Expanded(
            child: GestureDetector(
              onTap: () => onSelected(option),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                curve: Curves.easeInOut,
                padding: const EdgeInsets.symmetric(vertical: 8),
                decoration: BoxDecoration(
                  color: isSelected ? LimboColors.primary : Colors.transparent,
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: isSelected
                      ? [
                          BoxShadow(
                            color: LimboColors.primary.withValues(alpha: 0.25),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ]
                      : null,
                ),
                child: Text(
                  labelOf(option),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: LimboConfiguration().fontFamily,
                    fontSize: 12,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                    color: isSelected ? Colors.white : LimboColors.darkGray,
                    height: 1.4,
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
