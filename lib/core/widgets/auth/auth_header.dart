import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:transmirror/core/utils/constants/colors.dart';
import 'package:transmirror/core/utils/theme/widget_themes/text_theme.dart';

class AuthHeader extends StatelessWidget {
  final String title;
  final String subtitle;
  const AuthHeader({super.key, required this.title, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(height: 16),
        Text(
          title,
          textAlign: TextAlign.left,
          style: TextStyle(
            fontFamily: GoogleFonts.poppins().fontFamily,
            fontSize: 24.0,
            color: MyColors.textPrimary,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          subtitle,
          textAlign: TextAlign.left,
          style: MyTextTheme.lightTextTheme.bodyMedium,
        ),
      ],
    );
  }
}

