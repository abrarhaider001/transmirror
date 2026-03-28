import 'dart:math' as math;

import 'package:flutter/material.dart';

/// Shared responsive constraints for the account / profile screen.
class ProfileLayout {
  ProfileLayout._();

  static const double maxContentWidth = 560;

  static double horizontalPadding(BuildContext context) {
    final w = MediaQuery.sizeOf(context).width;
    if (w >= 900) return 32;
    if (w >= 600) return 24;
    return 16;
  }

  static EdgeInsets pagePadding(BuildContext context) {
    return EdgeInsets.symmetric(horizontal: horizontalPadding(context));
  }

  static double contentWidth(BuildContext context) {
    final w = MediaQuery.sizeOf(context).width;
    return math.min(w, maxContentWidth);
  }

  static double avatarRadius(BuildContext context) {
    final w = MediaQuery.sizeOf(context).width;
    if (w >= 600) return 40;
    return 34;
  }
}
