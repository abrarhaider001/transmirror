
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:transmirror/core/utils/constants/colors.dart';
import 'package:transmirror/core/utils/constants/image_strings.dart';

class ProfileHeader extends StatelessWidget {
  const ProfileHeader({
    super.key,
    required this.name,
    required this.email,
  });

  final String name;
  final String email;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: MyColors.lightGrey, borderRadius: BorderRadius.circular(16)),
      child: Row(
        children: [
          const CircleAvatar(radius: 24, backgroundColor: MyColors.grey10, foregroundImage: AssetImage(MyImages.user)),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: MyColors.textPrimary)),
                const SizedBox(height: 4),
                Text(email, style: const TextStyle(fontSize: 12, color: MyColors.textSecondary)),
              ],
            ),
          ),
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(color: MyColors.grey, borderRadius: BorderRadius.circular(18)),
            child: const Icon(Iconsax.edit, color: MyColors.black, size: 18),
          ),
        ],
      ),
    );
  }
}