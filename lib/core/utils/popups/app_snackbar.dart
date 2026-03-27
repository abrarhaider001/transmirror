import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:transmirror/core/utils/constants/colors.dart';

/// Project-wide floating snackbars: message only (no title), bottom, 2.5s default.
/// New snackbars replace any visible one via [ScaffoldMessenger.clearSnackBars].
class AppSnackBar {
  AppSnackBar._();

  static const Duration defaultDuration = Duration(milliseconds: 2500);

  static void show(
    String message, {
    BuildContext? context,
    Color? backgroundColor,
    Color? textColor,
    Duration? duration,
  }) {
    final ctx = context ?? Get.context ?? Get.overlayContext;
    if (ctx == null) return;

    final theme = Theme.of(ctx);
    final bg = backgroundColor ?? theme.colorScheme.inverseSurface;
    final fg = textColor ?? _onBackground(bg, theme);

    final messenger = ScaffoldMessenger.of(ctx);
    messenger.clearSnackBars();
    messenger.showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: fg,
            fontWeight: FontWeight.w500,
          ),
        ),
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.fromLTRB(16, 0, 16, 24),
        duration: duration ?? defaultDuration,
        backgroundColor: bg,
        elevation: 8,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        dismissDirection: DismissDirection.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
      ),
    );
  }

  static Color _onBackground(Color background, ThemeData theme) {
    final luminance = background.computeLuminance();
    if (luminance > 0.55) {
      return MyColors.textPrimary;
    }
    return Colors.white;
  }

  static void success(String message, {BuildContext? context}) {
    show(
      message,
      context: context,
      backgroundColor: MyColors.success.withOpacity(0.92),
      textColor: Colors.white,
    );
  }

  static void error(String message, {BuildContext? context}) {
    show(
      message,
      context: context,
      backgroundColor: MyColors.error.withOpacity(0.92),
      textColor: Colors.white,
    );
  }

  static void warning(String message, {BuildContext? context}) {
    show(
      message,
      context: context,
      backgroundColor: MyColors.warning.withOpacity(0.95),
      textColor: Colors.white,
    );
  }

  static void info(String message, {BuildContext? context}) {
    show(message, context: context);
  }
}
