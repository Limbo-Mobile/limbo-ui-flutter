import 'package:flutter/material.dart';
import 'package:limbo_ui_flutter/src/components/image/limbo_image_viewer.dart';
import 'package:limbo_ui_flutter/src/components/image/limbo_network_image.dart';
import 'package:limbo_ui_flutter/src/components/motion/limbo_pressable.dart';
import 'package:limbo_ui_flutter/src/core/limbo_colors.dart';
import 'package:limbo_ui_flutter/src/core/limbo_tokens.dart';
import 'package:limbo_ui_flutter/src/core/limbo_typography.dart';
import 'package:limbo_ui_flutter/src/services/api/models/api_exception.dart';

/// Horizontal strip of picked photos with an "add" tile.
///
/// The package stays free of app logic: [onPick] is injected by the host. It
/// must pick *and upload* one image and resolve with its public URL (or `null`
/// when the user cancelled). While it runs, an uploading tile is shown; if it
/// throws, the message is reported through [onError] and nothing is added.
/// [onChanged] receives the current list of uploaded URLs after every change.
class LimboPhotoStrip extends StatefulWidget {
  final List<String> initialUrls;
  final int maxPhotos;
  final Future<String?> Function() onPick;
  final ValueChanged<List<String>> onChanged;
  final ValueChanged<String>? onError;
  final ValueChanged<bool>? onBusyChanged;

  const LimboPhotoStrip({
    super.key,
    required this.onPick,
    required this.onChanged,
    this.initialUrls = const [],
    this.maxPhotos = 3,
    this.onError,
    this.onBusyChanged,
  });

  @override
  State<LimboPhotoStrip> createState() => _LimboPhotoStripState();
}

class _LimboPhotoStripState extends State<LimboPhotoStrip> {
  static const double _tile = 76;

  late final List<String> _urls = List.of(widget.initialUrls);
  int _uploading = 0;

  int get _count => _urls.length + _uploading;

  void _setUploading(int value) {
    final wasBusy = _uploading > 0;
    _uploading = value;
    final isBusy = _uploading > 0;
    if (wasBusy != isBusy) widget.onBusyChanged?.call(isBusy);
  }

  Future<void> _add() async {
    if (_count >= widget.maxPhotos) return;
    setState(() => _setUploading(_uploading + 1));
    try {
      final url = await widget.onPick();
      if (!mounted) return;
      setState(() {
        _setUploading(_uploading - 1);
        if (url != null) _urls.add(url);
      });
      if (url != null) widget.onChanged(List.unmodifiable(_urls));
    } catch (e) {
      if (!mounted) return;
      setState(() => _setUploading(_uploading - 1));
      widget.onError?.call(
        e is ApiException ? e.message : 'No se pudo subir la foto. Inténtalo de nuevo.',
      );
    }
  }

  void _remove(int index) {
    setState(() => _urls.removeAt(index));
    widget.onChanged(List.unmodifiable(_urls));
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Fotos (${_urls.length}/${widget.maxPhotos})',
          style: LimboTypography.headingSmall.copyWith(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: LimboColors.textSecondary,
          ),
        ),
        const SizedBox(height: LimboTokens.s8),
        SizedBox(
          height: _tile,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: [
              for (var i = 0; i < _urls.length; i++)
                _PhotoTile(
                  url: _urls[i],
                  size: _tile,
                  onOpen: () => showLimboImageViewer(
                    context,
                    urls: List.of(_urls),
                    initialIndex: i,
                    heroPrefix: 'photo-strip',
                  ),
                  onRemove: () => _remove(i),
                  heroTag: limboImageHeroTag('photo-strip', i),
                ),
              for (var i = 0; i < _uploading; i++) const _UploadingTile(size: _tile),
              if (_count < widget.maxPhotos) _AddTile(size: _tile, onTap: _add),
            ],
          ),
        ),
      ],
    );
  }
}

class _PhotoTile extends StatelessWidget {
  final String url;
  final double size;
  final VoidCallback onOpen;
  final VoidCallback onRemove;
  final Object heroTag;

  const _PhotoTile({
    required this.url,
    required this.size,
    required this.onOpen,
    required this.onRemove,
    required this.heroTag,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: LimboTokens.s8),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          LimboPressable(
            onTap: onOpen,
            child: LimboNetworkImage(
              url,
              width: size,
              height: size,
              borderRadius: LimboTokens.rSmall + 2,
              cacheWidth: 240,
              heroTag: heroTag,
            ),
          ),
          Positioned(
            top: -6,
            right: -6,
            child: GestureDetector(
              onTap: onRemove,
              child: Semantics(
                button: true,
                label: 'Quitar foto',
                child: Container(
                  width: 22,
                  height: 22,
                  decoration: BoxDecoration(
                    color: LimboTokens.ink,
                    shape: BoxShape.circle,
                    border: Border.all(color: LimboColors.white, width: 1.5),
                  ),
                  child: Icon(Icons.close_rounded, size: 13, color: LimboColors.white),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _UploadingTile extends StatelessWidget {
  final double size;

  const _UploadingTile({required this.size});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      margin: const EdgeInsets.only(right: LimboTokens.s8),
      decoration: BoxDecoration(
        color: LimboTokens.tealWash,
        borderRadius: BorderRadius.circular(LimboTokens.rSmall + 2),
      ),
      alignment: Alignment.center,
      child: SizedBox(
        width: 22,
        height: 22,
        child: CircularProgressIndicator(strokeWidth: 2.5, color: LimboColors.primary),
      ),
    );
  }
}

class _AddTile extends StatelessWidget {
  final double size;
  final VoidCallback onTap;

  const _AddTile({required this.size, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return LimboPressable(
      onTap: onTap,
      semanticLabel: 'Agregar foto',
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: LimboColors.backgroundObject,
          borderRadius: BorderRadius.circular(LimboTokens.rSmall + 2),
          border: Border.all(color: LimboTokens.hairline),
        ),
        child: Icon(Icons.add_a_photo_outlined, color: LimboColors.primary, size: 26),
      ),
    );
  }
}
