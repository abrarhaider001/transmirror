import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:transmirror/core/widgets/auth/auth_top_bar.dart';

class LayoutPagesAppBar extends StatelessWidget {
  final String title;
  final bool showBack;
  final bool showTrailing;
  final Widget? trailingWidget;
  final VoidCallback? onTrailingPressed;

  const LayoutPagesAppBar({
    required this.title,
    this.showBack = true,
    this.showTrailing = true,
    this.trailingWidget,
    this.onTrailingPressed,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    const double slot = 44;
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              if (showBack)
                AuthCircularIconButton(
                  icon: Iconsax.arrow_left,
                  onPressed: () => Navigator.pop(context),
                )
              else
                const SizedBox(width: slot, height: slot),
              if (showTrailing)
                trailingWidget ??
                    AuthCircularIconButton(
                      icon: Iconsax.notification,
                      onPressed: onTrailingPressed,
                    )
              else
                const SizedBox(width: slot, height: slot),
            ],
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 60),
            child: Text(
              title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Theme.of(context).colorScheme.onSurface,
                  ) ??
                  const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
            ),
          ),
        ],
      ),
    );
  }
}
