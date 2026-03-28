import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

/// App bar using theme colors. Pass [gradient] only if a gradient bar is required (rare).
class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool showBack;
  final VoidCallback? onBack;
  final Color? backgroundColor;
  final Color? titleColor;
  final Gradient? gradient;
  final List<Widget>? actions;

  const CustomAppBar({
    super.key,
    required this.title,
    this.showBack = true,
    this.onBack,
    this.backgroundColor,
    this.titleColor,
    this.gradient,
    this.actions,
  });

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final fg = titleColor ?? scheme.onPrimary;
    final bg = backgroundColor ?? scheme.primary;

    return AppBar(
      title: Padding(
        padding: const EdgeInsets.only(right: 10.0),
        child: Text(
          title,
          style: TextStyle(
            color: fg,
            fontSize: 16,
            fontFamily: 'Poppins',
          ),
        ),
      ),
      leading: showBack
          ? IconButton(
              onPressed: onBack ?? Get.back,
              icon: Icon(Iconsax.arrow_left, color: fg),
            )
          : null,
      actions: actions,
      elevation: 0,
      backgroundColor: gradient != null ? Colors.transparent : bg,
      foregroundColor: fg,
      flexibleSpace: gradient != null
          ? Container(decoration: BoxDecoration(gradient: gradient))
          : null,
    );
  }
}
