import 'package:flutter/material.dart';

/// Full-width rounded control for logout / delete account style actions.
class ProfileFooterButton extends StatelessWidget {
  const ProfileFooterButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.destructive = false,
  });

  final String label;
  final VoidCallback onPressed;
  final bool destructive;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    final Color fg = destructive ? cs.error : cs.onSurface;
    final Color bg = destructive
        ? cs.error.withValues(alpha: 0.12)
        : cs.surfaceContainerHighest.withValues(alpha: 0.55);

    return SizedBox(
      width: double.infinity,
      child: TextButton(
        style: TextButton.styleFrom(
          foregroundColor: fg,
          backgroundColor: bg,
          padding: const EdgeInsets.symmetric(vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
            side: BorderSide(
              color: destructive
                  ? cs.error.withValues(alpha: 0.35)
                  : cs.outline.withValues(alpha: 0.35),
            ),
          ),
        ),
        onPressed: onPressed,
        child: Text(
          label,
          style: theme.textTheme.titleSmall?.copyWith(
            color: fg,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
