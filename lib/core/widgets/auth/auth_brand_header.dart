import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:transmirror/core/utils/constants/colors.dart';

/// Centered logo, title, and subtitle for auth screens — uses [MyColors] dark tokens.
class AuthBrandHeader extends StatelessWidget {
  const AuthBrandHeader({
    super.key,
    required this.logoAsset,
    required this.title,
    required this.subtitle,
    this.logoHeight = 72,
  });

  final String logoAsset;
  final String title;
  final String subtitle;
  final double logoHeight;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Image.asset(
          logoAsset,
          height: logoHeight,
          fit: BoxFit.contain,
          errorBuilder: (context, error, stackTrace) => Icon(
            Iconsax.star_1,
            size: logoHeight * 0.6,
            color: MyColors.darkOnBackground,
          ),
        ),
        const SizedBox(height: 28),
        Text(
          title,
          textAlign: TextAlign.center,
          style: GoogleFonts.poppins(
            fontSize: 26,
            fontWeight: FontWeight.w700,
            color: MyColors.darkOnBackground,
            height: 1.2,
          ),
        ),
        const SizedBox(height: 12),
        Text(
          subtitle,
          textAlign: TextAlign.center,
          style: GoogleFonts.poppins(
            fontSize: 14,
            height: 1.5,
            color: MyColors.darkOnSurfaceMuted,
          ),
        ),
      ],
    );
  }
}
