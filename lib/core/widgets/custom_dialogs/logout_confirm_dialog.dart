import 'package:flutter/material.dart';
import 'package:transmirror/core/utils/constants/colors.dart';
import 'package:transmirror/core/utils/theme/widget_themes/button_theme.dart';

class LogoutConfirmDialog extends StatelessWidget {
  final VoidCallback onConfirm;
  const LogoutConfirmDialog({super.key, required this.onConfirm});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: MyColors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      contentPadding: const EdgeInsets.fromLTRB(20, 20, 20, 12),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: const [
          Text(
            'See you soon!',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: MyColors.textPrimary,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'You are about to logout. Are you sure this is what you want?',
            style: TextStyle(color: MyColors.textSecondary),
          ),
        ],
      ),
      actionsPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      actions: [
        Row(
          children: [
            Expanded(
              child: SizedBox(
                child: GradientElevatedButton(
                  backgroundColor: MyColors.grey10,
                  borderColor: MyColors.grey10,
                  textColor: MyColors.primary,
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text(
                    'Cancel',
                    style: TextStyle(
                      color: MyColors.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: SizedBox(
                child: GradientElevatedButton(
                  onPressed: onConfirm,
                  child: const Text(
                    'Logout',
                    style: TextStyle(
                      color: MyColors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
