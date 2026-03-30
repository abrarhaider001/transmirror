import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

class SttSwapLanguagesButton extends StatelessWidget {
  const SttSwapLanguagesButton({super.key, required this.onSwap});

  final VoidCallback onSwap;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Material(
      elevation: 6,
      shadowColor: cs.shadow.withOpacity(0.35),
      shape: const CircleBorder(),
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onSwap,
        child: Ink(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [cs.primary, cs.tertiary],
            ),
          ),
          child: const Icon(Iconsax.arrow_swap, color: Colors.white, size: 26),
        ),
      ),
    );
  }
}
