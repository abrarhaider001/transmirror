import 'package:flutter/material.dart';
import 'package:transmirror/core/utils/constants/colors.dart';
import '../../constants/sizes.dart';

class MyTextFormFieldTheme {
  MyTextFormFieldTheme._();

  /// Tighter fields on login / register / forgot-password.
  static const EdgeInsets authContentPadding = EdgeInsets.symmetric(
    horizontal: 14,
    vertical: 10,
  );

  static InputDecorationTheme lightInputDecorationTheme = InputDecorationTheme(
    prefixIconColor: MyColors.textSecondary,
    floatingLabelStyle: const TextStyle(color: MyColors.primary),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(MySizes.borderRadiusMd),
      borderSide: const BorderSide(width: 1, color: MyColors.grey10),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(MySizes.borderRadiusMd),
      borderSide: const BorderSide(width: 1, color: MyColors.grey10),
    ),
    disabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(MySizes.borderRadiusMd),
      borderSide: const BorderSide(width: 1, color: MyColors.grey10),
    ),
    hintStyle: TextStyle(color: MyColors.grey.withOpacity(0.5)),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(MySizes.borderRadiusMd),
      borderSide: const BorderSide(width: 2, color: MyColors.primary),
    ),
  );

  static InputDecorationTheme darkInputDecorationTheme = InputDecorationTheme(
    prefixIconColor: MyColors.darkOnSurfaceMuted,
    floatingLabelStyle: const TextStyle(color: MyColors.darkLink),
    fillColor: MyColors.darkFieldFill,
    filled: true,
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(MySizes.borderRadiusMd),
      borderSide: const BorderSide(width: 1, color: MyColors.darkOutline),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(MySizes.borderRadiusMd),
      borderSide: const BorderSide(width: 1, color: MyColors.darkOutline),
    ),
    disabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(MySizes.borderRadiusMd),
      borderSide: const BorderSide(width: 1, color: MyColors.darkOutline),
    ),
    hintStyle: TextStyle(color: MyColors.darkOnSurfaceMuted.withOpacity(0.85)),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(MySizes.borderRadiusMd),
      borderSide: const BorderSide(width: 2, color: MyColors.darkLink),
    ),
  );

  static InputDecoration lightInputDecoration({
    String? labelText,
    String? hintText,
    Widget? prefixIcon,
    Widget? suffixIcon,
  }) {
    return InputDecoration(
      isDense: true,
      contentPadding: authContentPadding,
      labelText: labelText,
      hintText: hintText,
      prefixIcon: prefixIcon,
      suffixIcon: suffixIcon,
      prefixIconColor: Colors.grey,
      suffixIconColor: Colors.grey,
      floatingLabelStyle: const TextStyle(color: Colors.grey),
      labelStyle: const TextStyle(color: Colors.grey),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(MySizes.borderRadiusMd),
        borderSide: const BorderSide(width: 1, color: MyColors.primary),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(MySizes.borderRadiusMd),
        borderSide: const BorderSide(width: 1, color: MyColors.primary),
      ),
      disabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(MySizes.borderRadiusMd),
        borderSide: const BorderSide(width: 1, color: MyColors.primary),
      ),
      hintStyle: const TextStyle(color: Colors.grey),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(MySizes.borderRadiusMd),
        borderSide: const BorderSide(width: 2, color: MyColors.primary),
      ),
    );
  }

  /// Dark fields on auth screens ([MyColors] tokens; same palette as [MyAppTheme.darkTheme]).
  static InputDecoration authDarkInputDecoration({
    String? hintText,
    Widget? prefixIcon,
    Widget? suffixIcon,
  }) {
    final r = BorderRadius.circular(MySizes.borderRadiusMd);
    return InputDecoration(
      isDense: true,
      contentPadding: authContentPadding,
      hintText: hintText,
      prefixIcon: prefixIcon,
      suffixIcon: suffixIcon,
      prefixIconColor: Colors.white70,
      suffixIconColor: Colors.white70,
      filled: true,
      fillColor: MyColors.darkFieldFill,
      hintStyle: TextStyle(color: MyColors.darkOnSurfaceMuted.withOpacity(0.9)),
      border: OutlineInputBorder(
        borderRadius: r,
        borderSide: const BorderSide(color: MyColors.darkOutline),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: r,
        borderSide: const BorderSide(color: MyColors.darkOutline),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: r,
        borderSide: const BorderSide(color: MyColors.darkLink, width: 2),
      ),
    );
  }
}
