import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:lottie/lottie.dart';
import 'package:transmirror/core/utils/constants/colors.dart';

class VoiceInitialView extends StatelessWidget {
  final VoidCallback onRecord;
  final bool animate;

  const VoiceInitialView({
    super.key,
    required this.onRecord,
    this.animate = true,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      key: const ValueKey('initial'),
      children: [
        // Header
        Positioned(
          top: 40,
          left: 0,
          right: 0,
          child: Center(
            child: Text(
              'Ready to capture your voice?',
              style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                    color: MyColors.primary,
                    fontWeight: FontWeight.w500,
                  ),
            ),
          ),
        ),

        // Center Lottie Animation
        Positioned(
          left: 0,
          right: 0,
          top: 100,
          child: SizedBox(
            width: 300,
            height: 300,
            child: Lottie.asset(
              'assets/animations/voice_wave.json',
              animate: animate,
              errorBuilder: (context, error, stackTrace) {
                return Icon(
                  Iconsax.voice_cricle,
                  size: 150,
                  color: MyColors.primary.withOpacity(0.5),
                );
              },
            ),
          ),
        ),

        // Record Now Button (Bottom Center)
        Positioned(
          bottom: 50,
          left: 0,
          right: 0,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              GestureDetector(
                onTap: onRecord,
                child: Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      colors: [MyColors.secondary, MyColors.primary],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: MyColors.secondary.withOpacity(0.4),
                        blurRadius: 10,
                        spreadRadius: 2,
                      )
                    ],
                    border: Border.all(color: MyColors.primary.withOpacity(0.2)),
                  ),
                  child: const Icon(Iconsax.microphone, color: MyColors.white, size: 32),
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'Record Now',
              style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                    color: MyColors.primary,
                    fontWeight: FontWeight.w500,
                  ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
