import 'package:flutter/material.dart';
import 'package:transmirror/core/utils/constants/image_strings.dart';
import 'package:transmirror/core/widgets/main/profile/profile_layout.dart';

/// Profile summary: name, subtitle, optional stats, avatar with optional Pro badge.
class ProfileIdentitySection extends StatelessWidget {
  const ProfileIdentitySection({
    super.key,
    required this.displayName,
    required this.subtitle,
    this.followingLabel = '0 Following',
    this.followersLabel = '0 Followers',
    required this.profileImageUrl,
    this.showProBadge = false,
  });

  final String displayName;
  final String subtitle;
  final String followingLabel;
  final String followersLabel;
  final String profileImageUrl;
  final bool showProBadge;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final r = ProfileLayout.avatarRadius(context);

    final ImageProvider<Object> avatarImage = profileImageUrl.isNotEmpty
        ? NetworkImage(profileImageUrl)
        : const AssetImage(MyImages.user);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cs.surfaceContainerHighest.withValues(alpha: 0.45),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: cs.outline.withValues(alpha: 0.35)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  displayName,
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: cs.onSurface,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  subtitle,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: cs.onSurface.withValues(alpha: 0.72),
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  '$followingLabel    $followersLabel',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: cs.onSurface.withValues(alpha: 0.8),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Stack(
            clipBehavior: Clip.none,
            alignment: Alignment.bottomCenter,
            children: [
              CircleAvatar(
                radius: r,
                backgroundColor: cs.surfaceContainerHighest,
                foregroundImage: avatarImage,
              ),
              if (showProBadge)
                Positioned(
                  bottom: -2,
                  child: _ProBadge(colorScheme: cs),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ProBadge extends StatelessWidget {
  const _ProBadge({required this.colorScheme});

  final ColorScheme colorScheme;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: colorScheme.tertiary.withValues(alpha: 0.95),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: colorScheme.outline.withValues(alpha: 0.25),
        ),
      ),
      child: Text(
        'Pro',
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: colorScheme.onTertiary,
              fontWeight: FontWeight.w700,
            ),
      ),
    );
  }
}
