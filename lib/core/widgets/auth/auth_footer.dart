import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:transmirror/core/utils/constants/colors.dart';

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
    final baseStyle = GoogleFonts.poppins(
      fontSize: 14,
      fontWeight: FontWeight.w500,
      color: MyColors.white,
    );
    final actionStyle = GoogleFonts.poppins(
      fontSize: 14,
      fontWeight: FontWeight.w600,
      color: MyColors.darkLink,
    );

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(text, style: baseStyle),
        GestureDetector(
          onTap: onTap,
          child: Text(actionText, style: actionStyle),
        ),
      ],
    );
  }
}
