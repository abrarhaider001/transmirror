import 'package:flutter/material.dart';
import 'package:transmirror/core/utils/constants/enums.dart';
import 'package:transmirror/core/utils/constants/image_strings.dart';
import 'package:transmirror/core/utils/constants/sizes.dart';

class HomeHeader extends StatelessWidget {
  const HomeHeader({
    super.key,
    required this.name,
    required this.selectedMode,
    required this.onModeChanged,
    this.onMenuTap,
  });

  final String name;
  final AppMode selectedMode;
  final ValueChanged<AppMode> onModeChanged;
  final VoidCallback? onMenuTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onMenuTap,
            borderRadius: BorderRadius.circular(8),
            child: Padding(
              padding: const EdgeInsets.all(MySizes.sm),
              child: _TwoLineMenuIcon(color: cs.onSurface),
            ),
          ),
        ),

        const SizedBox(width: MySizes.md),
        _ModeTabs(selectedMode: selectedMode, onModeChanged: onModeChanged),
        const SizedBox(width: MySizes.md),
        Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: cs.primary, width: 1.5),
          ),
          child: CircleAvatar(
            radius: 14,
            backgroundColor: cs.surfaceContainerHighest,
            backgroundImage: const AssetImage(MyImages.user),
          ),
        ),
      ],
    );
  }
}

class _TwoLineMenuIcon extends StatelessWidget {
  const _TwoLineMenuIcon({required this.color});

  final Color color;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 20,
          height: 2,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(1),
          ),
        ),
        const SizedBox(height: 5),
        Container(
          width: 20,
          height: 2,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(1),
          ),
        ),
      ],
    );
  }
}

class _ModeTabs extends StatelessWidget {
  const _ModeTabs({required this.selectedMode, required this.onModeChanged});

  final AppMode selectedMode;
  final ValueChanged<AppMode> onModeChanged;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _ModeTab(
            label: 'Solo',
            selected: selectedMode == AppMode.solo,
            onTap: () => onModeChanged(AppMode.solo),
          ),
          const SizedBox(width: MySizes.md),
          _ModeTab(
            label: 'Duo',
            selected: selectedMode == AppMode.duo,
            onTap: () => onModeChanged(AppMode.duo),
          ),
        ],
      ),
    );
  }
}

class _ModeTab extends StatelessWidget {
  const _ModeTab({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final inactive = cs.onSurfaceVariant.withOpacity(0.45);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(6),
      splashFactory: NoSplash.splashFactory,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              label,
              style: theme.textTheme.labelLarge?.copyWith(
                color: selected ? cs.onSurface : inactive,
                fontWeight: selected ? FontWeight.w800 : FontWeight.w500,
                fontSize: MySizes.fontSizeMd,
              ),
            ),
            const SizedBox(height: 4),
            AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              curve: Curves.easeOut,
              height: 2,
              width: selected ? 28 : 0,
              decoration: BoxDecoration(
                color: selected ? cs.primary : Colors.transparent,
                borderRadius: BorderRadius.circular(1),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
