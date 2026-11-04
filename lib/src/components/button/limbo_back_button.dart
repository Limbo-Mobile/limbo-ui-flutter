import 'package:flutter/material.dart';
import 'package:limbo_ui_flutter/src/core/limbo_colors.dart';

/// The app's single back affordance: a plain brand-coloured arrow. Pops the
/// current route unless [onPressed] is given.
class LimboBackButton extends StatelessWidget {
  final VoidCallback? onPressed;

  const LimboBackButton({super.key, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      tooltip: MaterialLocalizations.of(context).backButtonTooltip,
      icon: Icon(Icons.arrow_back, color: LimboColors.primary),
      onPressed: onPressed ?? () => Navigator.of(context).maybePop(),
    );
  }
}
