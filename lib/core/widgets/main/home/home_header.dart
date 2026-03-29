import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:transmirror/core/utils/constants/colors.dart';
import 'package:transmirror/core/utils/constants/image_strings.dart';

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

    return Directionality(
      textDirection: TextDirection.ltr,
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: MyColors.grey,
            ),
            clipBehavior: Clip.antiAlias,
            child: Image.asset(
              MyImages.user,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Icon(
                  Iconsax.user,
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                );
              },
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  greet,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                        fontSize: 12,
                      ),
                ),
                Text(
                  name,
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          _buildIconButton(context, Iconsax.notification),
        ],
      ),
    );
  }

  Widget _buildIconButton(BuildContext context, IconData icon) {
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
      child: Icon(
        icon,
        color: Theme.of(context).colorScheme.onSurface,
        size: 24,
      ),
    );
  }
}
