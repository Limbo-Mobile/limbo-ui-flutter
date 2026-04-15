import 'package:flutter/material.dart';
import 'package:limbo_ui_flutter/src/core/limbo_colors.dart';

/// A horizontal scrolling color picker that highlights the selected index
/// with a [LimboColors.primary] ring.
///
/// [colors] is a list of maps with keys `"color"` (Color) and `"label"` (String).
///
/// ```dart
/// LimboColorPicker(
///   colors: [
///     {'color': Colors.red, 'label': 'Rojo'},
///     {'color': Colors.blue, 'label': 'Azul'},
///   ],
///   selectedColor: 0,
///   onChangeColor: (index) => setState(() => _selected = index),
/// )
/// ```
class LimboColorPicker extends StatefulWidget {
  final List<Map<String, dynamic>> colors;
  final int selectedColor;
  final void Function(int index) onChangeColor;

  const LimboColorPicker({
    super.key,
    required this.colors,
    required this.selectedColor,
    required this.onChangeColor,
  });

  @override
  State<LimboColorPicker> createState() => _LimboColorPickerState();
}

class _LimboColorPickerState extends State<LimboColorPicker> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 30,
      child: ListView.builder(
        shrinkWrap: true,
        itemCount: widget.colors.length,
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          final isSelected = widget.selectedColor == index;
          return GestureDetector(
            onTap: () => widget.onChangeColor(index),
            child: Container(
              width: 50,
              height: 60,
              padding: const EdgeInsets.all(2),
              decoration: BoxDecoration(
                color: isSelected
                    ? LimboColors.primary
                    : LimboColors.backgroundObjectBorder,
                shape: BoxShape.circle,
              ),
              child: Container(
                padding: const EdgeInsets.all(2),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
                child: CircleAvatar(
                  radius: 30,
                  backgroundColor: widget.colors[index]['color'] as Color,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
