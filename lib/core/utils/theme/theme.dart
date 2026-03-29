import 'package:flutter/material.dart';
import 'package:transmirror/core/utils/constants/colors.dart';

import 'widget_themes/appbar_theme.dart';
import 'widget_themes/elevated_button_theme.dart';
import 'widget_themes/outlined_button_theme.dart';
import 'widget_themes/text_field_theme.dart';
import 'widget_themes/text_theme.dart';

/// Application themes — all component styles live under [lib/core/utils/theme].
class MyAppTheme {
  MyAppTheme._();

  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    scaffoldBackgroundColor: MyColors.primaryBackground,
    colorScheme: MyTextTheme.lightColorScheme,
    textTheme: MyTextTheme.fromColorScheme(MyTextTheme.lightColorScheme),
    appBarTheme: MyAppBarTheme.lightAppBarTheme,
    elevatedButtonTheme: MyElevatedButtonTheme.lightElevatedButtonTheme,
    outlinedButtonTheme: MyOutlinedButtonTheme.lightOutlinedButtonTheme,
    inputDecorationTheme: MyTextFormFieldTheme.lightInputDecorationTheme,
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: MyColors.primary,
      selectedItemColor: MyColors.white,
      unselectedItemColor: Color(0xFFCBD5E1),
      elevation: 8,
      type: BottomNavigationBarType.fixed,
    ),
    dividerTheme: const DividerThemeData(color: MyColors.grey10),
    cardTheme: CardThemeData(
      color: MyColors.white,
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    ),
  );

  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    scaffoldBackgroundColor: MyColors.darkBackground,
    colorScheme: MyTextTheme.darkColorScheme,
    textTheme: MyTextTheme.fromColorScheme(MyTextTheme.darkColorScheme),
    appBarTheme: MyAppBarTheme.darkAppBarTheme,
    elevatedButtonTheme: MyElevatedButtonTheme.darkElevatedButtonTheme,
    outlinedButtonTheme: MyOutlinedButtonTheme.darkOutlinedButtonTheme,
    inputDecorationTheme: MyTextFormFieldTheme.darkInputDecorationTheme,
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: MyColors.darkSurface,
      selectedItemColor: MyColors.darkLink,
      unselectedItemColor: MyColors.darkOnSurfaceMuted,
      elevation: 8,
      type: BottomNavigationBarType.fixed,
    ),
    dividerTheme: const DividerThemeData(color: MyColors.darkOutline),
    cardTheme: CardThemeData(
      color: MyColors.darkSurfaceVariant,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(color: MyColors.darkOutline),
      ),
    ),
  );
}
