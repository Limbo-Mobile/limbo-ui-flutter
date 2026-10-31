import 'dart:async';

import 'package:flutter/material.dart';
import 'package:limbo_ui_flutter/src/core/limbo_colors.dart';
import 'package:limbo_ui_flutter/src/core/limbo_tokens.dart';

/// Live "vence en mm:ss" pill counting down to [deadline].
///
/// Turns to the error colour when less than [warnBelow] remains and shows
/// [expiredLabel] after the deadline, firing [onExpired] once.
class LimboCountdown extends StatefulWidget {
  final DateTime deadline;
  final VoidCallback? onExpired;
  final Duration warnBelow;
  final String prefix;
  final String expiredLabel;

  /// Injectable clock (tests); defaults to [DateTime.now].
  final DateTime Function()? clock;

  const LimboCountdown({
    super.key,
    required this.deadline,
    this.onExpired,
    this.warnBelow = const Duration(minutes: 5),
    this.prefix = 'Vence en ',
    this.expiredLabel = 'Venció',
    this.clock,
  });

  /// Time left until [deadline] at [now], never negative.
  static Duration remaining(DateTime deadline, DateTime now) {
    final diff = deadline.difference(now);
    return diff.isNegative ? Duration.zero : diff;
  }

  /// `mm:ss`, or `h:mm:ss` from one hour up.
  static String format(Duration d) {
    final hours = d.inHours;
    final minutes = d.inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds = d.inSeconds.remainder(60).toString().padLeft(2, '0');
    return hours > 0 ? '$hours:$minutes:$seconds' : '$minutes:$seconds';
  }

  @override
  State<LimboCountdown> createState() => _LimboCountdownState();
}

class _LimboCountdownState extends State<LimboCountdown> {
  Timer? _timer;
  late Duration _left;
  bool _notified = false;

  DateTime _now() => (widget.clock ?? DateTime.now)();

  @override
  void initState() {
    super.initState();
    _left = LimboCountdown.remaining(widget.deadline, _now());
    _notifyIfExpired();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) => _tick());
  }

  @override
  void didUpdateWidget(covariant LimboCountdown old) {
    super.didUpdateWidget(old);
    if (old.deadline != widget.deadline) {
      _notified = false;
      _tick();
    }
  }

  void _tick() {
    final left = LimboCountdown.remaining(widget.deadline, _now());
    if (!mounted) return;
    setState(() => _left = left);
    _notifyIfExpired();
  }

  void _notifyIfExpired() {
    if (_left == Duration.zero && !_notified) {
      _notified = true;
      // Defer so a parent rebuild never happens during our own build/init.
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) widget.onExpired?.call();
      });
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final expired = _left == Duration.zero;
    final urgent = expired || _left < widget.warnBelow;
    final color = urgent ? LimboColors.error : LimboColors.textSecondary;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(LimboTokens.rPill),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.timer_outlined, size: 14, color: color),
          const SizedBox(width: 6),
          Text(
            expired
                ? widget.expiredLabel
                : '${widget.prefix}${LimboCountdown.format(_left)}',
            style: TextStyle(
              color: color,
              fontSize: 12,
              fontWeight: FontWeight.w700,
              fontFeatures: const [FontFeature.tabularFigures()],
            ),
          ),
        ],
      ),
    );
  }
}
