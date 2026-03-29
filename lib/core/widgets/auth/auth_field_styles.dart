import 'package:flutter/material.dart';
import 'package:transmirror/core/utils/constants/colors.dart';

/// Shared label styling for dark auth screens (login / register / forgot password).
class AuthFieldStyles {
  AuthFieldStyles._();

  static TextStyle labelDark(BuildContext context) {
    return Theme.of(context).textTheme.titleSmall?.copyWith(
          color: MyColors.authPillLightBg,
          fontWeight: FontWeight.w500,
        ) ??
        const TextStyle(
          color: MyColors.authPillLightBg,
          fontWeight: FontWeight.w500,
        );
  }
}
