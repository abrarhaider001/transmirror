import 'package:flutter/material.dart';

import '../../constants/colors.dart';
import '../../constants/sizes.dart';

class MyOutlinedButtonTheme {
  MyOutlinedButtonTheme._();

  static final lightOutlinedButtonTheme = OutlinedButtonThemeData(
    style: OutlinedButton.styleFrom(
      foregroundColor: MyColors.textPrimary,
      side: const BorderSide(color: MyColors.borderLight),
      padding: const EdgeInsets.symmetric(vertical: MySizes.buttonHeight),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(MySizes.borderRadiusLg),
      ),
    ),
  );

  static final darkOutlinedButtonTheme = OutlinedButtonThemeData(
    style: OutlinedButton.styleFrom(
      foregroundColor: MyColors.white,
      side: const BorderSide(color: MyColors.borderDark),
      padding: const EdgeInsets.symmetric(vertical: MySizes.buttonHeight),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(MySizes.borderRadiusLg),
      ),
    ),
  );
}
