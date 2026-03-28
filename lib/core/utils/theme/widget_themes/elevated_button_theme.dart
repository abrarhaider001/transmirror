import 'package:flutter/material.dart';

import '../../constants/colors.dart';
import '../../constants/sizes.dart';

class MyElevatedButtonTheme {
  MyElevatedButtonTheme._();

  static final lightElevatedButtonTheme = ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      elevation: 8,
      shadowColor: MyColors.primary.withOpacity(0.35),
      foregroundColor: MyColors.white,
      backgroundColor: MyColors.buttonPrimary,
      side: BorderSide(color: MyColors.primary.withOpacity(0.0)),
      padding: const EdgeInsets.symmetric(vertical: MySizes.buttonHeight),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(MySizes.borderRadiusLg),
      ),
    ),
  );

  static final darkElevatedButtonTheme = ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      elevation: 4,
      shadowColor: Colors.black54,
      foregroundColor: MyColors.white,
      backgroundColor: MyColors.darkLink,
      padding: const EdgeInsets.symmetric(vertical: MySizes.buttonHeight),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(MySizes.borderRadiusLg),
      ),
    ),
  );
}
