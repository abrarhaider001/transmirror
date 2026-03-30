import 'package:flutter/material.dart';

/// Shared rounded container used for speak-freely and translate text areas.
class SttRoundedCard extends StatelessWidget {
  const SttRoundedCard({
    super.key,
    required this.radius,
    required this.child,
    this.padding = const EdgeInsets.all(8),
  });

  final double radius;
  final Widget child;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: cs.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(radius),
        boxShadow: [
          BoxShadow(
            color: cs.shadow.withOpacity(0.07),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
        border: Border.all(color: cs.outlineVariant.withOpacity(0.25)),
      ),
      child: child,
    );
  }
}
