import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // Custom Color Scheme for "Premium Dark" feel
  static const FlexSchemeColor _customScheme = FlexSchemeColor(
    primary: Color(0xFF2979FF), // Electric Blue
    primaryContainer: Color(0xFF004ECB),
    secondary: Color(0xFF00E676), // Neon Green
    secondaryContainer: Color(0xFF00B248),
    tertiary: Color(0xFFFF4081), // Neon Pink (Rewards)
    tertiaryContainer: Color(0xFFC60055),
    appBarColor: Color(0xFF000000),
    error: Color(0xFFCF6679),
  );

  static ThemeData get light {
    return FlexThemeData.light(
      colors: _customScheme,
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
      colors: _customScheme,
      useMaterial3: true,
      fontFamily: GoogleFonts.outfit().fontFamily,
      appBarStyle: FlexAppBarStyle.background,
      surfaceMode: FlexSurfaceMode.levelSurfacesLowScaffold,
      blendLevel: 20, // Higher blend for glassmorphism feel
      darkIsTrueBlack: true, // Deep black backgrounds
      visualDensity: FlexColorScheme.comfortablePlatformDensity,
      subThemesData: const FlexSubThemesData(
        blendOnLevel: 20,
        blendTextTheme: true,
        useTextTheme: true,
        useM2StyleDividerInM3: true,
        defaultRadius: 24.0, // More rounded modern look
        elevatedButtonSchemeColor: SchemeColor.primary,
        elevatedButtonSecondarySchemeColor: SchemeColor.onPrimary,
        inputDecoratorBorderType: FlexInputBorderType.outline,
        inputDecoratorRadius: 16.0,
        fabUseShape: true,
        fabRadius: 16.0,
      ),
    );
  }
}
