import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sin_flix/core/theme/app_colors.dart';

class AppTheme {
  static ThemeData get darkTheme {
    return ThemeData(
      brightness: Brightness.dark,
      primaryColor: AppColors.primaryRed,
      scaffoldBackgroundColor: AppColors.primaryBlack,
      colorScheme: const ColorScheme.dark(
        primary: AppColors.primaryRed,
        secondary: AppColors.primaryRed,
        background: AppColors.primaryBlack,
        surface: AppColors.darkGrey,
        onPrimary: AppColors.white,
        onSecondary: AppColors.white,
        onBackground: AppColors.white,
        onSurface: AppColors.white,
        error: Colors.redAccent,
        onError: AppColors.white,
      ),
      textTheme: GoogleFonts.montserratTextTheme(ThemeData.dark().textTheme).copyWith(
        displayLarge: const TextStyle(color: AppColors.white, fontWeight: FontWeight.bold),
        displayMedium: const TextStyle(color: AppColors.white, fontWeight: FontWeight.bold),
        displaySmall: const TextStyle(color: AppColors.white, fontWeight: FontWeight.bold),
        headlineMedium: const TextStyle(color: AppColors.white, fontWeight: FontWeight.bold),
        headlineSmall: const TextStyle(color: AppColors.white, fontWeight: FontWeight.w600),
        titleLarge: const TextStyle(color: AppColors.white, fontWeight: FontWeight.w600),
        bodyLarge: const TextStyle(color: AppColors.white),
        bodyMedium: TextStyle(color: AppColors.white.withOpacity(0.8)),
        labelLarge: const TextStyle(color: AppColors.white, fontWeight: FontWeight.bold, fontSize: 16),
      ),
      appBarTheme: const AppBarTheme(
        color: AppColors.darkGrey,
        elevation: 0,
        iconTheme: IconThemeData(color: AppColors.white),
        titleTextStyle: TextStyle(
            color: AppColors.white, fontSize: 20, fontWeight: FontWeight.bold),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.inputBackground,
        hintStyle: const TextStyle(color: AppColors.hintColor),
        labelStyle: const TextStyle(color: AppColors.white),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: const BorderSide(color: AppColors.primaryRed, width: 1.5),
        ),
        prefixIconColor: AppColors.hintColor,
        suffixIconColor: AppColors.hintColor,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primaryRed,
          foregroundColor: AppColors.white,
          padding: const EdgeInsets.symmetric(vertical: 16.0),
          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.lightGrey,
          textStyle: const TextStyle(fontWeight: FontWeight.w500),
        ),
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: AppColors.primaryBlack,
        selectedItemColor: AppColors.primaryRed,
        unselectedItemColor: AppColors.lightGrey,
        type: BottomNavigationBarType.fixed,
        showSelectedLabels: true, // Or false if labels are not in design
        showUnselectedLabels: true, // Or false
      ),
    );
  }
}