import 'package:flutter/material.dart';

import '../../constants/colors.dart';
import '../../constants/sizes.dart';

class MyOutlinedButtonTheme {
  MyOutlinedButtonTheme._();

  static final lightOutlinedButtonTheme = OutlinedButtonThemeData(
    style: OutlinedButton.styleFrom(
      foregroundColor: MyColors.textPrimary,
      side: const BorderSide(color: MyColors.grey10),
      padding: const EdgeInsets.symmetric(vertical: MySizes.buttonHeight),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(MySizes.borderRadiusLg),
      ),
    ),
  );

  static final darkOutlinedButtonTheme = OutlinedButtonThemeData(
    style: OutlinedButton.styleFrom(
      foregroundColor: MyColors.darkOnSurface,
      side: const BorderSide(color: MyColors.darkOutline),
      padding: const EdgeInsets.symmetric(vertical: MySizes.buttonHeight),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(MySizes.borderRadiusLg),
      ),
    ),
  );
}
