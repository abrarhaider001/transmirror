import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

/// Wide primary action + compact icon button (e.g. Add friends + share).
class ProfilePrimaryActionsRow extends StatelessWidget {
  const ProfilePrimaryActionsRow({
    super.key,
    required this.primaryLabel,
    required this.onPrimaryPressed,
    required this.onIconPressed,
    this.primaryIcon = Iconsax.user_add,
  });

  final String primaryLabel;
  final VoidCallback onPrimaryPressed;
  final VoidCallback onIconPressed;
  final IconData primaryIcon;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return Row(
      children: [
        Expanded(
          child: FilledButton(
            style: FilledButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
              backgroundColor: cs.primary,
              foregroundColor: cs.onPrimary,
            ),
            onPressed: onPrimaryPressed,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(primaryIcon, size: 20),
                const SizedBox(width: 8),
                Flexible(
                  child: Text(
                    primaryLabel,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.labelLarge?.copyWith(
                      color: cs.onPrimary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 12),
        SizedBox(
          width: 52,
          height: 52,
          child: OutlinedButton(
            style: OutlinedButton.styleFrom(
              padding: EdgeInsets.zero,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
              side: BorderSide(color: cs.outline.withValues(alpha: 0.55)),
              foregroundColor: cs.onSurface,
            ),
            onPressed: onIconPressed,
            child: const Icon(Iconsax.export, size: 22),
          ),
        ),
      ],
    );
  }
}
