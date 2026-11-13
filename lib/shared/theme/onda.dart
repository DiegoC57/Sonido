import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Design tokens for the "Onda" visual system (see design/DISENO_ONDA_1.md).
abstract final class Onda {
  // ── Colors ────────────────────────────────────────────────────────────
  static const bg = Color(0xFF0B0B0C);
  static const bgOuter = Color(0xFF0E0E10);
  static const surface1 = Color(0xFF141418); // queue sheet, row hover
  static const surface2 = Color(0xFF17171B); // quick-access cards
  static const surface2Hover = Color(0xFF1F1F25);
  static const surface3 = Color(0xFF1C1C21); // inactive chips
  static const surface5 = Color(0xFF1E1E23); // round header buttons

  static const text = Color(0xFFF4F2EE);
  static const text2 = Color(0x99F4F2EE); // .60
  static const text3 = Color(0x80F4F2EE); // .50
  static const text4 = Color(0x66F4F2EE); // .40
  static const textFaint = Color(0x59F4F2EE); // .35 (decorative only)
  static const navInactive = Color(0x73F4F2EE); // .45
  static const divider = Color(0x12F4F2EE); // .07
  static const track = Color(0x2EF4F2EE); // .18

  static const accent = Color(0xFFF2B33D);
  static const accentHover = Color(0xFFF7C868);
  static const onAccent = Color(0xFF14110B);
  static const success = Color(0xFF8FD6B4);

  // ── Spacing / radii ───────────────────────────────────────────────────
  static const gutter = 20.0;
  static const playerGutter = 24.0;
  static const sectionGap = 26.0;
  static const carouselGap = 14.0;

  static const tabBarHeight = 76.0;

  /// Bottom-sheet motion from the spec: cubic-bezier(.32,.72,0,1), 420ms.
  static const sheetCurve = Cubic(0.32, 0.72, 0, 1);
  static const sheetDuration = Duration(milliseconds: 420);

  // ── Typography ────────────────────────────────────────────────────────
  /// Space Grotesk — titles. [tracking] is in em, like the spec.
  static TextStyle display(
    double size, {
    FontWeight weight = FontWeight.w600,
    double tracking = -0.02,
    Color color = text,
    double? height,
  }) =>
      GoogleFonts.spaceGrotesk(
        fontSize: size,
        fontWeight: weight,
        letterSpacing: size * tracking,
        color: color,
        height: height,
      );

  /// Geist — UI text.
  static TextStyle ui(
    double size, {
    FontWeight weight = FontWeight.w400,
    Color color = text,
    double? height,
  }) =>
      GoogleFonts.geist(
        fontSize: size,
        fontWeight: weight,
        color: color,
        height: height,
      );

  /// Monospace labels/times. Pass text already upper-cased for labels.
  static TextStyle mono(
    double size, {
    FontWeight weight = FontWeight.w500,
    double tracking = 0.12,
    Color color = text4,
  }) =>
      GoogleFonts.geistMono(
        fontSize: size,
        fontWeight: weight,
        letterSpacing: size * tracking,
        color: color,
        height: 1,
      );

  static ThemeData theme() => _theme;
  static final ThemeData _theme = _buildTheme();

  static ThemeData _buildTheme() {
    final base = ThemeData(brightness: Brightness.dark, useMaterial3: true);
    return base.copyWith(
      scaffoldBackgroundColor: bg,
      canvasColor: bg,
      colorScheme: const ColorScheme.dark(
        primary: accent,
        onPrimary: onAccent,
        secondary: success,
        surface: bg,
        onSurface: text,
        surfaceContainerHighest: surface2,
        surfaceTint: Colors.transparent,
      ),
      textTheme: GoogleFonts.geistTextTheme(base.textTheme).apply(
        bodyColor: text,
        displayColor: text,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: bg,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        titleTextStyle: display(18),
      ),
      dividerColor: divider,
      dividerTheme: const DividerThemeData(color: divider, thickness: 1),
      bottomSheetTheme: const BottomSheetThemeData(
        backgroundColor: surface1,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(18)),
        ),
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: surface1,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        titleTextStyle: display(18),
      ),
      popupMenuTheme: PopupMenuThemeData(
        color: surface5,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        textStyle: ui(13.5),
      ),
      progressIndicatorTheme: const ProgressIndicatorThemeData(color: accent),
      textSelectionTheme: const TextSelectionThemeData(cursorColor: accent),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: surface5,
        contentTextStyle: ui(13),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}

/// Darkens [c] until white text on it reaches at least 4.5:1 contrast.
Color ensureContrastWithWhite(Color c) {
  var hsl = HSLColor.fromColor(c);
  for (var i = 0; i < 20; i++) {
    final color = hsl.toColor();
    final contrast = 1.05 / (color.computeLuminance() + 0.05);
    if (contrast >= 4.5) return color;
    hsl = hsl.withLightness((hsl.lightness - 0.04).clamp(0.0, 1.0));
  }
  return hsl.toColor();
}
