import 'package:flutter/material.dart';
import 'package:flutter_countryify/scr/widgets/flag_widget.dart';

/// Circular SVG flag from [flutter_countryify], with optional primary ring to
/// match the speech-to-text / translate page theme (same idea as the home avatar).
class CircularCountryFlag extends StatelessWidget {
  const CircularCountryFlag({
    super.key,
    required this.countryCode,
    this.size = 28,
    this.showPrimaryBorder = true,
  });

  final String countryCode;
  final double size;

  /// When true, draws a thin [ColorScheme.primary] ring like the translate page.
  final bool showPrimaryBorder;

  @override
  Widget build(BuildContext context) {
    final flag = CountryFlag(
      countryCode: countryCode,
      size: size,
      shape: FlagShape.circle,
    );

    if (!showPrimaryBorder) {
      return flag;
    }

    final cs = Theme.of(context).colorScheme;
    const borderWidth = 1.0;
    final inner = (size - borderWidth * 2).clamp(8.0, size);

    return Container(
      width: size,
      height: size,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: cs.primary, width: borderWidth),
      ),
      child: ClipOval(
        child: CountryFlag(
          countryCode: countryCode,
          size: inner,
          shape: FlagShape.circle,
        ),
      ),
    );
  }
}
