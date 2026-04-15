import 'package:flutter/material.dart';
import 'package:limbo_ui_flutter/src/core/limbo_typography.dart';

/// A clean AppBar with an optional string title, custom title widget, and
/// optional trailing action widget.
///
/// The title uses [LimboTypography.headingMedium] — font follows
/// [LimboConfiguration].
///
/// ```dart
/// LimboAppBar(title: 'Mi perfil')
/// LimboAppBar(titleWidget: MyLogo(), content: IconButton(...))
/// ```
class LimboAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String? title;
  final Widget? titleWidget;
  final Widget? content;

  const LimboAppBar({
    super.key,
    this.title,
    this.titleWidget,
    this.content,
  });

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      title: title != null
          ? Text(title!, style: LimboTypography.headingMedium)
          : titleWidget,
      actions: content != null
          ? [
              Container(
                margin: const EdgeInsets.only(right: 10),
                child: content,
              ),
            ]
          : null,
    );
  }
}
