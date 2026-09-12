import 'package:flutter/material.dart';

/// Small animated "now playing" indicator: three bars that move up and down.
/// Freezes mid-animation when [animate] is false (paused but still current).
class EqualizerBars extends StatefulWidget {
  final Color color;
  final bool animate;

  const EqualizerBars({super.key, required this.color, this.animate = true});

  @override
  State<EqualizerBars> createState() => _EqualizerBarsState();
}

class _EqualizerBarsState extends State<EqualizerBars> with TickerProviderStateMixin {
  late final List<AnimationController> _controllers;

  @override
  void initState() {
    super.initState();
    _controllers = List.generate(3, (i) {
      return AnimationController(
        vsync: this,
        duration: Duration(milliseconds: 450 + i * 130),
      );
    });
    if (widget.animate) _startAll();
  }

  void _startAll() {
    for (final c in _controllers) {
      c.repeat(reverse: true);
    }
  }

  void _stopAll() {
    for (final c in _controllers) {
      c.stop();
    }
  }

  @override
  void didUpdateWidget(covariant EqualizerBars oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.animate != oldWidget.animate) {
      widget.animate ? _startAll() : _stopAll();
    }
  }

  @override
  void dispose() {
    for (final c in _controllers) {
      c.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 16,
      height: 16,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: _controllers.map((c) {
          return AnimatedBuilder(
            animation: c,
            builder: (context, _) {
              final height = 4 + c.value * 12;
              return Container(width: 3, height: height, color: widget.color);
            },
          );
        }).toList(),
      ),
    );
  }
}
