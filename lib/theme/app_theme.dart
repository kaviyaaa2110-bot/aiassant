import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Futuristic Cyber-Medical Design System Colors
class AppColors {
  // Background Spectrum
  static const Color bgDarkest = Color(0xFF04060C);
  static const Color bgDark = Color(0xFF070B16);
  static const Color bgElevated = Color(0xFF0D1424);
  static const Color bgCard = Color(0xFF10192E);
  static const Color bgCardSubtle = Color(0xFF131F3B);

  // Backward compatibility aliases for architecture modules
  static const Color background = bgDarkest;
  static const Color surface = bgElevated;
  static const Color cardBg = bgCard;
  static const Color inputBg = bgCardSubtle;
  static const Color primary = cyanNeon;
  static const Color primaryLight = Color(0xFF5DF2FF);
  static const Color primaryDark = Color(0xFF00838F);
  static const Color primarySurface = Color(0x1F00F0FF);
  static const Color accent = electricBlue;
  static const Color accentLight = Color(0xFF64B5F6);

  // Electric Neon Accents
  static const Color cyanNeon = Color(0xFF00F0FF);
  static const Color cyanGlow = Color(0xFF00D1E6);
  static const Color cyanSubtle = Color(0x3300F0FF);
  static const Color electricBlue = Color(0xFF1E6BFF);
  static const Color neonTeal = Color(0xFF00E5BE);
  static const Color cyberPurple = Color(0xFF8A3FFC);
  static const Color neonPink = Color(0xFFFF2D78);

  // Status & Telemetry
  static const Color success = Color(0xFF00E676);
  static const Color successLight = Color(0x2200E676);
  static const Color successGlow = Color(0x3300E676);
  static const Color warning = Color(0xFFFFB300);
  static const Color warningLight = Color(0x22FFB300);
  static const Color warningGlow = Color(0x33FFB300);
  static const Color error = Color(0xFFFF3366);
  static const Color errorLight = Color(0x22FF3366);
  static const Color errorGlow = Color(0x33FF3366);

  // Typography & Neutrals
  static const Color textPrimary = Color(0xFFF1F5F9);
  static const Color textSecondary = Color(0xFF94A3B8);
  static const Color textMuted = Color(0xFF64748B);
  static const Color textDisabled = Color(0xFF475569);
  static const Color textHint = Color(0xFF64748B);

  // Glass & Borders
  static const Color glassBorder = Color(0x3300F0FF);
  static const Color glassBorderSubtle = Color(0x1A60A5FA);
  static const Color glassFill = Color(0x1A0F172A);
  static const Color divider = Color(0x1F38BDF8);

  // Signature Gradients
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [Color(0xFF00F0FF), Color(0xFF1E6BFF)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient headerGradient = LinearGradient(
    colors: [Color(0xFF070B16), Color(0xFF0E1A33), Color(0xFF002844)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient accentGradient = LinearGradient(
    colors: [Color(0xFF00E5BE), Color(0xFF00F0FF)],
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
  );

  static const LinearGradient neuralGradient = LinearGradient(
    colors: [Color(0xFF8A3FFC), Color(0xFF00F0FF)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient cardiacGradient = LinearGradient(
    colors: [Color(0xFFFF2D78), Color(0xFF8A3FFC), Color(0xFF00F0FF)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient glassCardGradient = LinearGradient(
    colors: [
      Color(0x331E293B),
      Color(0x1A0F172A),
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient darkBackgroundGradient = LinearGradient(
    colors: [
      Color(0xFF090E1E),
      Color(0xFF050812),
      Color(0xFF020409),
    ],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );
}

/// AppTheme configuration for the futuristic medical tech styling
class AppTheme {
  static ThemeData get darkTheme {
    final baseTextTheme = GoogleFonts.outfitTextTheme(ThemeData.dark().textTheme);

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: AppColors.bgDarkest,
      colorScheme: const ColorScheme.dark(
        primary: AppColors.cyanNeon,
        onPrimary: AppColors.bgDarkest,
        secondary: AppColors.electricBlue,
        onSecondary: Colors.white,
        tertiary: AppColors.neonTeal,
        surface: AppColors.bgElevated,
        onSurface: AppColors.textPrimary,
        error: AppColors.error,
        onError: Colors.white,
      ),
      textTheme: baseTextTheme.copyWith(
        displayLarge: GoogleFonts.outfit(
          fontSize: 34,
          fontWeight: FontWeight.w800,
          color: AppColors.textPrimary,
          letterSpacing: -0.5,
        ),
        displayMedium: GoogleFonts.outfit(
          fontSize: 28,
          fontWeight: FontWeight.w700,
          color: AppColors.textPrimary,
          letterSpacing: -0.3,
        ),
        headlineLarge: GoogleFonts.outfit(
          fontSize: 24,
          fontWeight: FontWeight.w700,
          color: AppColors.textPrimary,
        ),
        headlineMedium: GoogleFonts.outfit(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: AppColors.textPrimary,
        ),
        titleLarge: GoogleFonts.outfit(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: AppColors.textPrimary,
          letterSpacing: 0.2,
        ),
        titleMedium: GoogleFonts.outfit(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: AppColors.textPrimary,
        ),
        bodyLarge: GoogleFonts.outfit(
          fontSize: 16,
          fontWeight: FontWeight.w400,
          color: AppColors.textSecondary,
          height: 1.5,
        ),
        bodyMedium: GoogleFonts.outfit(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          color: AppColors.textSecondary,
          height: 1.4,
        ),
        labelLarge: GoogleFonts.outfit(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: AppColors.textPrimary,
          letterSpacing: 0.5,
        ),
        labelSmall: GoogleFonts.outfit(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: AppColors.cyanNeon,
          letterSpacing: 1.2,
        ),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        iconTheme: IconThemeData(color: AppColors.cyanNeon),
      ),
    );
  }

  // Backwards compatibility getter alias
  static ThemeData get lightTheme => darkTheme;
}
