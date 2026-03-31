import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

/// Circular icon control matching register / sign-in (outline + soft fill on [surface]).
class AuthCircularIconButton extends StatelessWidget {
  const AuthCircularIconButton({
    super.key,
    required this.icon,
    this.onPressed,
    this.size = 44,
    this.iconSize = 22,
  });

  final IconData icon;
  final VoidCallback? onPressed;
  final double size;
  final double iconSize;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(size / 2),
        onTap: onPressed,
        child: Ink(
          width: size,
          height: size,
          decoration: BoxDecoration(
            color: Color.alphaBlend(
              cs.outline.withValues(alpha: 0.35),
              cs.surface,
            ),
            shape: BoxShape.circle,
            border: Border.all(color: cs.outline),
          ),
          child: Icon(
            icon,
            color: cs.onSurface,
            size: iconSize,
          ),
        ),
      ),
    );
  }
}

class AuthTopBar extends StatelessWidget {
  final bool showBack;
  final VoidCallback? onBack;

  const AuthTopBar({super.key, this.showBack = true, this.onBack});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        if (showBack)
          AuthCircularIconButton(
            icon: Iconsax.arrow_left,
            onPressed: onBack ?? () => Get.back(),
          ),
      ],
    );
  }
}
