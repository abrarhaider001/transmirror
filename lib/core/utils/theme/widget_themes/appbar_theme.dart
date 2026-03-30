import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../constants/colors.dart';

class MyAppBarTheme {
  MyAppBarTheme._();

  static const lightAppBarTheme = AppBarTheme(
    elevation: 0,
    scrolledUnderElevation: 0,
    centerTitle: true,
    backgroundColor: MyColors.scaffoldLight,
    surfaceTintColor: Colors.transparent,
    foregroundColor: MyColors.textPrimary,
    iconTheme: IconThemeData(color: MyColors.textPrimary, size: 18.0),
    actionsIconTheme: IconThemeData(color: MyColors.textPrimary, size: 18.0),
    systemOverlayStyle: SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      statusBarBrightness: Brightness.light,
    ),
  );

  static const darkAppBarTheme = AppBarTheme(
    elevation: 0,
    scrolledUnderElevation: 0,
    centerTitle: true,
    backgroundColor: MyColors.scaffoldDark,
    surfaceTintColor: Colors.transparent,
    foregroundColor: MyColors.white,
    iconTheme: IconThemeData(color: MyColors.white, size: 18.0),
    actionsIconTheme: IconThemeData(color: MyColors.white, size: 18.0),
    systemOverlayStyle: SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      statusBarBrightness: Brightness.dark,
    ),
  );
}
