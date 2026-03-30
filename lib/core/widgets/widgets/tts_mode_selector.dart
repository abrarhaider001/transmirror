import 'package:flutter/material.dart';
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
    final cs = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.all(4),
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: cs.surfaceContainerHighest.withOpacity(0.6),
        borderRadius: BorderRadius.circular(MySizes.defaultBorderRadius),
        boxShadow: [
          BoxShadow(
            color: cs.shadow.withOpacity(0.06),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          _buildTab(
            context,
            'Speak Only',
            !isTranslateMode,
            () => onModeChanged(false),
          ),
          _buildTab(
            context,
            'Live translate',
            isTranslateMode,
            () => onModeChanged(true),
          ),
        ],
      ),
    );
  }

  Widget _buildTab(
    BuildContext context,
    String title,
    bool isSelected,
    VoidCallback onTap,
  ) {
    final cs = Theme.of(context).colorScheme;
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isSelected ? cs.primary : Colors.transparent,
            borderRadius: BorderRadius.circular(MySizes.defaultBorderRadius),
          ),
          child: Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: isSelected ? cs.onPrimary : cs.onSurfaceVariant,
            ),
          ),
        ),
      ),
    );
  }
}
