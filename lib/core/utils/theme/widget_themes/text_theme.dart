import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../constants/colors.dart';

class MyTextTheme {
  MyTextTheme._();

  static final String? _font = GoogleFonts.poppins().fontFamily;

  static TextTheme lightTextTheme = TextTheme(
    displayLarge: TextStyle(
      fontSize: 28.0,
      fontWeight: FontWeight.bold,
      fontFamily: _font,
      color: MyColors.textPrimary,
    ),
    displayMedium: TextStyle(
      fontSize: 24.0,
      fontWeight: FontWeight.bold,
      color: MyColors.textPrimary,
      fontFamily: _font,
    ),
    displaySmall: TextStyle(
      fontSize: 24.0,
      fontWeight: FontWeight.normal,
      color: MyColors.textPrimary,
      fontFamily: _font,
    ),
    headlineMedium: TextStyle(
      fontSize: 18.0,
      fontWeight: FontWeight.w600,
      color: MyColors.textPrimary,
      fontFamily: _font,
    ),
    headlineSmall: TextStyle(
      fontSize: 18.0,
      fontWeight: FontWeight.normal,
      color: MyColors.textPrimary,
      fontFamily: _font,
    ),
    titleLarge: TextStyle(
      fontSize: 14.0,
      fontWeight: FontWeight.w600,
      color: MyColors.textPrimary,
      fontFamily: _font,
    ),
    bodyLarge: TextStyle(
      fontSize: 14.0,
      color: MyColors.textPrimary,
      fontFamily: _font,
    ),
    bodyMedium: TextStyle(
      fontSize: 14.0,
      color: MyColors.textSecondary,
      fontFamily: _font,
    ),
    bodySmall: TextStyle(
      fontSize: 12.0,
      color: MyColors.textSecondary.withOpacity(0.85),
      fontFamily: _font,
    ),
    labelLarge: TextStyle(
      fontSize: 14.0,
      fontWeight: FontWeight.w600,
      color: MyColors.lightLink,
      fontFamily: _font,
    ),
  );

  static TextTheme darkTextTheme = TextTheme(
    displayLarge: TextStyle(
      fontSize: 28.0,
      fontWeight: FontWeight.bold,
      fontFamily: _font,
      color: MyColors.darkOnBackground,
    ),
    displayMedium: TextStyle(
      fontSize: 24.0,
      fontWeight: FontWeight.bold,
      color: MyColors.darkOnBackground,
      fontFamily: _font,
    ),
    displaySmall: TextStyle(
      fontSize: 24.0,
      fontWeight: FontWeight.normal,
      color: MyColors.darkOnBackground,
      fontFamily: _font,
    ),
    headlineMedium: TextStyle(
      fontSize: 18.0,
      fontWeight: FontWeight.w600,
      color: MyColors.darkOnBackground,
      fontFamily: _font,
    ),
    headlineSmall: TextStyle(
      fontSize: 18.0,
      fontWeight: FontWeight.normal,
      color: MyColors.darkOnSurface,
      fontFamily: _font,
    ),
    titleLarge: TextStyle(
      fontSize: 14.0,
      fontWeight: FontWeight.w600,
      color: MyColors.darkOnBackground,
      fontFamily: _font,
    ),
    bodyLarge: TextStyle(
      fontSize: 14.0,
      color: MyColors.darkOnSurface,
      fontFamily: _font,
    ),
    bodyMedium: TextStyle(
      fontSize: 14.0,
      color: MyColors.darkOnSurfaceMuted,
      fontFamily: _font,
    ),
    bodySmall: TextStyle(
      fontSize: 12.0,
      color: MyColors.darkOnSurfaceMuted.withOpacity(0.9),
      fontFamily: _font,
    ),
    labelLarge: TextStyle(
      fontSize: 14.0,
      fontWeight: FontWeight.w600,
      color: MyColors.darkLink,
      fontFamily: _font,
    ),
  );
}
