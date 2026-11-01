import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:limbo_ui_flutter/src/components/category/limbo_panel_header.dart';
import 'package:limbo_ui_flutter/src/core/limbo_colors.dart';
import 'package:limbo_ui_flutter/src/core/limbo_tokens.dart';
import 'package:limbo_ui_flutter/src/core/limbo_typography.dart';

/// A single sort option for [LimboOrderWidget].
class LimboSortOption {
  final IconData icon;
  final String label;

  const LimboSortOption({required this.icon, required this.label});
}

/// Sort selector shown in a bottom sheet: one row per option with an icon
/// tile, the label and a radio dot. Picking an option reports it through
/// [onOptionSelected] and closes the sheet (unless [closeOnSelect] is false).
///
/// All options are injected via [options] — the widget has no hardcoded data.
///
/// ```dart
/// showModalBottomSheet(
///   context: context,
///   backgroundColor: Colors.transparent,
///   builder: (_) => LimboOrderWidget(
///     options: const [
///       LimboSortOption(icon: Icons.fiber_new, label: 'Ingresos nuevos'),
///       LimboSortOption(icon: Icons.arrow_downward, label: 'Precio menor a mayor'),
///     ],
///     initialSelection: 0,
///     onOptionSelected: (i) => setState(() => _sort = i),
///   ),
/// )
/// ```
class LimboOrderWidget extends StatefulWidget {
  final List<LimboSortOption> options;
  final int? initialSelection;
  final void Function(int)? onOptionSelected;
  final String title;
  final bool closeOnSelect;

  const LimboOrderWidget({
    super.key,
    required this.options,
    this.initialSelection,
    this.onOptionSelected,
    this.title = 'Ordenar',
    this.closeOnSelect = true,
  });

  @override
  State<LimboOrderWidget> createState() => _LimboOrderWidgetState();
}

class _LimboOrderWidgetState extends State<LimboOrderWidget> {
  late int _selected = widget.initialSelection ?? 0;

  Future<void> _select(int index) async {
    HapticFeedback.selectionClick();
    setState(() => _selected = index);
    widget.onOptionSelected?.call(index);
    if (!widget.closeOnSelect) return;
    // Let the radio animate before the sheet goes away.
    await Future<void>.delayed(const Duration(milliseconds: 180));
    if (mounted) Navigator.of(context).maybePop();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: LimboColors.white,
      borderRadius: const BorderRadius.vertical(
        top: Radius.circular(LimboTokens.rLarge),
      ),
      clipBehavior: Clip.antiAlias,
      child: SizedBox(
        height: limboPanelHeight(context),
        child: SafeArea(
          top: false,
          child: Column(
            children: [
              LimboPanelHeader(title: widget.title),
              // Rows share the whole panel evenly, so a short list still fills it.
              for (var i = 0; i < widget.options.length; i++)
                Expanded(
                  child: _OptionRow(
                    option: widget.options[i],
                    isSelected: _selected == i,
                    onTap: () => _select(i),
                  ),
                ),
              const SizedBox(height: LimboTokens.s8),
            ],
          ),
        ),
      ),
    );
  }
}

class _OptionRow extends StatelessWidget {
  final LimboSortOption option;
  final bool isSelected;
  final VoidCallback onTap;

  const _OptionRow({
    required this.option,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: LimboTokens.s24),
        child: Row(
          children: [
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: LimboColors.white,
                borderRadius: BorderRadius.circular(LimboTokens.rSmall),
                boxShadow: LimboTokens.shadowSoft,
              ),
              child: Icon(
                option.icon,
                size: 30,
                color: isSelected ? LimboColors.primary : LimboColors.black,
              ),
            ),
            const SizedBox(width: LimboTokens.s16),
            Expanded(
              child: Text(
                option.label,
                style: isSelected
                    ? LimboTypography.sortLabelSelected
                    : LimboTypography.sortLabel,
              ),
            ),
            AnimatedContainer(
              duration: LimboTokens.fast,
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected ? LimboColors.primary : LimboColors.gray,
                  width: 1.5,
                ),
              ),
              alignment: Alignment.center,
              child: AnimatedContainer(
                duration: LimboTokens.fast,
                width: isSelected ? 10 : 0,
                height: isSelected ? 10 : 0,
                decoration: BoxDecoration(
                  color: LimboColors.primary,
                  shape: BoxShape.circle,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
