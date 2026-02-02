import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:transmirror/core/utils/constants/colors.dart';
import 'package:transmirror/core/utils/constants/image_strings.dart';
import 'package:transmirror/core/utils/theme/widget_themes/text_theme.dart';

class HomeHeader extends StatelessWidget {
  const HomeHeader({super.key, required this.name});

  final String name;

  @override
  Widget build(BuildContext context) {
    final h = DateTime.now().hour;
    final greet = h < 12
        ? 'Good Morning'
        : h < 17
        ? 'Good Afternoon'
        : 'Good Evening';

    return Row(
      children: [
        const CircleAvatar(
          radius: 20,
          backgroundColor: MyColors.grey,
          foregroundImage: AssetImage(MyImages.user),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                greet,
                style:
                    (MyTextTheme.lightTextTheme.bodySmall ?? const TextStyle())
                        .copyWith(color: MyColors.textSecondary, fontSize: 12),
              ),
              Text(
                name,
                style:
                    (MyTextTheme.lightTextTheme.headlineMedium ??
                            const TextStyle())
                        .copyWith(fontWeight: FontWeight.bold, fontSize: 16),
              ),
            ],
          ),
        ),
        _buildIconButton(Iconsax.notification),
      ],
    );
  }

  Widget _buildIconButton(IconData icon) {
    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        color: MyColors.white,
        shape: BoxShape.circle,
        border: Border.all(color: MyColors.grey.withOpacity(0.2)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Icon(icon, color: MyColors.textPrimary, size: 24),
    );
  }
}
