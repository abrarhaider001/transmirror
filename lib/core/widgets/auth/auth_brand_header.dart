import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Title and subtitle for auth screens (aligned to start with page content).
class AuthBrandHeader extends StatelessWidget {
  const AuthBrandHeader({
    super.key,
    required this.title,
    required this.subtitle,
  });

  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: Theme.of(context).textTheme.displayMedium),
        const SizedBox(height: 12),
        Text(
          subtitle,
          textAlign: TextAlign.start,
          style: GoogleFonts.poppins(
            fontSize: 14,
            height: 1.5,
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}
