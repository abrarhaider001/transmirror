import 'package:flutter/material.dart';
import 'package:transmirror/core/utils/constants/colors.dart';

/// Full-screen auth background only — do not use on non-auth routes.
class AuthGradientBackground extends StatelessWidget {
  const AuthGradientBackground({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: DecoratedBox(
        decoration: const BoxDecoration(
          gradient: MyColors.authBackgroundGradient,
        ),
        child: child,
      ),
    );
  }
}
