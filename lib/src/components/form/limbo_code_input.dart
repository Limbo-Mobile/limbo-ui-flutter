import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:limbo_ui_flutter/src/core/limbo_colors.dart';
import 'package:limbo_ui_flutter/src/core/limbo_tokens.dart';

/// Segmented numeric code input (OTP style). A single hidden [TextField]
/// owns focus and the value, so paste and autofill work; the boxes only
/// render it. [onCompleted] fires when [length] digits are entered.
class LimboCodeInput extends StatefulWidget {
  final int length;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onCompleted;
  final bool hasError;
  final TextEditingController? controller;

  const LimboCodeInput({
    super.key,
    this.length = 6,
    this.onChanged,
    this.onCompleted,
    this.hasError = false,
    this.controller,
  });

  @override
  State<LimboCodeInput> createState() => _LimboCodeInputState();
}

class _LimboCodeInputState extends State<LimboCodeInput> {
  late final TextEditingController _controller =
      widget.controller ?? TextEditingController();
  final FocusNode _focus = FocusNode();

  @override
  void initState() {
    super.initState();
    _controller.addListener(_onText);
    _focus.addListener(() => setState(() {}));
  }

  void _onText() {
    setState(() {});
    widget.onChanged?.call(_controller.text);
    if (_controller.text.length == widget.length) {
      widget.onCompleted?.call(_controller.text);
    }
  }

  @override
  void dispose() {
    _controller.removeListener(_onText);
    if (widget.controller == null) _controller.dispose();
    _focus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final text = _controller.text;
    return GestureDetector(
      onTap: () => _focus.requestFocus(),
      behavior: HitTestBehavior.opaque,
      child: Stack(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(widget.length, (i) {
              final filled = i < text.length;
              final active = _focus.hasFocus &&
                  (i == text.length ||
                      (i == widget.length - 1 && text.length == widget.length));
              final border = widget.hasError
                  ? LimboColors.error
                  : active
                      ? LimboColors.primary
                      : LimboTokens.hairline;
              return AnimatedContainer(
                duration: LimboTokens.fast,
                curve: LimboTokens.emphasized,
                width: 46,
                height: 58,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: filled ? LimboTokens.brandWash : LimboColors.backgroundObject,
                  borderRadius: BorderRadius.circular(LimboTokens.rSmall + 2),
                  border: Border.all(color: border, width: active ? 2 : 1),
                ),
                child: AnimatedSwitcher(
                  duration: LimboTokens.fast,
                  transitionBuilder: (child, anim) =>
                      ScaleTransition(scale: anim, child: child),
                  child: Text(
                    filled ? text[i] : '',
                    key: ValueKey('$i-${filled ? text[i] : ''}'),
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: LimboTokens.ink,
                    ),
                  ),
                ),
              );
            }),
          ),
          Positioned.fill(
            child: Opacity(
              opacity: 0,
              child: TextField(
                controller: _controller,
                focusNode: _focus,
                autofocus: true,
                keyboardType: TextInputType.number,
                autofillHints: const [AutofillHints.oneTimeCode],
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(widget.length),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
