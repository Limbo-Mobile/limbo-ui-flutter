import 'package:flutter/material.dart';
import 'package:limbo_ui_flutter/src/components/motion/limbo_reveal.dart';
import 'package:limbo_ui_flutter/src/core/limbo_colors.dart';
import 'package:limbo_ui_flutter/src/core/limbo_tokens.dart';
import 'package:limbo_ui_flutter/src/core/limbo_typography.dart';

/// One step of a [LimboTimeline].
class LimboTimelineStep {
  final String title;
  final String? subtitle;
  final IconData icon;

  /// `true` when the step already happened; pending steps render muted.
  final bool done;

  const LimboTimelineStep({
    required this.title,
    required this.icon,
    this.subtitle,
    this.done = true,
  });
}

/// Vertical timeline with a connector line; steps animate in sequentially.
class LimboTimeline extends StatelessWidget {
  final List<LimboTimelineStep> steps;

  const LimboTimeline({super.key, required this.steps});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(steps.length, (i) {
        final step = steps[i];
        final isLast = i == steps.length - 1;
        final color = step.done ? LimboColors.primary : LimboColors.gray;
        return LimboReveal(
          delay: LimboReveal.stagger(i),
          child: IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: 40,
                  child: Column(
                    children: [
                      Container(
                        width: 32,
                        height: 32,
                        decoration: BoxDecoration(
                          color: step.done
                              ? color
                              : LimboColors.backgroundObject,
                          shape: BoxShape.circle,
                          border: Border.all(color: color, width: 1.5),
                        ),
                        child: Icon(
                          step.icon,
                          size: 16,
                          color: step.done ? LimboColors.white : color,
                        ),
                      ),
                      if (!isLast)
                        Expanded(
                          child: Container(
                            width: 2,
                            margin: const EdgeInsets.symmetric(vertical: 4),
                            color: color.withValues(alpha: 0.35),
                          ),
                        ),
                    ],
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(
                      left: LimboTokens.s8,
                      bottom: isLast ? 0 : LimboTokens.s20,
                      top: 4,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          step.title,
                          style: LimboTypography.headingSmall.copyWith(
                            color: step.done
                                ? LimboColors.textPrimary
                                : LimboColors.darkGray,
                          ),
                        ),
                        if (step.subtitle != null)
                          Padding(
                            padding: const EdgeInsets.only(top: 2),
                            child: Text(
                              step.subtitle!,
                              style: LimboTypography.headingSmall.copyWith(
                                fontSize: 13,
                                fontWeight: FontWeight.w400,
                                color: LimboColors.textSecondary,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }
}
