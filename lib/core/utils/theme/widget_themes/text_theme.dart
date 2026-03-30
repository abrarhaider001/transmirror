import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../constants/colors.dart';

/// Text styles derived from [ColorScheme] so light/dark mode and [ThemeMode] stay in sync.
///
/// Prefer `Theme.of(context).textTheme` in widgets instead of [lightTextTheme] / [darkTextTheme].
class MyTextTheme {
  MyTextTheme._();

  static final String? _font = GoogleFonts.poppins().fontFamily;

  /// Light: white scaffold, black text, grey secondary — reference (ChatGPT light).
  static final ColorScheme lightColorScheme = ColorScheme.light(
    primary: MyColors.primary,
    onPrimary: MyColors.white,
    secondary: MyColors.secondary,
    onSecondary: MyColors.white,
    tertiary: MyColors.tertiary,
    onTertiary: MyColors.white,
    surface: MyColors.scaffoldLight,
    onSurface: MyColors.textPrimary,
    onSurfaceVariant: MyColors.textMutedLight,
    error: MyColors.error,
    outline: MyColors.borderLight,
  ).copyWith(
    surfaceContainerHighest: MyColors.surfaceGroupedLight,
  );

  /// Dark: black scaffold, white text, grey surfaces — reference (ChatGPT dark).
  static final ColorScheme darkColorScheme = ColorScheme.dark(
    primary: MyColors.secondary,
    onPrimary: MyColors.white,
    secondary: MyColors.secondary,
    onSecondary: MyColors.white,
    surface: MyColors.scaffoldDark,
    onSurface: MyColors.darkOnSurface,
    onSurfaceVariant: MyColors.textMutedDark,
    error: MyColors.error,
    outline: MyColors.borderDark,
  ).copyWith(
    surfaceContainerHighest: MyColors.surfaceElevatedDark,
  );

  /// Builds a [TextTheme] whose colors come from [scheme] (primary vs muted vs links).
  static TextTheme fromColorScheme(ColorScheme scheme) {
    final onSurface = scheme.onSurface;
    final muted = scheme.onSurfaceVariant;
    final link = scheme.brightness == Brightness.dark
        ? scheme.onSurface
        : MyColors.primary;

    TextStyle base({
      required double fontSize,
      FontWeight? weight,
      Color? color,
      double? height,
    }) {
      return TextStyle(
        fontFamily: _font,
        fontSize: fontSize,
        fontWeight: weight,
        color: color,
        height: height,
      );
    }

    return TextTheme(
      displayLarge: base(
        fontSize: 28,
        weight: FontWeight.bold,
        color: onSurface,
      ),
      displayMedium: base(
        fontSize: 24,
        weight: FontWeight.bold,
        color: onSurface,
      ),
      displaySmall: base(
        fontSize: 24,
        weight: FontWeight.normal,
        color: onSurface,
      ),
      headlineLarge: base(
        fontSize: 22,
        weight: FontWeight.w600,
        color: onSurface,
      ),
      headlineMedium: base(
        fontSize: 18,
        weight: FontWeight.w600,
        color: onSurface,
      ),
      headlineSmall: base(
        fontSize: 18,
        weight: FontWeight.normal,
        color: onSurface,
      ),
      titleLarge: base(fontSize: 14, weight: FontWeight.w600, color: onSurface),
      titleMedium: base(
        fontSize: 14,
        weight: FontWeight.w500,
        color: onSurface,
      ),
      titleSmall: base(fontSize: 12, weight: FontWeight.w600, color: muted),
      bodyLarge: base(fontSize: 14, color: onSurface),
      bodyMedium: base(fontSize: 14, color: muted),
      bodySmall: base(fontSize: 12, color: muted.withValues(alpha: 0.95)),
      labelLarge: base(fontSize: 14, weight: FontWeight.w600, color: link),
      labelMedium: base(fontSize: 12, weight: FontWeight.w500, color: muted),
      labelSmall: base(fontSize: 11, color: muted),
    );
  }

  /// Legacy: light palette. Prefer `Theme.of(context).textTheme`.
  static final TextTheme lightTextTheme = fromColorScheme(lightColorScheme);

  /// Legacy: dark palette. Prefer `Theme.of(context).textTheme`.
  static final TextTheme darkTextTheme = fromColorScheme(darkColorScheme);
}
