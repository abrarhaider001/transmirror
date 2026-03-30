import 'package:flutter/material.dart';
import 'package:google_mlkit_translation/google_mlkit_translation.dart';
import 'package:iconsax/iconsax.dart';
import 'package:transmirror/core/utils/translate_language_country_code.dart';
import 'package:transmirror/core/widgets/main/stt/circular_country_flag.dart';
import 'package:transmirror/core/widgets/main/stt/stt_hint_strings.dart';
import 'package:transmirror/core/widgets/main/stt/stt_round_icon_button.dart';
import 'package:transmirror/core/widgets/main/stt/stt_rounded_card.dart';
import 'package:transmirror/core/widgets/main/stt/stt_swap_languages_button.dart';
import 'package:transmirror/core/widgets/widgets/language_picker_chip.dart';

/// Two equal-height rounded text areas with a swap button stacked on their junction.
class SttTranslateCardsStack extends StatelessWidget {
  const SttTranslateCardsStack({
    super.key,
    required this.radius,
    required this.sourceLanguage,
    required this.targetLanguage,
    required this.onSourceChanged,
    required this.onTargetChanged,
    required this.lastWords,
    required this.translatedText,
    required this.speechEnabled,
    required this.isRecording,
    required this.formattedTime,
    required this.onRecordTap,
    required this.onSpeakSource,
    required this.onSpeakTarget,
    required this.onCopy,
    required this.onView,
    required this.onSwap,
    required this.isSpeaking,
  });

  final double radius;
  final TranslateLanguage sourceLanguage;
  final TranslateLanguage targetLanguage;
  final ValueChanged<TranslateLanguage> onSourceChanged;
  final ValueChanged<TranslateLanguage> onTargetChanged;
  final String lastWords;
  final String translatedText;
  final bool speechEnabled;
  final bool isRecording;
  final String formattedTime;
  final VoidCallback onRecordTap;
  final VoidCallback onSpeakSource;
  final VoidCallback onSpeakTarget;
  final VoidCallback onCopy;
  final VoidCallback onView;
  final VoidCallback onSwap;
  final bool isSpeaking;

  String _languageName(TranslateLanguage language) {
    final name = language.name.toLowerCase();
    return name[0].toUpperCase() + name.substring(1);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    final sourceHint = SttHintStrings.sourceSpeech(
      _languageName(sourceLanguage),
    );
    final targetHint = SttHintStrings.targetTranslation(
      _languageName(targetLanguage),
    );

    return Stack(
      clipBehavior: Clip.none,
      alignment: Alignment.center,
      children: [
        Positioned.fill(
          child: Column(
            children: [
              Expanded(
                child: SttRoundedCard(
                  radius: radius,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Row(
                        children: [
                          SttRoundIconButton(
                            icon: Iconsax.microphone,
                            onTap: speechEnabled ? onRecordTap : null,
                            background: cs.primaryContainer,
                            foreground: cs.onPrimaryContainer,
                            highlight: isRecording,
                          ),
                          const SizedBox(width: 10),
                          SttRoundIconButton(
                            icon: isSpeaking
                                ? Iconsax.stop
                                : Iconsax.volume_high,
                            onTap: onSpeakSource,
                            background: cs.surfaceContainerHighest,
                            foreground: cs.onSurface,
                          ),
                          const Spacer(),
                          LanguagePickerChip(
                            selectedLanguage: sourceLanguage,
                            onLanguageChanged: onSourceChanged,
                            leading: CircularCountryFlag(
                              countryCode: countryCodeForTranslateLanguage(
                                sourceLanguage,
                              ),
                              size: 26,
                            ),
                          ),
                        ],
                      ),
                      if (isRecording) ...[
                        const SizedBox(height: 12),
                        Center(
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: cs.errorContainer.withOpacity(0.35),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Container(
                                  width: 8,
                                  height: 8,
                                  decoration: BoxDecoration(
                                    color: cs.error,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  formattedTime,
                                  style: TextStyle(
                                    color: cs.error,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                      const SizedBox(height: 16),
                      Expanded(
                        child: Center(
                          child: SingleChildScrollView(
                            child: Text(
                              lastWords.isEmpty ? sourceHint : lastWords,
                              textAlign: TextAlign.center,
                              style: theme.textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.w700,
                                color: lastWords.isEmpty
                                    ? cs.onSurfaceVariant.withOpacity(0.55)
                                    : cs.onSurface,
                                height: 1.35,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Expanded(
                child: SttRoundedCard(
                  radius: radius,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Row(
                        children: [
                          LanguagePickerChip(
                            selectedLanguage: targetLanguage,
                            onLanguageChanged: onTargetChanged,
                            leading: CircularCountryFlag(
                              countryCode: countryCodeForTranslateLanguage(
                                targetLanguage,
                              ),
                              size: 26,
                            ),
                          ),
                          const Spacer(),
                          SttRoundIconButton(
                            icon: Iconsax.copy,
                            onTap: onCopy,
                            background: cs.surfaceContainerHighest,
                            foreground: cs.onSurface,
                          ),
                          const SizedBox(width: 8),
                          SttRoundIconButton(
                            icon: isSpeaking
                                ? Iconsax.stop
                                : Iconsax.volume_high,
                            onTap: onSpeakTarget,
                            background: cs.surfaceContainerHighest,
                            foreground: cs.onSurface,
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Expanded(
                        child: Center(
                          child: SingleChildScrollView(
                            child: Text(
                              translatedText.isEmpty
                                  ? targetHint
                                  : translatedText,
                              textAlign: TextAlign.center,
                              style: theme.textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.w700,
                                color: translatedText.isEmpty
                                    ? cs.onSurfaceVariant.withOpacity(0.55)
                                    : cs.onSurface,
                                height: 1.35,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        SttSwapLanguagesButton(onSwap: onSwap),
      ],
    );
  }
}
