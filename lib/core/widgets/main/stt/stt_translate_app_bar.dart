import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

class SttTranslateAppBar extends StatelessWidget {
  const SttTranslateAppBar({
    super.key,
    required this.onBack,
    required this.onShare,
    this.title = 'Speech To Text',
  });

  final VoidCallback onBack;
  final VoidCallback onShare;
  final String title;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.fromLTRB(4, 8, 8, 8),
      child: Row(
        children: [
          IconButton(
            style: IconButton.styleFrom(
              backgroundColor: cs.surfaceContainerHighest,
              foregroundColor: cs.onSurface,
            ),
            onPressed: onBack,
            icon: const Icon(Iconsax.arrow_left_2, size: 22),
          ),
          Expanded(
            child: Text(
              title,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w800,
                    color: cs.onSurface,
                  ),
            ),
          ),
          IconButton(
            style: IconButton.styleFrom(
              backgroundColor: cs.surfaceContainerHighest,
              foregroundColor: cs.onSurface,
            ),
            onPressed: onShare,
            icon: const Icon(Icons.share_rounded, size: 20),
          ),
        ],
      ),
    );
  }
}
