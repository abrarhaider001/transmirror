import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

class AuthTopBar extends StatelessWidget {
  final bool showBack;
  final VoidCallback? onBack;

  const AuthTopBar({super.key, this.showBack = true, this.onBack});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Row(
      children: [
        if (showBack)
          Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(20),
              onTap: onBack ?? () => Get.back(),
              child: Ink(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: Color.alphaBlend(
                    cs.outline.withValues(alpha: 0.35),
                    cs.surface,
                  ),
                  shape: BoxShape.circle,
                  border: Border.all(color: cs.outline),
                ),
                child: Icon(
                  Iconsax.arrow_left,
                  color: cs.onSurface,
                  size: 22,
                ),
              ),
            ),
          ),
      ],
    );
  }
}
