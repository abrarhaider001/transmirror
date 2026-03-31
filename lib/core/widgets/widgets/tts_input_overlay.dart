import 'package:flutter/material.dart';
import 'package:google_mlkit_translation/google_mlkit_translation.dart';
import 'package:iconsax/iconsax.dart';
import 'package:transmirror/core/utils/translate_language_country_code.dart';
import 'package:transmirror/core/widgets/main/stt/circular_country_flag.dart';
import 'package:transmirror/core/widgets/main/stt/stt_round_icon_button.dart';
import 'package:transmirror/core/widgets/widgets/language_picker_chip.dart';

/// Top-of-card language + play bar for Text-to-Speech (same placement idea as
/// [SttSpeakFreelyPanel]): language chips on the left, round speaker / pause on
/// the right; no tinted bar behind the row. Names are capped so controls fit.
class TTSInputOverlay extends StatelessWidget {
  /// Display length cap for language names in this bar (see [LanguagePickerChip.maxLanguageNameLength]).
  static const int _kMaxLanguageNameChars = 12;
  const TTSInputOverlay({
    super.key,
    required this.isTranslateMode,
    required this.sourceLanguage,
    required this.targetLanguage,
    required this.onSourceChanged,
    required this.onTargetChanged,
    required this.isPlaying,
    required this.isProcessing,
    required this.onActionPressed,
    required this.onStopPressed,
  });

  final bool isTranslateMode;
  final TranslateLanguage sourceLanguage;
  final TranslateLanguage targetLanguage;
  final ValueChanged<TranslateLanguage> onSourceChanged;
  final ValueChanged<TranslateLanguage> onTargetChanged;
  final bool isPlaying;
  final bool isProcessing;
  final VoidCallback onActionPressed;
  final VoidCallback onStopPressed;

  Widget _translateChipsRow(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Flexible(
          child: LanguagePickerChip(
            selectedLanguage: sourceLanguage,
            onLanguageChanged: onSourceChanged,
            maxLanguageNameLength: _kMaxLanguageNameChars,
            leading: CircularCountryFlag(
              countryCode: countryCodeForTranslateLanguage(sourceLanguage),
              size: 26,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4),
          child: Icon(Iconsax.arrow_right_1, color: cs.primary, size: 16),
        ),
        Flexible(
          child: LanguagePickerChip(
            selectedLanguage: targetLanguage,
            onLanguageChanged: onTargetChanged,
            maxLanguageNameLength: _kMaxLanguageNameChars,
            leading: CircularCountryFlag(
              countryCode: countryCodeForTranslateLanguage(targetLanguage),
              size: 26,
            ),
          ),
        ),
      ],
    );
  }

  Widget _singleLanguageChip(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: LanguagePickerChip(
        selectedLanguage: sourceLanguage,
        onLanguageChanged: onSourceChanged,
        maxLanguageNameLength: _kMaxLanguageNameChars,
        leading: CircularCountryFlag(
          countryCode: countryCodeForTranslateLanguage(sourceLanguage),
          size: 26,
        ),
      ),
    );
  }

  /// Play / pause / loading — when audio is playing, show pause (like STT speaker
  /// uses stop while speaking); tap stops playback. Spinner only while preparing,
  /// never over the pause state.
  Widget _playbackControl(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    if (isPlaying) {
      return SttRoundIconButton(
        icon: Iconsax.pause,
        onTap: onStopPressed,
        background: cs.surfaceContainerHighest,
        foreground: cs.onSurface,
        highlight: false,
      );
    }

    if (isProcessing) {
      return SizedBox(
        width: 44,
        height: 44,
        child: Center(
          child: SizedBox(
            width: 26,
            height: 26,
            child: CircularProgressIndicator(color: cs.primary, strokeWidth: 2),
          ),
        ),
      );
    }

    return SttRoundIconButton(
      icon: Iconsax.volume_high,
      onTap: onActionPressed,
      background: cs.primary,
      foreground: cs.onPrimary,
      highlight: false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(18, 16, 18, 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: isTranslateMode
                ? _translateChipsRow(context)
                : _singleLanguageChip(context),
          ),
          const SizedBox(width: 10),
          _playbackControl(context),
        ],
      ),
    );
  }
}
