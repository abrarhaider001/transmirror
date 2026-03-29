
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:transmirror/core/utils/constants/colors.dart';

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
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              if (showBack)
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(color: MyColors.white, borderRadius: BorderRadius.circular(20)),
                    child: const Icon(Iconsax.arrow_left, color: MyColors.primary),
                  ),
                )
              else
                const SizedBox(width: 40, height: 40),
              
              if (showTrailing)
                GestureDetector(
                  onTap: onTrailingPressed,
                  child: trailingWidget ?? Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(color: MyColors.white, borderRadius: BorderRadius.circular(20)),
                    child: const Icon(Iconsax.notification, color: MyColors.primary),
                  ),
                )
              else
                 const SizedBox(width: 40, height: 40),
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
