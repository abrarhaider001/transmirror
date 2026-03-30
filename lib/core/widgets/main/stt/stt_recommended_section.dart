import 'package:flutter/material.dart';
import 'package:google_mlkit_translation/google_mlkit_translation.dart';
import 'package:transmirror/core/utils/constants/sizes.dart';
import 'package:transmirror/core/utils/translate_language_country_code.dart';
import 'package:transmirror/core/widgets/main/stt/circular_country_flag.dart';

class SttRecommendedPair {
  const SttRecommendedPair({
    required this.from,
    required this.to,
    required this.title,
    required this.subtitle,
  });

  final TranslateLanguage from;
  final TranslateLanguage to;
  final String title;
  final String subtitle;
}

/// Expandable list of language pairs for live translate mode.
class SttRecommendedSection extends StatefulWidget {
  const SttRecommendedSection({super.key, required this.onPairTap});

  final void Function(TranslateLanguage from, TranslateLanguage to) onPairTap;

  static const List<SttRecommendedPair> pairs = [
    SttRecommendedPair(
      from: TranslateLanguage.chinese,
      to: TranslateLanguage.turkish,
      title: 'Chinese to Turkish',
      subtitle: 'Instant Chinese to Turkish translation',
    ),
    SttRecommendedPair(
      from: TranslateLanguage.english,
      to: TranslateLanguage.arabic,
      title: 'English to Arabic',
      subtitle: 'Instant English to Arabic translation',
    ),
    SttRecommendedPair(
      from: TranslateLanguage.french,
      to: TranslateLanguage.spanish,
      title: 'French to Spanish',
      subtitle: 'Instant French to Spanish translation',
    ),
    SttRecommendedPair(
      from: TranslateLanguage.german,
      to: TranslateLanguage.italian,
      title: 'German to Italian',
      subtitle: 'Instant German to Italian translation',
    ),
    SttRecommendedPair(
      from: TranslateLanguage.japanese,
      to: TranslateLanguage.korean,
      title: 'Japanese to Korean',
      subtitle: 'Instant Japanese to Korean translation',
    ),
    SttRecommendedPair(
      from: TranslateLanguage.hindi,
      to: TranslateLanguage.urdu,
      title: 'Hindi to Urdu',
      subtitle: 'Instant Hindi to Urdu translation',
    ),
  ];

  @override
  State<SttRecommendedSection> createState() => _SttRecommendedSectionState();
}

class _SttRecommendedSectionState extends State<SttRecommendedSection> {
  static const int _collapsedCount = 3;
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final visibleCount =
        _expanded ? SttRecommendedSection.pairs.length : _collapsedCount;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Recommended',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w800,
                color: cs.onSurface,
              ),
            ),
            TextButton(
              onPressed: () {
                setState(() => _expanded = !_expanded);
              },
              child: Text(
                _expanded ? 'Show less' : 'Show All',
                style: theme.textTheme.labelLarge?.copyWith(
                  color: cs.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        ...SttRecommendedSection.pairs.take(visibleCount).map(
              (p) => Padding(
                padding: const EdgeInsets.only(bottom: MySizes.sm),
                child: Material(
                  color: cs.surfaceContainerLowest,
                  borderRadius: BorderRadius.circular(18),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(18),
                    onTap: () => widget.onPairTap(p.from, p.to),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 14,
                      ),
                      child: Row(
                        children: [
                          SizedBox(
                            width: 56,
                            height: 36,
                            child: Stack(
                              clipBehavior: Clip.none,
                              children: [
                                Positioned(
                                  left: 0,
                                  top: 0,
                                  child: CircularCountryFlag(
                                    countryCode:
                                        countryCodeForTranslateLanguage(p.from),
                                    size: 32,
                                  ),
                                ),
                                Positioned(
                                  left: 22,
                                  top: 0,
                                  child: CircularCountryFlag(
                                    countryCode:
                                        countryCodeForTranslateLanguage(p.to),
                                    size: 32,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  p.title,
                                  style: theme.textTheme.titleSmall?.copyWith(
                                    fontWeight: FontWeight.w700,
                                    color: cs.onSurface,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  p.subtitle,
                                  style: theme.textTheme.bodySmall?.copyWith(
                                    color: cs.onSurfaceVariant,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
      ],
    );
  }
}
