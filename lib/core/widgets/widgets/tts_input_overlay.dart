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

          // Right: Control Button
          _buildControlButton(
            onTap: isPlaying ? onStopPressed : (isProcessing ? null : onActionPressed),
            icon: isPlaying ? Iconsax.stop : Iconsax.play,
            color: isPlaying ? Colors.red : MyColors.primary,
            isProcessing: isProcessing,
          ),
        ],
      ),
    );
  }

  Widget _buildControlButton({
    required VoidCallback? onTap,
    required IconData icon,
    required Color color,
    bool isProcessing = false,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.3),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
child: isPlaying
    ? Icon(Iconsax.stop, color: Colors.white, size: 20)
    : isProcessing
        ? const Center(
            child: SizedBox(
              height: 20,
              width: 20,
              child: CircularProgressIndicator(
                color: Colors.white,
                strokeWidth: 2,
              ),
            ),
          )
        : Icon(Iconsax.volume_high, color: Colors.white, size: 20),

      ),
    );
  }
}
