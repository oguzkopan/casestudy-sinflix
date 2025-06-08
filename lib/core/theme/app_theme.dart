import 'package:flutter/material.dart';
import 'package:sin_flix/core/theme/app_colors.dart';

class AppTheme {
  /* helper that applies EuclidCircularA across the default dark textTheme */
  static TextTheme _euclid(TextTheme base) => base.copyWith(
    /* Headlines ------------------------------------------------------ */
    displayLarge:   base.displayLarge?.copyWith(
        fontFamily: 'EuclidCircularA', fontWeight: FontWeight.w700, color: AppColors.white),
    displayMedium:  base.displayMedium?.copyWith(
        fontFamily: 'EuclidCircularA', fontWeight: FontWeight.w700, color: AppColors.white),
    displaySmall:   base.displaySmall?.copyWith(
        fontFamily: 'EuclidCircularA', fontWeight: FontWeight.w700, color: AppColors.white),
    headlineMedium: base.headlineMedium?.copyWith(
        fontFamily: 'EuclidCircularA', fontWeight: FontWeight.w700, color: AppColors.white),
    headlineSmall:  base.headlineSmall?.copyWith(
        fontFamily: 'EuclidCircularA', fontWeight: FontWeight.w600, color: AppColors.white),

    /* Body ----------------------------------------------------------- */
    titleLarge:  base.titleLarge ?.copyWith(
        fontFamily: 'EuclidCircularA', fontWeight: FontWeight.w600, color: AppColors.white),
    bodyLarge:   base.bodyLarge  ?.copyWith(
        fontFamily: 'EuclidCircularA', color: AppColors.white),
    bodyMedium:  base.bodyMedium ?.copyWith(
        fontFamily: 'EuclidCircularA', color: AppColors.white.withOpacity(.85)),
    labelLarge:  base.labelLarge ?.copyWith(
        fontFamily: 'EuclidCircularA', fontWeight: FontWeight.w700, color: AppColors.white),
  );

  /* -------------------------- THEME ------------------------------------ */
  static ThemeData get darkTheme {
    final base = ThemeData.dark();

    return base.copyWith(
      scaffoldBackgroundColor: AppColors.primaryBlack,
      primaryColor: AppColors.primaryRed,
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
      textTheme: _euclid(base.textTheme),

      /* AppBar ----------------------------------------------------------- */
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.darkGrey,
        elevation: 0,
        iconTheme: IconThemeData(color: AppColors.white),
        titleTextStyle: TextStyle(
          fontFamily: 'EuclidCircularA',
          fontWeight: FontWeight.w700,
          fontSize: 20,
          color: AppColors.white,
        ),
      ),

      /* Inputs ----------------------------------------------------------- */
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.inputBackground,
        hintStyle: const TextStyle(
            fontFamily: 'EuclidCircularA',
            color: AppColors.hintColor,
            fontWeight: FontWeight.w400),
        labelStyle: const TextStyle(fontFamily: 'EuclidCircularA', color: AppColors.white),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(width: 1.4, color: AppColors.primaryRed),
        ),
        prefixIconColor: AppColors.hintColor,
        suffixIconColor: AppColors.hintColor,
      ),

      /* Buttons ---------------------------------------------------------- */
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primaryRed,
          foregroundColor: AppColors.white,
          minimumSize: const Size.fromHeight(48),
          padding: const EdgeInsets.symmetric(vertical: 14),
          textStyle: const TextStyle(
            fontFamily: 'EuclidCircularA',
            fontWeight: FontWeight.w600,
            fontSize: 16,
          ),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      ),

      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.lightGrey,
          textStyle: const TextStyle(
            fontFamily: 'EuclidCircularA',
            fontWeight: FontWeight.w500,
          ),
        ),
      ),

      /* Bottom-nav ------------------------------------------------------- */
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: AppColors.primaryBlack,
        selectedItemColor: AppColors.primaryRed,
        unselectedItemColor: AppColors.lightGrey,
        type: BottomNavigationBarType.fixed,
        showSelectedLabels: true,
        showUnselectedLabels: true,
      ),
    );
  }
}
