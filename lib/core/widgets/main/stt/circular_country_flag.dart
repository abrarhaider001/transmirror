import 'package:flutter/material.dart';
import 'package:flutter_countryify/scr/widgets/flag_widget.dart';

/// Circular SVG flag from [flutter_countryify] (country codes are ISO 3166-1 alpha-2).
class CircularCountryFlag extends StatelessWidget {
  const CircularCountryFlag({
    super.key,
    required this.countryCode,
    this.size = 28,
  });

  final String countryCode;
  final double size;

  @override
  Widget build(BuildContext context) {
    return CountryFlag(
      countryCode: countryCode,
      size: size,
      shape: FlagShape.circle,
    );
  }
}
