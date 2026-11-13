import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/song_provider.dart';

/// Background/shape color pairs from the "Onda" spec, used for generative
/// placeholder covers when a track has no embedded artwork.
const _coverPalette = <(Color, Color)>[
  (Color(0xFF2E3A45), Color(0xFFF2B33D)),
  (Color(0xFF1F3B34), Color(0xFF8FD6B4)),
  (Color(0xFF6B2F2A), Color(0xFFF0C9A0)),
  (Color(0xFF3A3550), Color(0xFFC9B8F2)),
  (Color(0xFF14202E), Color(0xFF6E9BD1)),
  (Color(0xFF4A3A1E), Color(0xFFF2B33D)),
  (Color(0xFF2A2A2E), Color(0xFFE4E0D8)),
  (Color(0xFF17303A), Color(0xFF4FA3B8)),
  (Color(0xFF35271F), Color(0xFFD99A6C)),
  (Color(0xFF202A3D), Color(0xFF9FA8F0)),
  (Color(0xFF2C3B2E), Color(0xFFB9D68C)),
  (Color(0xFF241C2B), Color(0xFFC58FD6)),
];

enum CoverShape { circle, ring, bar, block, arc }

/// Deterministic palette/shape for any string or number seed, so the same
/// album always gets the same placeholder.
({Color bg, Color fg, CoverShape shape}) coverStyleFor(Object? seed) {
  final h = (seed?.toString() ?? '').hashCode.abs();
  final pair = _coverPalette[h % _coverPalette.length];
  final shape = CoverShape.values[(h ~/ 7) % CoverShape.values.length];
  return (bg: pair.$1, fg: pair.$2, shape: shape);
}

/// Generative cover: solid color + centered geometric shape + diagonal
/// texture, as described in section 4 of the design handoff.
class GenerativeCover extends StatelessWidget {
  final Object? seed;
  final bool texture;
  final double scale;

  const GenerativeCover({
    super.key,
    required this.seed,
    this.texture = true,
    this.scale = 1,
  });

  @override
  Widget build(BuildContext context) {
    final style = coverStyleFor(seed);
    return LayoutBuilder(builder: (context, c) {
      final w = c.maxWidth.isFinite ? c.maxWidth : 56.0;
      return Container(
        color: style.bg,
        alignment: Alignment.center,
        child: Stack(
          alignment: Alignment.center,
          children: [
            _shape(style.shape, style.fg, w * scale),
            if (texture) const Positioned.fill(child: CoverTexture()),
          ],
        ),
      );
    });
  }

  Widget _shape(CoverShape shape, Color c, double w) {
    switch (shape) {
      case CoverShape.circle:
        return Container(
          width: w * .46,
          height: w * .46,
          decoration: BoxDecoration(color: c, shape: BoxShape.circle),
        );
      case CoverShape.ring:
        return Container(
          width: w * .52,
          height: w * .52,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: c, width: (w * .05).clamp(2.0, 14.0)),
          ),
        );
      case CoverShape.bar:
        return Container(width: w * .64, height: w * .11, color: c);
      case CoverShape.block:
        return Container(width: w * .38, height: w * .38, color: c);
      case CoverShape.arc:
        return Container(
          width: w * .56,
          height: w * .28,
          decoration: BoxDecoration(
            color: c,
            borderRadius: BorderRadius.vertical(top: Radius.circular(w)),
          ),
        );
    }
  }
}

/// `repeating-linear-gradient(135deg, rgba(255,255,255,.04) 0 2px, transparent 2px 8px)`
class CoverTexture extends StatelessWidget {
  const CoverTexture({super.key});

  @override
  Widget build(BuildContext context) =>
      const IgnorePointer(child: CustomPaint(painter: _StripePainter()));
}

class _StripePainter extends CustomPainter {
  const _StripePainter();

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0x0AFFFFFF)
      ..strokeWidth = 2;
    canvas.clipRect(Offset.zero & size);
    const step = 8.0 * 1.4142; // 8px period measured along the 135° axis
    for (double x = -size.height; x < size.width; x += step) {
      canvas.drawLine(Offset(x, 0), Offset(x + size.height, size.height), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// Album/track artwork with the Onda placeholder fallback.
class Artwork extends ConsumerWidget {
  final int? audioId;
  final Object? seed;
  final double? size;
  final double radius;
  final bool texture;
  final List<BoxShadow>? shadow;

  const Artwork({
    super.key,
    required this.audioId,
    this.seed,
    this.size,
    this.radius = 5,
    this.texture = false,
    this.shadow,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final placeholder =
        GenerativeCover(seed: seed ?? audioId, texture: texture);
    Widget child = placeholder;
    if (audioId != null) {
      final bytes = ref.watch(artworkProvider(audioId!)).asData?.value;
      if (bytes != null) {
        child = Stack(
          fit: StackFit.expand,
          children: [
            Image.memory(bytes, fit: BoxFit.cover, gaplessPlayback: true),
            if (texture) const CoverTexture(),
          ],
        );
      }
    }
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(radius),
        boxShadow: shadow,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(radius),
        child: child,
      ),
    );
  }
}
