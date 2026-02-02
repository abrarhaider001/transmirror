import 'package:flutter/material.dart';
import 'package:transmirror/core/utils/constants/colors.dart';
import 'package:transmirror/core/utils/constants/sizes.dart';

class TTSModeSelector extends StatelessWidget {
  final bool isTranslateMode;
  final ValueChanged<bool> onModeChanged;

  const TTSModeSelector({
    super.key,
    required this.isTranslateMode,
    required this.onModeChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(4),
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(MySizes.defaultBorderRadius), // Rounded pill shape
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          _buildTab('Speak Only', !isTranslateMode, () => onModeChanged(false)),
          _buildTab('Translate First', isTranslateMode, () => onModeChanged(true)),
        ],
      ),
    );
  }

  Widget _buildTab(String title, bool isSelected, VoidCallback onTap) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isSelected ? MyColors.primary : Colors.transparent,
            borderRadius: BorderRadius.circular(MySizes.defaultBorderRadius),
          ),
          child: Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: isSelected ? Colors.white : Colors.grey,
            ),
          ),
        ),
      ),
    );
  }
}
