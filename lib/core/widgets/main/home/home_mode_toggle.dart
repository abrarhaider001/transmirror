import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:transmirror/core/utils/constants/colors.dart';
import 'package:transmirror/core/utils/constants/enums.dart';
import 'package:transmirror/core/utils/constants/sizes.dart';
import 'package:transmirror/core/utils/theme/widget_themes/text_theme.dart';

/// Pill switch between Solo and Duo on the home screen.
class HomeModeToggle extends StatelessWidget {
  const HomeModeToggle({
    super.key,
    required this.selected,
    required this.onChanged,
  });

  final AppMode selected;
  final ValueChanged<AppMode> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: MyColors.grey10,
        borderRadius: BorderRadius.circular(32),
        border: Border.all(color: MyColors.grey.withOpacity(0.35)),
      ),
      child: Row(
        children: [
          Expanded(
            child: _ModeChip(
              label: 'Solo',
              icon: Iconsax.user,
              isSelected: selected == AppMode.solo,
              onTap: () => onChanged(AppMode.solo),
            ),
          ),
          const SizedBox(width: 4),
          Expanded(
            child: _ModeChip(
              label: 'Duo',
              icon: Iconsax.people,
              isSelected: selected == AppMode.duo,
              onTap: () => onChanged(AppMode.duo),
            ),
          ),
        ],
      ),
    );
  }
}

class _ModeChip extends StatelessWidget {
  const _ModeChip({
    required this.label,
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final baseStyle = MyTextTheme.lightTextTheme.labelLarge ?? const TextStyle();

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(28),
        splashColor: MyColors.primary.withOpacity(0.08),
        highlightColor: MyColors.primary.withOpacity(0.05),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 220),
          curve: Curves.easeOutCubic,
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: MySizes.sm),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(28),
            color: isSelected ? MyColors.white : Colors.transparent,
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: MyColors.primary.withOpacity(0.12),
                      blurRadius: 16,
                      offset: const Offset(0, 6),
                    ),
                  ]
                : null,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 18,
                color: isSelected ? MyColors.primary : MyColors.textTertiary,
              ),
              const SizedBox(width: 8),
              Flexible(
                child: Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: baseStyle.copyWith(
                    fontWeight: FontWeight.w700,
                    fontSize: 14,
                    letterSpacing: 0.2,
                    color: isSelected ? MyColors.primary : MyColors.textTertiary,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
