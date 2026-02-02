import 'package:flutter/material.dart';
import 'package:transmirror/core/utils/constants/colors.dart';
import 'package:transmirror/core/utils/constants/sizes.dart';
import 'package:transmirror/core/utils/theme/widget_themes/text_theme.dart';

class HomeNoteCard extends StatelessWidget {
  const HomeNoteCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.icon,
    this.backgroundColor = MyColors.white,
    this.iconColor = MyColors.textPrimary,
    this.textColor = MyColors.textPrimary,
    this.subtitleColor = MyColors.textSecondary,
    this.isActive = false,
    this.onTap,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final Color backgroundColor;
  final Color iconColor;
  final Color textColor;
  final Color subtitleColor;
  final bool isActive;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(MySizes.defaultPagePadding),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(24),
          border: isActive ? null : Border.all(color: MyColors.grey.withOpacity(0.2)),
          boxShadow: [
            BoxShadow(
              color: isActive ? backgroundColor.withOpacity(0.4) : Colors.black.withOpacity(0.05),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: isActive ? MyColors.white : MyColors.softGrey,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(icon, color: isActive ? MyColors.primary : iconColor, size: 24),
            ),
            const Spacer(),
            Text(
              title,
              style: (MyTextTheme.lightTextTheme.headlineSmall ?? const TextStyle()).copyWith(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                color: textColor,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              subtitle,
              style: (MyTextTheme.lightTextTheme.bodySmall ?? const TextStyle()).copyWith(
                color: subtitleColor,
                fontSize: 14,
                height: 1.4,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
