import 'package:flutter/material.dart';

/// Neutral, theme-aware feature tile (solo home grid).
/// Matches the “grouped settings tiles” look in both light and dark mode.
class HomeFeatureTile extends StatelessWidget {
  const HomeFeatureTile({
    super.key,
    required this.title,
    required this.subtitle,
    required this.icon,
    this.onTap,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    final tileRadius = 20.0;
    final borderColor = cs.outline.withValues(alpha: 0.35);

    return Material(
      color: cs.surfaceContainerHighest,
      elevation: 0,
      borderRadius: BorderRadius.circular(tileRadius),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(tileRadius),
        splashColor: cs.primary.withValues(alpha: 0.10),
        highlightColor: cs.primary.withValues(alpha: 0.06),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: cs.surfaceVariant,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: borderColor),
                ),
                child: Icon(icon, color: cs.onSurfaceVariant, size: 24),
              ),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w800,
                        fontSize: 16,
                        color: cs.onSurface,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      subtitle,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: cs.onSurfaceVariant,
                        height: 1.35,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
