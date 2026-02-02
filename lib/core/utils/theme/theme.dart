import 'package:flutter/material.dart';
import 'package:transmirror/core/utils/constants/colors.dart';

import 'widget_themes/appbar_theme.dart';
import 'widget_themes/elevated_button_theme.dart';
import 'widget_themes/outlined_button_theme.dart';
import 'widget_themes/text_field_theme.dart';
import 'widget_themes/text_theme.dart';

class MyAppTheme {
  MyAppTheme._();

  static ThemeData lightTheme = ThemeData(
    scaffoldBackgroundColor: MyColors.primaryBackground,
    brightness: Brightness.light,
    colorScheme: const ColorScheme.light(
      primary: MyColors.primary,
      secondary: MyColors.secondary,
      surface: MyColors.white,
      background: MyColors.primaryBackground,
      error: MyColors.error,
    ),
    textTheme: MyTextTheme.lightTextTheme,
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
  );
}
