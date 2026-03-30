import 'package:flutter/material.dart';

class SttRoundIconButton extends StatelessWidget {
  const SttRoundIconButton({
    super.key,
    required this.icon,
    required this.onTap,
    required this.background,
    required this.foreground,
    this.highlight = false,
  });

  final IconData icon;
  final VoidCallback? onTap;
  final Color background;
  final Color foreground;
  final bool highlight;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: highlight
          ? Theme.of(context).colorScheme.errorContainer
          : background,
      shape: const CircleBorder(),
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Icon(
            icon,
            size: 20,
            color: highlight
                ? Theme.of(context).colorScheme.onErrorContainer
                : foreground,
          ),
        ),
      ),
    );
  }
}
