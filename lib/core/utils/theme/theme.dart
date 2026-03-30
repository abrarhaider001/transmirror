import 'package:flutter/material.dart';
import 'package:transmirror/core/utils/constants/colors.dart';

import 'widget_themes/appbar_theme.dart';
import 'widget_themes/elevated_button_theme.dart';
import 'widget_themes/outlined_button_theme.dart';
import 'widget_themes/text_field_theme.dart';
import 'widget_themes/text_theme.dart';
import '../constants/sizes.dart';

/// Application themes — all component styles live under [lib/core/utils/theme].
class MyAppTheme {
  MyAppTheme._();

  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    scaffoldBackgroundColor: MyColors.scaffoldLight,
    colorScheme: MyTextTheme.lightColorScheme,
    textTheme: MyTextTheme.fromColorScheme(MyTextTheme.lightColorScheme),
    appBarTheme: MyAppBarTheme.lightAppBarTheme,
    elevatedButtonTheme: MyElevatedButtonTheme.lightElevatedButtonTheme,
    outlinedButtonTheme: MyOutlinedButtonTheme.lightOutlinedButtonTheme,
    inputDecorationTheme: MyTextFormFieldTheme.lightInputDecorationTheme,
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: MyColors.scaffoldLight,
      selectedItemColor: MyColors.textPrimary,
      unselectedItemColor: MyColors.textMutedLight,
      elevation: 0,
      type: BottomNavigationBarType.fixed,
    ),
    dividerTheme: const DividerThemeData(
      color: MyColors.dividerLight,
      thickness: 1,
    ),
    cardTheme: CardThemeData(
      color: MyColors.surfaceGroupedLight,
      elevation: 0,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(MySizes.cardRadiusLg),
      ),
    ),
  );

  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    scaffoldBackgroundColor: MyColors.scaffoldDark,
    colorScheme: MyTextTheme.darkColorScheme,
    textTheme: MyTextTheme.fromColorScheme(MyTextTheme.darkColorScheme),
    appBarTheme: MyAppBarTheme.darkAppBarTheme,
    elevatedButtonTheme: MyElevatedButtonTheme.darkElevatedButtonTheme,
    outlinedButtonTheme: MyOutlinedButtonTheme.darkOutlinedButtonTheme,
    inputDecorationTheme: MyTextFormFieldTheme.darkInputDecorationTheme,
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: MyColors.scaffoldDark,
      selectedItemColor: MyColors.white,
      unselectedItemColor: MyColors.textMutedDark,
      elevation: 0,
      type: BottomNavigationBarType.fixed,
    ),
    dividerTheme: const DividerThemeData(
      color: MyColors.dividerDark,
      thickness: 1,
    ),
    cardTheme: CardThemeData(
      color: MyColors.surfaceElevatedDark,
      elevation: 0,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(MySizes.cardRadiusLg),
      ),
    ),
  );
}
