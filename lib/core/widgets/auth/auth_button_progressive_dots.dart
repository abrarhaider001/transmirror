import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

/// [LoadingAnimationWidget.progressiveDots] for auth primary buttons.
class AuthButtonProgressiveDots extends StatelessWidget {
  const AuthButtonProgressiveDots({
    super.key,
    this.color = Colors.white,
    this.size = 24,
  });

  final Color color;
  final double size;

  @override
  Widget build(BuildContext context) {
    return LoadingAnimationWidget.progressiveDots(
      color: color,
      size: size,
    );
  }
}
