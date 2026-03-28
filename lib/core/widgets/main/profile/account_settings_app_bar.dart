import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

/// Centered title with optional back / trailing slots; uses [Theme] colors.
class AccountSettingsAppBar extends StatelessWidget {
  const AccountSettingsAppBar({
    super.key,
    required this.title,
    this.showBack = false,
    this.onBack,
    this.trailing,
  });

  final String title;
  final bool showBack;
  final VoidCallback? onBack;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    Widget circleButton({required Widget child, VoidCallback? onTap}) {
      return Material(
        color: cs.surfaceContainerHighest.withValues(alpha: 0.65),
        shape: const CircleBorder(),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          child: SizedBox(width: 40, height: 40, child: Center(child: child)),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              showBack
                  ? circleButton(
                      onTap: onBack ?? () => Navigator.of(context).maybePop(),
                      child: Icon(Iconsax.arrow_left, size: 20, color: cs.onSurface),
                    )
                  : const SizedBox(width: 40, height: 40),
              trailing ??
                  const SizedBox(width: 40, height: 40),
            ],
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 56),
            child: Text(
              title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w700,
                color: cs.onSurface,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
