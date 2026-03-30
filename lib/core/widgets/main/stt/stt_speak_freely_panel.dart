import 'package:flutter/material.dart';
import 'package:google_mlkit_translation/google_mlkit_translation.dart';
import 'package:iconsax/iconsax.dart';
import 'package:transmirror/core/utils/translate_language_country_code.dart';
import 'package:transmirror/core/widgets/main/stt/circular_country_flag.dart';
import 'package:transmirror/core/widgets/main/stt/stt_hint_strings.dart';
import 'package:transmirror/core/widgets/main/stt/stt_round_icon_button.dart';
import 'package:transmirror/core/widgets/main/stt/stt_rounded_card.dart';
import 'package:transmirror/core/widgets/widgets/language_picker_chip.dart';

/// Speak freely mode: single rounded card filling height with centered speech text.
class SttSpeakFreelyPanel extends StatelessWidget {
  const SttSpeakFreelyPanel({
    super.key,
    required this.radius,
    required this.sourceLanguage,
    required this.onSourceLanguageChanged,
    required this.textController,
    required this.speechEnabled,
    required this.isRecording,
    required this.formattedTime,
    required this.isSpeaking,
    required this.onRecordTap,
    required this.onSpeakTap,
  });

  final double radius;
  final TranslateLanguage sourceLanguage;
  final ValueChanged<TranslateLanguage> onSourceLanguageChanged;
  final TextEditingController textController;
  final bool speechEnabled;
  final bool isRecording;
  final String formattedTime;
  final bool isSpeaking;
  final VoidCallback onRecordTap;
  final VoidCallback onSpeakTap;

  String _languageName(TranslateLanguage language) {
    final name = language.name.toLowerCase();
    return name[0].toUpperCase() + name.substring(1);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return SizedBox.expand(
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
                  icon: isSpeaking ? Iconsax.stop : Iconsax.volume_high,
                  onTap: onSpeakTap,
                  background: cs.surfaceContainerHighest,
                  foreground: cs.onSurface,
                ),
                const Spacer(),
                LanguagePickerChip(
                  selectedLanguage: sourceLanguage,
                  onLanguageChanged: onSourceLanguageChanged,
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
              child: TextField(
                controller: textController,
                readOnly: true,
                maxLines: null,
                expands: true,
                textAlign: TextAlign.center,
                textAlignVertical: TextAlignVertical.center,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.transparent,
                  border: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  disabledBorder: InputBorder.none,
                  errorBorder: InputBorder.none,
                  focusedErrorBorder: InputBorder.none,
                  contentPadding: EdgeInsets.zero,
                  hintText: speechEnabled
                      ? SttHintStrings.sourceSpeech(
                          _languageName(sourceLanguage),
                        )
                      : 'Speech recognition not available',
                  hintStyle: theme.textTheme.bodyLarge?.copyWith(
                    color: cs.onSurfaceVariant.withOpacity(0.65),
                    fontWeight: FontWeight.w600,
                  ),
                  hintMaxLines: 4,
                ),
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: cs.onSurface,
                  height: 1.35,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
