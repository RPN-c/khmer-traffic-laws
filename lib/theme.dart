import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppColors {
  // Main palette — white background, black text as required
  static const background = Color(0xFFFFFFFF);
  static const textPrimary = Color(0xFF000000);
  static const textSecondary = Color(0xFF555555);

  // Category accent colors
  static const general = Color(0xFF1565C0);    // Deep Blue
  static const sign = Color(0xFFE65100);       // Deep Orange
  static const priority = Color(0xFF6A1B9A);   // Purple
  static const technique = Color(0xFF2E7D32);  // Green
  static const emergency = Color(0xFFC62828);  // Red
  static const exam = Color(0xFF00695C);       // Teal

  // UI colors
  static const cardBg = Color(0xFFF5F5F5);
  static const divider = Color(0xFFE0E0E0);
  static const correctBg = Color(0xFFE8F5E9);
  static const correctBorder = Color(0xFF43A047);
  static const wrongBg = Color(0xFFFFEBEE);
  static const wrongBorder = Color(0xFFE53935);
  static const selectedBg = Color(0xFFE3F2FD);
  static const selectedBorder = Color(0xFF1565C0);
}

class AppTheme {
  static ThemeData get theme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.general,
        brightness: Brightness.light,
        background: AppColors.background,
        surface: AppColors.background,
      ),
      scaffoldBackgroundColor: AppColors.background,
      textTheme: GoogleFonts.notoSansKhmerTextTheme().copyWith(
        headlineLarge: GoogleFonts.notoSansKhmer(
          fontSize: 64,
          fontWeight: FontWeight.w700,
          color: AppColors.textPrimary,
        ),
        headlineMedium: GoogleFonts.notoSansKhmer(
          fontSize: 32,
          fontWeight: FontWeight.w600,
          color: AppColors.textPrimary,
        ),
        titleLarge: GoogleFonts.notoSansKhmer(
          fontSize: 24,
          fontWeight: FontWeight.w600,
          color: AppColors.textPrimary,
        ),
        bodyLarge: GoogleFonts.notoSansKhmer(
          fontSize: 20,
          color: AppColors.textPrimary,
        ),
        bodyMedium: GoogleFonts.notoSansKhmer(
          fontSize: 18,
          color: AppColors.textSecondary,
        ),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.background,
        foregroundColor: AppColors.textPrimary,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: GoogleFonts.notoSansKhmer(
          fontSize: 24,
          fontWeight: FontWeight.w700,
          color: AppColors.textPrimary,
        ),
      ),
    );
  }
}

Color categoryColor(String category) {
  switch (category) {
    case 'general': return AppColors.general;
    case 'sign': return AppColors.sign;
    case 'priority': return AppColors.priority;
    case 'technique': return AppColors.technique;
    case 'emergency': return AppColors.emergency;
    default: return AppColors.exam;
  }
}

String categoryLabel(String category) {
  switch (category) {
    case 'general': return 'ច្បាប់ទូទៅ';
    case 'sign': return 'សញ្ញាចរាចរណ៍';
    case 'priority': return 'អាទិភាព';
    case 'technique': return 'បច្ចេកទេស';
    case 'emergency': return 'អាសន្ន';
    default: return category;
  }
}

String categoryIcon(String category) {
  switch (category) {
    case 'general': return '📋';
    case 'sign': return '🚦';
    case 'priority': return '⚡';
    case 'technique': return '🔧';
    case 'emergency': return '🚨';
    default: return '📝';
  }
}
