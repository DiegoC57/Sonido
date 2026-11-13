import 'dart:math' as math;
import 'package:flutter/material.dart';

/// "Now playing" indicator from the Onda spec: three 2.5px bars that scale
/// between 30% and 100% height (0.9s ease-in-out, offsets 0 / .3s / .55s).
/// Freezes in place when [animate] is false (paused but still current).
class EqualizerBars extends StatefulWidget {
  final Color color;
  final bool animate;
  final double height;

  const EqualizerBars({
    super.key,
    required this.color,
    this.animate = true,
    this.height = 15,
  });

  @override
  State<EqualizerBars> createState() => _EqualizerBarsState();
}

class _EqualizerBarsState extends State<EqualizerBars>
    with SingleTickerProviderStateMixin {
  static const _period = 900.0; // ms
  static const _delays = [0.0, 300.0, 550.0];

  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 900),
  );

  @override
  void initState() {
    super.initState();
    if (widget.animate) _controller.repeat();
  }

  @override
  void didUpdateWidget(covariant EqualizerBars oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.animate != oldWidget.animate) {
      widget.animate ? _controller.repeat() : _controller.stop();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  double _scale(double t) {
    // Triangle 0→1→0 eased like CSS ease-in-out keyframes 0%,100%:.3 / 50%:1.
    final x = t < .5 ? t * 2 : (1 - t) * 2;
    final eased = (1 - math.cos(x * math.pi)) / 2;
    return .3 + .7 * eased;
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 2.5 * 3 + 2.5 * 2,
      height: widget.height,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, _) {
          final ms = _controller.value * _period;
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              for (final d in _delays)
                Container(
                  width: 2.5,
                  height: widget.height *
                      _scale(((ms - d) % _period + _period) % _period / _period),
                  color: widget.color,
                ),
            ],
          );
        },
      ),
    );
  }
}
