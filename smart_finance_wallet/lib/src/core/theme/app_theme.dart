import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static const FlexScheme _scheme = FlexScheme.material;

  static ThemeData get light {
    return FlexThemeData.light(
      scheme: _scheme,
      useMaterial3: true,
      fontFamily: GoogleFonts.outfit().fontFamily,
      appBarStyle: FlexAppBarStyle.scaffoldBackground,
      surfaceMode: FlexSurfaceMode.levelSurfacesLowScaffold,
      blendLevel: 7,
      visualDensity: FlexColorScheme.comfortablePlatformDensity,
    );
  }

  static ThemeData get dark {
    return FlexThemeData.dark(
      scheme: _scheme,
      useMaterial3: true,
      fontFamily: GoogleFonts.outfit().fontFamily,
      appBarStyle: FlexAppBarStyle.scaffoldBackground,
      surfaceMode: FlexSurfaceMode.levelSurfacesLowScaffold,
      blendLevel: 13,
      visualDensity: FlexColorScheme.comfortablePlatformDensity,
    );
  }
}
