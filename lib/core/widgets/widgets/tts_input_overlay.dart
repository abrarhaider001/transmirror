import 'package:flutter/material.dart';
import 'package:google_mlkit_translation/google_mlkit_translation.dart';
import 'package:iconsax/iconsax.dart';
import 'package:transmirror/core/utils/constants/colors.dart';
import 'package:transmirror/core/widgets/widgets/language_picker_chip.dart';

class TTSInputOverlay extends StatelessWidget {
  final bool isTranslateMode;
  final TranslateLanguage sourceLanguage;
  final TranslateLanguage targetLanguage;
  final ValueChanged<TranslateLanguage> onSourceChanged;
  final ValueChanged<TranslateLanguage> onTargetChanged;
  final bool isPlaying;
  final bool isProcessing;
  final VoidCallback onActionPressed;
  final VoidCallback onStopPressed;

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

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          // Middle: Text Selectors (Language Chips)
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: isTranslateMode
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        LanguagePickerChip(
                          label: 'From',
                          selectedLanguage: sourceLanguage,
                          onLanguageChanged: onSourceChanged,
                        ),
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 5),
                          child: Icon(Iconsax.arrow_right_1, color: MyColors.secondary, size: 16),
                        ),
                        LanguagePickerChip(
                          label: 'To',
                          selectedLanguage: targetLanguage,
                          onLanguageChanged: onTargetChanged,
                        ),
                      ],
                    )
                  : Center(
                      child: LanguagePickerChip(
                        selectedLanguage: sourceLanguage,
                        onLanguageChanged: onSourceChanged,
                      ),
                    ),
            ),
          ),

          // Right: Play Button
          GestureDetector(
            onTap: isPlaying ? onStopPressed : (isProcessing ? null : onActionPressed),
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: MyColors.primary,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: MyColors.primary.withOpacity(0.4),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: isProcessing
                  ? const Center(
                      child: SizedBox(
                        height: 18,
                        width: 18,
                        child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                      ),
                    )
                  : Icon(
                      isPlaying ? Iconsax.pause : Iconsax.play,
                      color: Colors.white,
                      size: 18,
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
