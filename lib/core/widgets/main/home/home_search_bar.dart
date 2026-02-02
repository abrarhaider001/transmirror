import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:transmirror/core/utils/constants/colors.dart';
import 'package:transmirror/core/utils/theme/widget_themes/text_theme.dart';

class HomeSearchBar extends StatelessWidget {
  const HomeSearchBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        color: MyColors.white,
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: MyColors.grey.withOpacity(0.2)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          const Icon(Iconsax.search_normal, color: MyColors.textSecondary, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search notes, tags...',
                hintStyle: (MyTextTheme.lightTextTheme.bodyMedium ?? const TextStyle()).copyWith(
                  color: MyColors.textSecondary,
                ),
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
              ),
            ),
          ),
          const Icon(Iconsax.microphone, color: MyColors.textSecondary, size: 20),
        ],
      ),
    );
  }
}
