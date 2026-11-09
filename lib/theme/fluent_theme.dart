import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class FluentTheme {
  // Windows 11 Fluent Civic Enterprise Palette
  static const Color canvasBg = Color(0xFFF3F3F3);
  static const Color background = canvasBg;
  static const Color sidebarBg = Color(0xFFF9F9F9);
  static const Color cardBg = Color(0xFFFFFFFF);
  static const Color border = Color(0xFFE5E5E5);
  static const Color borderStrong = Color(0xFFD1D1D1);
  static const Color borderSubtle = Color(0xFFEDEBE9);
  static const Color divider = Color(0xFFE0E0E0);
  static const Color hover = Color(0x0A000000);
  static const Color hoverBg = Color(0xFFF9F9F9);
  static const Color activePillBg = Color(0xFFEAEAEA);

  static const Color textPrimary = Color(0xFF1F1F1F);
  static const Color textSecondary = Color(0xFF5D5D5D);
  static const Color textTertiary = Color(0xFF8A8A8A);

  static const Color primary = Color(0xFF107C41); // Civic Emerald
  static const Color primaryHover = Color(0xFF0E6B38);
  static const Color primaryPressed = Color(0xFF0B542B);
  static const Color primaryDark = primaryPressed;
  static const Color primaryLight = Color(0xFFE8F5E9);
  static const Color primaryBorder = Color(0xFF0E6B37);

  static const Color accent = Color(0xFF0067B8);
  static const Color accentOrange = Color(0xFFD83B01);
  static const Color accentRed = Color(0xFFC42B1C);
  static const Color error = accentRed;
  static const Color accentAmber = Color(0xFF9D5D00);

  // Border Radii
  static const double radiusSm = 4.0; // buttons, inputs
  static const double radiusCard = 6.0; // cards, tables
  static const double radiusLg = 8.0; // dialogs, modals

  // Shadows
  static List<BoxShadow> get cardShadow => [
        const BoxShadow(
          color: Color(0x0A000000),
          offset: Offset(0, 1),
          blurRadius: 3,
        ),
        const BoxShadow(
          color: Color(0x0F000000),
          offset: Offset(0, 0),
          blurRadius: 1,
        ),
      ];

  static List<BoxShadow> get elevationShadow => [
        const BoxShadow(
          color: Color(0x14000000),
          offset: Offset(0, 4),
          blurRadius: 12,
        ),
        const BoxShadow(
          color: Color(0x0F000000),
          offset: Offset(0, 0),
          blurRadius: 1,
        ),
      ];

  static TextStyle get headlineLg => GoogleFonts.plusJakartaSans(
        fontSize: 22,
        fontWeight: FontWeight.w700,
        color: textPrimary,
        height: 1.25,
      );

  static TextStyle get headlineMd => GoogleFonts.plusJakartaSans(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: textPrimary,
        height: 1.3,
      );

  static TextStyle get heading => headlineLg;
  static TextStyle get subheading => headlineMd;

  static TextStyle get title => GoogleFonts.plusJakartaSans(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: textPrimary,
      );

  static TextStyle get bodyBold => title;

  static TextStyle get body => GoogleFonts.plusJakartaSans(
        fontSize: 13,
        fontWeight: FontWeight.w400,
        color: textPrimary,
        height: 1.45,
      );

  static TextStyle get bodyMuted => GoogleFonts.plusJakartaSans(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        color: textSecondary,
        height: 1.4,
      );

  static TextStyle get caption => bodyMuted;

  static TextStyle get label => GoogleFonts.plusJakartaSans(
        fontSize: 11,
        fontWeight: FontWeight.w600,
        color: textSecondary,
      );

  static TextStyle get captionBold => label;

  static TextStyle get buttonText => GoogleFonts.plusJakartaSans(
        fontSize: 13,
        fontWeight: FontWeight.w600,
        color: Colors.white,
      );

  static ThemeData get theme => ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: canvasBg,
        colorScheme: ColorScheme.fromSeed(
          seedColor: primary,
          primary: primary,
          surface: cardBg,
          onSurface: textPrimary,
          error: accentRed,
        ),
        textTheme: GoogleFonts.plusJakartaSansTextTheme().copyWith(
          headlineLarge: headlineLg,
          headlineMedium: headlineMd,
          titleMedium: title,
          bodyMedium: body,
          bodySmall: bodyMuted,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: primary,
            foregroundColor: Colors.white,
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(radiusSm),
            ),
          ),
        ),
        outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(
            foregroundColor: textPrimary,
            side: const BorderSide(color: border),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(radiusSm),
            ),
          ),
        ),
        cardTheme: CardThemeData(
          color: cardBg,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radiusCard),
            side: const BorderSide(color: border),
          ),
        ),
        dividerTheme: const DividerThemeData(
          color: border,
          thickness: 1,
          space: 1,
        ),
      );
}
