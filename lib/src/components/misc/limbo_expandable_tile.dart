import 'package:flutter/material.dart';
import 'package:limbo_ui_flutter/src/core/limbo_colors.dart';
import 'package:limbo_ui_flutter/src/core/limbo_tokens.dart';
import 'package:limbo_ui_flutter/src/core/limbo_typography.dart';

/// Row with icon + label that expands in place to reveal [child]. Provide
/// [onTap] instead to make it a plain navigation row (e.g. open a sheet).
class LimboExpandableTile extends StatefulWidget {
  final IconData icon;
  final String label;
  final Widget? child;
  final VoidCallback? onTap;
  final bool initiallyExpanded;

  const LimboExpandableTile({
    super.key,
    required this.icon,
    required this.label,
    this.child,
    this.onTap,
    this.initiallyExpanded = false,
  }) : assert(child != null || onTap != null);

  @override
  State<LimboExpandableTile> createState() => _LimboExpandableTileState();
}

class _LimboExpandableTileState extends State<LimboExpandableTile> {
  late bool _open = widget.initiallyExpanded;

  void _toggle() {
    if (widget.onTap != null) {
      widget.onTap!();
      return;
    }
    setState(() => _open = !_open);
  }

  @override
  Widget build(BuildContext context) {
    final expandable = widget.child != null && widget.onTap == null;
    return Column(
      children: [
        InkWell(
          onTap: _toggle,
          borderRadius: BorderRadius.circular(LimboTokens.rSmall),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: LimboTokens.s12),
            child: Row(
              children: [
                Icon(widget.icon, color: LimboColors.primary, size: 22),
                const SizedBox(width: LimboTokens.s12),
                Expanded(
                  child: Text(widget.label, style: LimboTypography.headingSmall),
                ),
                AnimatedRotation(
                  turns: _open && expandable ? 0.25 : 0,
                  duration: LimboTokens.base,
                  curve: LimboTokens.emphasized,
                  child: Icon(
                    Icons.chevron_right_rounded,
                    color: LimboColors.icons,
                  ),
                ),
              ],
            ),
          ),
        ),
        if (expandable)
          AnimatedSize(
            duration: LimboTokens.base,
            curve: LimboTokens.emphasized,
            alignment: Alignment.topCenter,
            child: _open
                ? Padding(
                    padding: const EdgeInsets.only(
                      left: 34,
                      bottom: LimboTokens.s12,
                    ),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: widget.child,
                    ),
                  )
                : const SizedBox(width: double.infinity),
          ),
      ],
    );
  }
}
