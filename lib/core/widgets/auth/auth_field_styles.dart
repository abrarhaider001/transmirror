import 'package:flutter/material.dart';

/// Field labels on auth screens — follows [ThemeData.textTheme] / [ColorScheme].
class AuthFieldStyles {
  AuthFieldStyles._();

  static TextStyle labelAuth(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Theme.of(context).textTheme.titleMedium?.copyWith(
          color: cs.onSurface,
          fontWeight: FontWeight.w500,
        ) ??
        TextStyle(
          color: cs.onSurface,
          fontWeight: FontWeight.w500,
        );
  }
}
