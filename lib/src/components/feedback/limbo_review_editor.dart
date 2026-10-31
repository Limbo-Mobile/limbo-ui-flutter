import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:limbo_ui_flutter/src/components/feedback/limbo_sheet.dart';
import 'package:limbo_ui_flutter/src/components/image/limbo_photo_strip.dart';
import 'package:limbo_ui_flutter/src/components/button/limbo_button.dart';
import 'package:limbo_ui_flutter/src/core/limbo_colors.dart';
import 'package:limbo_ui_flutter/src/core/limbo_tokens.dart';
import 'package:limbo_ui_flutter/src/core/limbo_typography.dart';
import 'package:limbo_ui_flutter/src/services/api/models/api_exception.dart';

/// Opens a bottom sheet to write or edit a review: interactive star row,
/// optional comment and a submit button with loading state.
///
/// [onSubmit] performs the request; when it throws, the message is shown
/// inline (the backend message for [ApiException]) and the sheet stays open.
/// The sheet closes itself on success and the returned future completes with
/// `true`; it completes with `null` when dismissed without submitting.
///
/// Photos are optional and fully injected: pass [onPickPhoto] (pick + upload
/// one image, resolve with its URL or `null` if cancelled) to show the photo
/// strip, [initialPhotoUrls] to pre-fill it when editing and [maxPhotos] to
/// cap it. [onSubmit] receives the URLs currently in the strip.
Future<bool?> showLimboReviewEditor(
  BuildContext context, {
  required String title,
  int initialRating = 0,
  String? initialComment,
  List<String> initialPhotoUrls = const [],
  int maxPhotos = 3,
  Future<String?> Function()? onPickPhoto,
  required Future<void> Function(
    int rating,
    String? comment,
    List<String> photoUrls,
  ) onSubmit,
}) {
  return showLimboSheet<bool>(
    context,
    title: title,
    builder: (ctx) => _ReviewEditorBody(
      initialRating: initialRating,
      initialComment: initialComment,
      initialPhotoUrls: initialPhotoUrls,
      maxPhotos: maxPhotos,
      onPickPhoto: onPickPhoto,
      onSubmit: onSubmit,
    ),
  );
}

class _ReviewEditorBody extends StatefulWidget {
  final int initialRating;
  final String? initialComment;
  final List<String> initialPhotoUrls;
  final int maxPhotos;
  final Future<String?> Function()? onPickPhoto;
  final Future<void> Function(int rating, String? comment, List<String> photoUrls)
      onSubmit;

  const _ReviewEditorBody({
    required this.initialRating,
    required this.initialComment,
    required this.initialPhotoUrls,
    required this.maxPhotos,
    required this.onPickPhoto,
    required this.onSubmit,
  });

  @override
  State<_ReviewEditorBody> createState() => _ReviewEditorBodyState();
}

class _ReviewEditorBodyState extends State<_ReviewEditorBody> {
  static const _labels = ['Muy malo', 'Malo', 'Regular', 'Bueno', 'Excelente'];

  late int _rating = widget.initialRating;
  late final TextEditingController _comment =
      TextEditingController(text: widget.initialComment ?? '');
  late List<String> _photoUrls = List.of(widget.initialPhotoUrls);
  bool _submitting = false;
  bool _uploadingPhoto = false;
  String? _error;

  @override
  void dispose() {
    _comment.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (_rating == 0 || _submitting || _uploadingPhoto) return;
    setState(() {
      _submitting = true;
      _error = null;
    });
    try {
      final text = _comment.text.trim();
      await widget.onSubmit(
        _rating,
        text.isEmpty ? null : text,
        List.unmodifiable(_photoUrls),
      );
      if (mounted) Navigator.of(context).pop(true);
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _submitting = false;
        _error = e is ApiException
            ? e.message
            : 'No se pudo publicar tu opinión. Inténtalo de nuevo.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final inset = MediaQuery.viewInsetsOf(context).bottom;
    return AnimatedPadding(
      duration: LimboTokens.fast,
      padding: EdgeInsets.only(bottom: inset),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(5, (i) {
              final selected = i < _rating;
              return GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () {
                  HapticFeedback.selectionClick();
                  setState(() => _rating = i + 1);
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: AnimatedScale(
                    scale: selected ? 1.12 : 1,
                    duration: LimboTokens.base,
                    curve: LimboTokens.spring,
                    child: Icon(
                      selected ? Icons.star_rounded : Icons.star_outline_rounded,
                      size: 44,
                      color: selected
                          ? LimboTokens.champagne
                          : LimboColors.normalGray,
                    ),
                  ),
                ),
              );
            }),
          ),
          const SizedBox(height: LimboTokens.s8),
          AnimatedSwitcher(
            duration: LimboTokens.fast,
            child: Text(
              _rating == 0 ? 'Toca una estrella' : _labels[_rating - 1],
              key: ValueKey(_rating),
              textAlign: TextAlign.center,
              style: LimboTypography.headingSmall.copyWith(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: LimboColors.textSecondary,
              ),
            ),
          ),
          const SizedBox(height: LimboTokens.s16),
          TextField(
            controller: _comment,
            maxLines: 4,
            maxLength: 500,
            textCapitalization: TextCapitalization.sentences,
            decoration: InputDecoration(
              hintText: 'Cuéntanos tu experiencia (opcional)',
              hintStyle: TextStyle(color: LimboColors.textHint),
              filled: true,
              fillColor: LimboColors.backgroundObject,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(LimboTokens.rMedium),
                borderSide: BorderSide.none,
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(LimboTokens.rMedium),
                borderSide: BorderSide(color: LimboColors.primary, width: 1.5),
              ),
            ),
          ),
          if (widget.onPickPhoto != null) ...[
            const SizedBox(height: LimboTokens.s16),
            LimboPhotoStrip(
              initialUrls: widget.initialPhotoUrls,
              maxPhotos: widget.maxPhotos,
              onPick: widget.onPickPhoto!,
              onChanged: (urls) => setState(() {
                _photoUrls = List.of(urls);
                _error = null;
              }),
              onBusyChanged: (busy) => setState(() => _uploadingPhoto = busy),
              onError: (message) => setState(() => _error = message),
            ),
          ],
          if (_error != null) ...[
            const SizedBox(height: LimboTokens.s8),
            Text(_error!, style: TextStyle(color: LimboColors.error)),
          ],
          const SizedBox(height: LimboTokens.s16),
          LimboButton(
            onPressed: _submit,
            isLoading: _submitting,
            disabled: _rating == 0 || _uploadingPhoto,
            child: const Text(
              'Publicar opinión',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
