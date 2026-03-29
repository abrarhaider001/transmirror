import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:transmirror/core/utils/constants/colors.dart';
import 'package:transmirror/core/utils/constants/sizes.dart';

/// Temporary Duo home body until duo-specific flows are built.
class DuoModePlaceholder extends StatelessWidget {
  const DuoModePlaceholder({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: MySizes.lg),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(28),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    MyColors.secondary.withOpacity(0.15),
                    MyColors.tertiary.withOpacity(0.25),
                  ],
                ),
                boxShadow: [
                  BoxShadow(
                    color: MyColors.primary.withOpacity(0.08),
                    blurRadius: 32,
                    offset: const Offset(0, 16),
                  ),
                ],
              ),
              child: Icon(
                Iconsax.people,
                size: 56,
                color: MyColors.primary.withOpacity(0.85),
              ),
            ),
            const SizedBox(height: 28),
            Text(
              'Duo mode',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w800,
                fontSize: 22,
                letterSpacing: -0.4,
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Shared sessions and duo-only tools will live here. '
              'Switch to Solo to use text, voice, documents, and OCR on your own.',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
                height: 1.55,
                fontSize: 15,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
