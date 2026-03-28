import 'package:flutter/material.dart';

/// Central palette + semantic tokens for light/dark UI (reference: premium dark purple + clean light surfaces).
class MyColors {
  MyColors._();

  // — Brand (shared) —
  static const Color primary = Color(0xFF313647);
  static const Color secondary = Color(0xFF435663);
  static const Color tertiary = Color(0xFFA3B087);
  static const Color secondaryLight = Color(0xFF334155);

  // — Light mode surfaces —
  static const Color primaryBackground = Colors.white;
  static const Color secondaryBackground = Color(0xFFF1F5F9);
  static const Color lightBackground = primaryBackground;

  // — Light text —
  static const Color textPrimary = Color(0xFF0F172A);
  static const Color textSecondary = Color(0xFF6B7280);
  static const Color textTertiary = Color(0xFF9CA3AF);

  // — Dark mode (app-wide) —
  static const Color darkBackground = Color(0xFF050508);
  static const Color darkSurface = Color(0xFF12121A);
  static const Color darkSurfaceVariant = Color(0xFF1A1A24);
  static const Color darkOnBackground = Color(0xFFFFFFFF);
  static const Color darkOnSurface = Color(0xFFE2E8F0);
  static const Color darkOnSurfaceMuted = Color(0xFFA0A0A0);
  static const Color darkOutline = Color(0xFF333333);
  static const Color darkFieldFill = Color(0x14FFFFFF);

  /// Violet accent for links & focus on dark / auth (reference UI).
  static const Color darkLink = Color(0xFF9D8AF2);

  /// Blue for inline actions on light backgrounds (links, info).
  static const Color lightLink = Color(0xFF2563EB);

  // — Auth gradient (login / register / forgot) —
  static const Color authGradientStart = Color(0xFF3E1F7A);
  static const Color authGradientMid = Color(0xFF050508);
  static const Color authGradientEnd = Color(0xFF3E1F7A);

  static const LinearGradient authBackgroundGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      authGradientStart,
      authGradientMid,
      authGradientEnd,
    ],
    stops: [0.0, 0.48, 1.0],
  );

  // — Auth social pills —
  static const Color authPillLightBg = white;
  static const Color authPillLightFg = black;

  // — Containers (legacy names) —
  static const Color lightContainer = tertiary;
  static const Color darkContainer = Colors.black;

  // — Buttons (light) —
  static const Color buttonPrimary = primary;
  static const Color buttonSecondary = tertiary;

  // — Icons (light) —
  static const Color iconPrimaryLight = textSecondary;
  static const Color iconSecondaryLight = primary;

  // — Status —
  static const Color error = red;
  static const Color success = Color(0xFF22C55E);
  static const Color warning = Color(0xFFF57C00);
  static const Color info = Color(0xFF2563EB);

  // — Neutrals —
  static const Color black = Colors.black;
  static const Color dark = Color(0xff272727);
  static const Color darkerGrey = Color(0xFF4F4F4F);
  static const Color darkGrey = Color(0xFF939393);
  static const Color grey = Color(0xFFE0E0E0);
  static const Color grey10 = Color(0xFFF3F4F6);
  static const Color softGrey = Color(0xFFF4F4F4);
  static const Color lightGrey = Color(0xFFF9F9F9);
  static const Color white = Color(0xFFFFFFFF);
  static const Color red = Color(0xfff43F5E);
}
