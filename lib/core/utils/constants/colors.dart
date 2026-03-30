import 'package:flutter/material.dart';

/// Central palette + semantic tokens for light/dark UI.
///
/// **UI structure** (scaffold, surfaces, borders, typography) uses only black,
/// white, and greys — matching reference (ChatGPT / iOS-style).
/// Brand [primary] / [secondary] are used for actions (buttons, key accents).
class MyColors {
  MyColors._();

  // — Brand (actions / key accents only) —
  static const Color primary = Color(0xFF081C15);
  static const Color secondary = Color(0xFF2D6A4F);
  static const Color tertiary = Color(0xFF40916C);
  static const Color secondaryLight = Color(0xFF1B4332);

  // — Light: structural (white / light grey) —
  static const Color scaffoldLight = Color(0xFFFFFFFF);
  /// Grouped list / card tiles (settings-style).
  static const Color surfaceGroupedLight = Color(0xFFF2F2F7);
  static const Color borderLight = Color(0xFFE5E5E5);
  static const Color dividerLight = Color(0xFFC6C6C8);
  /// Secondary labels, hints, tile subtitles (ChatGPT mid grey).
  static const Color textMutedLight = Color(0xFF8E8E93);

  static const Color primaryBackground = scaffoldLight;
  static const Color secondaryBackground = surfaceGroupedLight;
  static const Color lightBackground = scaffoldLight;

  // — Light text —
  static const Color textPrimary = Color(0xFF000000);
  static const Color textSecondary = Color(0xFF8E8E93);
  static const Color textTertiary = Color(0xFF6C6C70);

  /// Field outline on white (thin light grey).
  static const Color authOutline = borderLight;

  // — Dark: structural (black / grey) —
  static const Color scaffoldDark = Color(0xFF000000);
  /// Inputs, nav chrome, grouped tiles.
  static const Color surfaceElevatedDark = Color(0xFF2C2C2E);
  static const Color borderDark = Color(0xFF3A3A3C);
  static const Color dividerDark = Color(0xFF1C1C1E);
  static const Color textMutedDark = Color(0xFF98989D);

  static const Color darkBackground = scaffoldDark;
  static const Color darkSurface = surfaceElevatedDark;
  static const Color darkSurfaceVariant = Color(0xFF3A3A3C);
  static const Color darkOnBackground = Color(0xFFFFFFFF);
  static const Color darkOnSurface = Color(0xFFFFFFFF);
  static const Color darkOnSurfaceMuted = textMutedDark;
  static const Color darkOutline = borderDark;
  /// Solid field fill (ChatGPT input bar).
  static const Color darkFieldFill = surfaceElevatedDark;

  /// Deprecated: prefer [primary] on buttons; kept for legacy dark widgets.
  static const Color darkLink = Color(0xFF9D8AF2);

  static const Color lightLink = secondary;

  static const Color lightContainer = tertiary;
  static const Color darkContainer = Colors.black;

  static const Color buttonPrimary = primary;
  static const Color buttonSecondary = tertiary;

  static const Color iconPrimaryLight = textSecondary;
  static const Color iconSecondaryLight = primary;

  static const Color error = red;
  static const Color success = Color(0xFF22C55E);
  static const Color warning = Color(0xFFF57C00);
  static const Color info = Color(0xFF2563EB);

  static const Color black = Colors.black;
  static const Color dark = Color(0xff272727);
  static const Color darkerGrey = Color(0xFF4F4F4F);
  static const Color darkGrey = Color(0xFF939393);
  static const Color grey = Color(0xFFE0E0E0);
  static const Color grey10 = surfaceGroupedLight;
  static const Color softGrey = Color(0xFFF4F4F4);
  static const Color lightGrey = Color(0xFFF9F9F9);
  static const Color white = Color(0xFFFFFFFF);
  static const Color red = Color(0xfff43F5E);
}
