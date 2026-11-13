import 'package:flutter/material.dart';

/// Scrolls [text] continuously to the left like a real ticker/carousel: once
/// the text starts exiting on the left, a copy of it re-enters from the
/// right, with no visible jump. Only animates while [playing] is true and
/// while the text is wider than [maxWidth]; otherwise it is shown statically.
///
/// [maxWidth] must be supplied by the caller (rather than measured via a
/// LayoutBuilder) because LayoutBuilder's builder can run more than once per
/// frame with transitional constraint values, which is unsafe to pair with
/// stateful side effects like creating/disposing an AnimationController.
class MarqueeText extends StatefulWidget {
  final String text;
  final TextStyle style;
  final bool playing;
  final double height;
  final double maxWidth;

  const MarqueeText({
    super.key,
    required this.text,
    required this.style,
    required this.maxWidth,
    this.playing = true,
    this.height = 20,
  });

  @override
  State<MarqueeText> createState() => _MarqueeTextState();
}

class _MarqueeTextState extends State<MarqueeText> with TickerProviderStateMixin {
  static const _gap = 48.0;
  static const _pixelsPerSecond = 18.0;

  AnimationController? _controller;
  double _distance = 0;
  bool _needsScroll = false;

  @override
  void initState() {
    super.initState();
    _setup();
  }

  @override
  void didUpdateWidget(covariant MarqueeText oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.text != oldWidget.text ||
        widget.style != oldWidget.style ||
        widget.maxWidth != oldWidget.maxWidth) {
      _setup();
    } else if (widget.playing != oldWidget.playing) {
      _applyPlaying();
    }
  }

  void _setup() {
    final painter = TextPainter(
      text: TextSpan(text: widget.text, style: widget.style),
      maxLines: 1,
      textDirection: TextDirection.ltr,
    )..layout();

    _controller?.dispose();
    _controller = null;
    _needsScroll = widget.maxWidth > 0 && painter.width > widget.maxWidth;

    if (_needsScroll) {
      _distance = painter.width + _gap;
      final ms = (_distance / _pixelsPerSecond * 1000).round().clamp(2000, 30000);
      _controller = AnimationController(vsync: this, duration: Duration(milliseconds: ms));
      _applyPlaying();
    }
  }

  void _applyPlaying() {
    final controller = _controller;
    if (controller == null) return;
    widget.playing ? controller.repeat() : controller.stop();
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final controller = _controller;
    if (!_needsScroll || controller == null) {
      return SizedBox(
        height: widget.height,
        child: Text(
          widget.text,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: widget.style,
        ),
      );
    }

    return ClipRect(
      child: SizedBox(
        width: widget.maxWidth,
        height: widget.height,
        child: AnimatedBuilder(
          animation: controller,
          builder: (context, _) {
            final dx = -(controller.value * _distance);
            return Stack(
              clipBehavior: Clip.none,
              children: [
                Positioned(
                  left: dx,
                  top: 0,
                  child: Text(widget.text, maxLines: 1, softWrap: false, style: widget.style),
                ),
                Positioned(
                  left: dx + _distance,
                  top: 0,
                  child: Text(widget.text, maxLines: 1, softWrap: false, style: widget.style),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
