import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:transmirror/core/utils/constants/colors.dart';
import 'package:transmirror/core/utils/theme/widget_themes/text_theme.dart';

class ProfileTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback? onTap;
  final Widget? trailing;
  
  const ProfileTile({
    super.key, 
    required this.icon, 
    required this.label, 
    this.onTap,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(color: MyColors.white, borderRadius: BorderRadius.circular(16)),
        child: Row(
          children: [
            Icon(icon, color: MyColors.textSecondary, size: 18.0),
            const SizedBox(width: 12),
            Expanded(child: Text(label, style: MyTextTheme.lightTextTheme.bodyLarge)),
            if (trailing != null) 
              trailing!
            else 
              const Icon(Iconsax.arrow_right_3, color: MyColors.textSecondary, size: 14.0,),
          ],
        ),
      ),
    );
  }
}
