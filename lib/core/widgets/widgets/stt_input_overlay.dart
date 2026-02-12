import 'package:flutter/material.dart';
import 'package:google_mlkit_translation/google_mlkit_translation.dart';
import 'package:iconsax/iconsax.dart';
import 'package:transmirror/core/utils/constants/colors.dart';
import 'package:transmirror/core/widgets/widgets/language_picker_chip.dart';

class STTInputOverlay extends StatelessWidget {
  final bool isTranslateMode;
  final TranslateLanguage sourceLanguage;
  final TranslateLanguage targetLanguage;
  final ValueChanged<TranslateLanguage> onSourceChanged;
  final ValueChanged<TranslateLanguage> onTargetChanged;
  final bool isRecording;
  final bool isProcessing;
  final VoidCallback onRecordPressed;
  final VoidCallback onStopPressed;
  final String formattedTime;

  const STTInputOverlay({
    super.key,
    required this.isTranslateMode,
    required this.sourceLanguage,
    required this.targetLanguage,
    required this.onSourceChanged,
    required this.onTargetChanged,
    required this.isRecording,
    required this.isProcessing,
    required this.onRecordPressed,
    required this.onStopPressed,
    required this.formattedTime,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(24),
          bottomRight: Radius.circular(24),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (isRecording)
            Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.red.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 8,
                          height: 8,
                          decoration: const BoxDecoration(
                            color: Colors.red,
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          formattedTime,
                          style: const TextStyle(
                            color: Colors.red,
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              // Language Selectors
              Expanded(
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: isTranslateMode
                      ? Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                LanguagePickerChip(
                                  label: 'From',
                                  selectedLanguage: sourceLanguage,
                                  onLanguageChanged: onSourceChanged,
                                ),
                              ],
                            ),
                            const Padding(
                              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 12),
                              child: Icon(Iconsax.arrow_right_1, color: MyColors.secondary, size: 16),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                LanguagePickerChip(
                                  label: 'To',
                                  selectedLanguage: targetLanguage,
                                  onLanguageChanged: onTargetChanged,
                                ),
                              ],
                            ),
                          ],
                        )
                      : LanguagePickerChip(
                          selectedLanguage: sourceLanguage,
                          onLanguageChanged: onSourceChanged,
                        ),
                ),
              ),
              const SizedBox(width: 12),

              // Control Buttons
              if (isRecording) ...[
                _buildControlButton(
                  onTap: onStopPressed,
                  icon: Iconsax.stop,
                  color: Colors.red,
                ),
              ] else
                _buildControlButton(
                  onTap: isProcessing ? null : onRecordPressed,
                  icon: Iconsax.microphone,
                  color: MyColors.primary,
                  isProcessing: isProcessing,
                ),
            ],
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
        child: isProcessing
            ? const Center(
                child: SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                ),
              )
            : Icon(icon, color: Colors.white, size: 20),
      ),
    );
  }
}
