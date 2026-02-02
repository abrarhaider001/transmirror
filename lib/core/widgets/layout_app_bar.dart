
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:transmirror/core/utils/constants/colors.dart';
import 'package:transmirror/core/utils/theme/widget_themes/text_theme.dart';

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
          Text(
            title,
            textAlign: TextAlign.center,
            style: MyTextTheme.lightTextTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ) ?? const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
