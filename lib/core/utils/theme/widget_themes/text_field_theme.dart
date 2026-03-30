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

  /// Light: white pill, hairline grey border, black focus — reference ChatGPT input.
  static InputDecorationTheme lightInputDecorationTheme = InputDecorationTheme(
    filled: true,
    fillColor: MyColors.white,
    prefixIconColor: MyColors.textTertiary,
    suffixIconColor: MyColors.textTertiary,
    floatingLabelStyle: const TextStyle(color: MyColors.textPrimary),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(MySizes.inputFieldRadius),
      borderSide: const BorderSide(width: 1, color: MyColors.borderLight),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(MySizes.inputFieldRadius),
      borderSide: const BorderSide(width: 1, color: MyColors.borderLight),
    ),
    disabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(MySizes.inputFieldRadius),
      borderSide: const BorderSide(width: 1, color: MyColors.borderLight),
    ),
    hintStyle: const TextStyle(color: MyColors.textMutedLight),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(MySizes.inputFieldRadius),
      borderSide: const BorderSide(width: 1.5, color: MyColors.textPrimary),
    ),
  );

  /// Dark: charcoal field on black, light grey border — reference ChatGPT dark input.
  static InputDecorationTheme darkInputDecorationTheme = InputDecorationTheme(
    prefixIconColor: MyColors.textMutedDark,
    floatingLabelStyle: const TextStyle(color: MyColors.darkOnSurface),
    fillColor: MyColors.darkFieldFill,
    filled: true,
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(MySizes.inputFieldRadius),
      borderSide: const BorderSide(width: 1, color: MyColors.borderDark),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(MySizes.inputFieldRadius),
      borderSide: const BorderSide(width: 1, color: MyColors.borderDark),
    ),
    disabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(MySizes.inputFieldRadius),
      borderSide: const BorderSide(width: 1, color: MyColors.borderDark),
    ),
    hintStyle: const TextStyle(color: MyColors.textMutedDark),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(MySizes.inputFieldRadius),
      borderSide: const BorderSide(width: 1.5, color: MyColors.white),
    ),
  );

  /// Compact fields for auth flows — uses [Theme.of] input decoration + neutral icons.
  static InputDecoration compactInputDecoration(
    BuildContext context, {
    String? hintText,
    Widget? prefixIcon,
    Widget? suffixIcon,
  }) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    return InputDecoration(
      isDense: true,
      contentPadding: authContentPadding,
      hintText: hintText,
      prefixIcon: prefixIcon,
      suffixIcon: suffixIcon,
      prefixIconColor: cs.onSurfaceVariant,
      suffixIconColor: cs.onSurfaceVariant,
    ).applyDefaults(theme.inputDecorationTheme);
  }

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
}
