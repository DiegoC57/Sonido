import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Sonido's typographic scale: Montserrat for hero/section titles, Inter for
/// everything else (list titles, secondary text, chips). These stand in for
/// Spotify's proprietary "Circular" typeface, which cannot be redistributed.

/// Section headers and the Big Player title. 22–24sp, bold, Montserrat.
TextStyle appTitleLarge({double fontSize = 24, Color color = Colors.white}) {
  return GoogleFonts.montserrat(
    fontSize: fontSize,
    fontWeight: FontWeight.bold,
    color: color,
  );
}

/// Track names in lists/library and the Mini Player title. 16sp, semibold, Inter.
TextStyle appListTitle({Color color = Colors.white}) {
  return GoogleFonts.inter(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: color,
  );
}

/// Artist/album names, time counters. 12–14sp, regular, dimmed grey.
TextStyle appSecondary({double fontSize = 13, Color color = const Color(0xFFBDBDBD)}) {
  return GoogleFonts.inter(
    fontSize: fontSize,
    fontWeight: FontWeight.normal,
    color: color,
  );
}

/// Filter chips and nav-style labels. 13–14sp, medium/semibold.
TextStyle appChipLabel({required Color color, double fontSize = 13}) {
  return GoogleFonts.inter(
    fontSize: fontSize,
    fontWeight: FontWeight.w600,
    color: color,
  );
}
