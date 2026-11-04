import 'package:flutter/material.dart';
import 'package:limbo_ui_flutter/src/core/limbo_colors.dart';
import 'package:limbo_ui_flutter/src/core/limbo_tokens.dart';
import 'package:limbo_ui_flutter/src/core/limbo_typography.dart';

/// Opens a rounded modal bottom sheet with a drag handle and a [title].
/// The [builder] content scrolls when it is taller than the sheet.
Future<T?> showLimboSheet<T>(
  BuildContext context, {
  required String title,
  required WidgetBuilder builder,
  bool expand = false,
}) {
  return showModalBottomSheet<T>(
    context: context,
    isScrollControlled: true,
    backgroundColor: LimboColors.white,
    showDragHandle: false,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(
        top: Radius.circular(LimboTokens.rLarge),
      ),
    ),
    builder: (ctx) {
      final maxHeight = MediaQuery.sizeOf(ctx).height * (expand ? 0.9 : 0.75);
      return ConstrainedBox(
        constraints: BoxConstraints(maxHeight: maxHeight),
        child: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: LimboTokens.s12),
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: LimboColors.lightGray,
                  borderRadius: BorderRadius.circular(LimboTokens.rPill),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(
                  LimboTokens.s24,
                  LimboTokens.s20,
                  LimboTokens.s24,
                  LimboTokens.s8,
                ),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(title, style: LimboTypography.headingMedium),
                ),
              ),
              Flexible(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(
                    LimboTokens.s24,
                    LimboTokens.s8,
                    LimboTokens.s24,
                    LimboTokens.s24,
                  ),
                  child: builder(ctx),
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}
