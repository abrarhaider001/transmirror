import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

/// Three equal columns: icon tile + caption (Share, Rate us, Follow us).
class ProfileSocialActionsRow extends StatelessWidget {
  const ProfileSocialActionsRow({
    super.key,
    required this.onShare,
    required this.onRate,
    required this.onFollow,
  });

  final VoidCallback onShare;
  final VoidCallback onRate;
  final VoidCallback onFollow;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final narrow = constraints.maxWidth < 340;
        final gap = narrow ? 8.0 : 12.0;

        final children = [
          Expanded(
            child: _SocialTile(
              label: 'Share',
              icon: Icons.share,
              onTap: onShare,
            ),
          ),
          SizedBox(width: gap),
          Expanded(
            child: _SocialTile(
              label: 'Rate us',
              icon: Iconsax.star,
              onTap: onRate,
            ),
          ),
          SizedBox(width: gap),
          Expanded(
            child: _SocialTile(
              label: 'Follow us',
              icon: Iconsax.instagram,
              onTap: onFollow,
            ),
          ),
        ];

        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: children,
        );
      },
    );
  }
}

class _SocialTile extends StatelessWidget {
  const _SocialTile({
    required this.label,
    required this.icon,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return Column(
      children: [
        AspectRatio(
          aspectRatio: 1,
          child: Material(
            color: cs.surfaceContainerHighest.withValues(alpha: 0.55),
            borderRadius: BorderRadius.circular(16),
            clipBehavior: Clip.antiAlias,
            child: InkWell(
              onTap: onTap,
              child: Icon(icon, color: cs.onSurface.withValues(alpha: 0.85), size: 26),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          textAlign: TextAlign.center,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: theme.textTheme.bodySmall?.copyWith(
            color: cs.onSurface.withValues(alpha: 0.75),
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
