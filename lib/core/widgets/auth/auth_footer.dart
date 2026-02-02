import 'package:flutter/material.dart';
import 'package:transmirror/core/utils/theme/widget_themes/text_theme.dart';

class AuthFooter extends StatelessWidget {
  final String text;
  final String actionText;
  final VoidCallback onTap;
  const AuthFooter({
    super.key,
    required this.text,
    required this.actionText,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(text),
        GestureDetector(
          onTap: onTap,
          child: Text(
            actionText,
            style: MyTextTheme.lightTextTheme.titleLarge,
          ),
        ),
      ],
    );
  }
}

