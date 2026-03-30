import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:transmirror/core/utils/constants/text_strings.dart';
import 'package:url_launcher/url_launcher.dart';

class AuthLegalFooter extends StatelessWidget {
  const AuthLegalFooter({super.key, this.prefix = 'By continuing you agree to our '});

  final String prefix;

  Future<void> _open(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final base = GoogleFonts.poppins(
      fontSize: 12,
      height: 1.45,
      color: cs.onSurfaceVariant,
    );
    final link = GoogleFonts.poppins(
      fontSize: 12,
      color: cs.primary,
      fontWeight: FontWeight.w600,
    );

    return Center(
      child: Wrap(
        alignment: WrapAlignment.center,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          Text(prefix, style: base, textAlign: TextAlign.center),
          GestureDetector(
            onTap: () => _open(MyTexts.privacyPolicyUrl),
            child: Text('Privacy & Policy', style: link),
          ),
          Text(' and ', style: base),
          GestureDetector(
            onTap: () => _open(MyTexts.termsUrl),
            child: Text('Terms & Conditions', style: link),
          ),
        ],
      ),
    );
  }
}
