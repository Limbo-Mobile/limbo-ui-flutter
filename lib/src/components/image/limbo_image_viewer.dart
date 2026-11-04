import 'package:flutter/material.dart';
import 'package:limbo_ui_flutter/src/components/image/limbo_network_image.dart';
import 'package:limbo_ui_flutter/src/core/limbo_tokens.dart';

/// Hero tag shared between a thumbnail and the fullscreen viewer.
/// Use the same [prefix] for the thumbnails of one gallery and for
/// [showLimboImageViewer].
Object limboImageHeroTag(String prefix, int index) => 'limbo-image-$prefix-$index';

/// Opens a fullscreen gallery for [urls] starting at [initialIndex]: swipe
/// between photos, pinch to zoom, double-tap to toggle zoom, drag down or tap
/// the close button to dismiss. The picture flies from its thumbnail when the
/// thumbnail is a [LimboNetworkImage] with `heroTag: limboImageHeroTag(prefix, i)`.
Future<void> showLimboImageViewer(
  BuildContext context, {
  required List<String> urls,
  int initialIndex = 0,
  String heroPrefix = 'gallery',
}) {
  if (urls.isEmpty) return Future.value();
  return Navigator.of(context, rootNavigator: true).push<void>(
    PageRouteBuilder<void>(
      opaque: false,
      barrierColor: Colors.black87,
      transitionDuration: LimboTokens.base,
      reverseTransitionDuration: LimboTokens.base,
      pageBuilder: (_, __, ___) => LimboImageViewer(
        urls: urls,
        initialIndex: initialIndex,
        heroPrefix: heroPrefix,
      ),
      transitionsBuilder: (_, animation, __, child) =>
          FadeTransition(opacity: animation, child: child),
    ),
  );
}

class LimboImageViewer extends StatefulWidget {
  final List<String> urls;
  final int initialIndex;
  final String heroPrefix;

  const LimboImageViewer({
    super.key,
    required this.urls,
    this.initialIndex = 0,
    this.heroPrefix = 'gallery',
  });

  @override
  State<LimboImageViewer> createState() => _LimboImageViewerState();
}

class _LimboImageViewerState extends State<LimboImageViewer> {
  late final PageController _pages =
      PageController(initialPage: widget.initialIndex);
  late int _index = widget.initialIndex;
  bool _zoomed = false;
  double _dragOffset = 0;

  @override
  void dispose() {
    _pages.dispose();
    super.dispose();
  }

  void _onZoomChanged(bool zoomed) {
    if (zoomed != _zoomed) setState(() => _zoomed = zoomed);
  }

  @override
  Widget build(BuildContext context) {
    final fade = (1 - (_dragOffset.abs() / 300)).clamp(0.3, 1.0);
    return Scaffold(
      backgroundColor: Colors.black.withValues(alpha: 0.9 * fade),
      body: GestureDetector(
        onVerticalDragUpdate: _zoomed
            ? null
            : (d) => setState(() => _dragOffset += d.delta.dy),
        onVerticalDragEnd: _zoomed
            ? null
            : (d) {
                if (_dragOffset.abs() > 120 ||
                    (d.primaryVelocity ?? 0).abs() > 700) {
                  Navigator.of(context).pop();
                } else {
                  setState(() => _dragOffset = 0);
                }
              },
        child: Stack(
          children: [
            Transform.translate(
              offset: Offset(0, _dragOffset),
              child: PageView.builder(
                controller: _pages,
                itemCount: widget.urls.length,
                physics: _zoomed
                    ? const NeverScrollableScrollPhysics()
                    : const PageScrollPhysics(),
                onPageChanged: (i) => setState(() {
                  _index = i;
                  _zoomed = false;
                }),
                itemBuilder: (_, i) => _ZoomablePage(
                  url: widget.urls[i],
                  heroTag: limboImageHeroTag(widget.heroPrefix, i),
                  onZoomChanged: _onZoomChanged,
                ),
              ),
            ),
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(LimboTokens.s8),
                child: Row(
                  children: [
                    IconButton(
                      tooltip: 'Cerrar',
                      onPressed: () => Navigator.of(context).pop(),
                      icon: const Icon(Icons.close_rounded, color: Colors.white),
                    ),
                    const Spacer(),
                    if (widget.urls.length > 1)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.black45,
                          borderRadius: BorderRadius.circular(LimboTokens.rPill),
                        ),
                        child: Text(
                          '${_index + 1} / ${widget.urls.length}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    const SizedBox(width: LimboTokens.s8),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ZoomablePage extends StatefulWidget {
  final String url;
  final Object heroTag;
  final ValueChanged<bool> onZoomChanged;

  const _ZoomablePage({
    required this.url,
    required this.heroTag,
    required this.onZoomChanged,
  });

  @override
  State<_ZoomablePage> createState() => _ZoomablePageState();
}

class _ZoomablePageState extends State<_ZoomablePage>
    with SingleTickerProviderStateMixin {
  final TransformationController _controller = TransformationController();
  late final AnimationController _anim = AnimationController(
    vsync: this,
    duration: LimboTokens.base,
  );
  Animation<Matrix4>? _tween;
  Offset _doubleTapAt = Offset.zero;

  @override
  void initState() {
    super.initState();
    _anim.addListener(() {
      if (_tween != null) _controller.value = _tween!.value;
    });
  }

  @override
  void dispose() {
    _anim.dispose();
    _controller.dispose();
    super.dispose();
  }

  bool get _isZoomed => _controller.value.getMaxScaleOnAxis() > 1.01;

  void _toggleZoom() {
    final end = _isZoomed
        ? Matrix4.identity()
        : (Matrix4.identity()
          ..translateByDouble(-_doubleTapAt.dx * 1.5, -_doubleTapAt.dy * 1.5, 0, 1)
          ..scaleByDouble(2.5, 2.5, 1, 1));
    _tween = Matrix4Tween(begin: _controller.value, end: end)
        .animate(CurvedAnimation(parent: _anim, curve: LimboTokens.emphasized));
    _anim.forward(from: 0).whenComplete(
          () => widget.onZoomChanged(_isZoomed),
        );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onDoubleTapDown: (d) => _doubleTapAt = d.localPosition,
      onDoubleTap: _toggleZoom,
      child: InteractiveViewer(
        transformationController: _controller,
        minScale: 1,
        maxScale: 5,
        onInteractionEnd: (_) => widget.onZoomChanged(_isZoomed),
        child: Center(
          child: LimboNetworkImage(
            widget.url,
            fit: BoxFit.contain,
            heroTag: widget.heroTag,
            errorIcon: Icons.broken_image_outlined,
          ),
        ),
      ),
    );
  }
}
