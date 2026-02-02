import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:lottie/lottie.dart';
import 'package:transmirror/core/utils/constants/colors.dart';

class VoiceRecordingView extends StatelessWidget {
  final String formattedTime;
  final VoidCallback onStop;
  final VoidCallback onPause;
  final VoidCallback onReset;
  final bool animate;

  const VoiceRecordingView({
    super.key,
    required this.formattedTime,
    required this.onStop,
    required this.onPause,
    required this.onReset,
    this.animate = true,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      key: const ValueKey('recording'),
      children: [
        // Header
        Positioned(
          top: 60,
          left: 0,
          right: 0,
          child: Column(
            children: [
              Text(
                'Capturing your audio...',
                style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                      color: MyColors.primary.withOpacity(0.9),
                      fontWeight: FontWeight.w500,
                    ),
              ),
              const SizedBox(height: 40),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: Text(
                  'Record, process, and manage your\naudio with a single tap',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                        color: MyColors.primary.withOpacity(0.5),
                        height: 1.5,
                        fontSize: 14
                      ),
                ),
              ),
            ],
          ),
        ),

        // Waveform Visual (Center)
        Positioned(
          left: 0,
          right: 0,
          top: 200,
          child: SizedBox(
            width: double.infinity,
            height: 150,
            child: Lottie.asset(
              'assets/animations/voice_wave_active.json',
              animate: animate,
              errorBuilder: (context, error, stackTrace) {
                // Fallback visual
                return Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: List.generate(15, (index) {
                    return Container(
                      width: 4,
                      height: 30.0 + (index % 5) * 15,
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      decoration: BoxDecoration(
                        color: Colors.blueAccent.withOpacity(0.6),
                        borderRadius: BorderRadius.circular(2),
                      ),
                    );
                  }),
                );
              },
            ),
          ),
        ),

        // Timer
        Positioned(
          bottom: 270,
          left: 0,
          right: 0,
          child: Text(
            formattedTime,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.displayLarge!.copyWith(
                  color: MyColors.primary,
                  fontSize: 48,
                  fontWeight: FontWeight.w300,
                  letterSpacing: 2,
                ),
          ),
        ),

        // Controls
        Positioned(
          bottom: 50,
          left: 0,
          right: 0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              // Pause (Left)
              Padding(
                padding: const EdgeInsets.only(bottom: 12, right: 30),
                child: _buildControlCircle(Iconsax.pause, size: 50, iconSize: 24, onTap: onPause),
              ),
              
              // Stop (Center)
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  GestureDetector(
                    onTap: onStop,
                    child: Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: LinearGradient(
                          colors: [MyColors.red, MyColors.red.withOpacity(0.8)], // Purple accent for stop button
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: MyColors.red.withOpacity(0.4),
                            blurRadius: 15,
                            spreadRadius: 2,
                          )
                        ],
                      ),
                      child: const Icon(Iconsax.microphone, color: Colors.white, size: 36),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Stop',
              style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                    color: MyColors.primary,
                    fontWeight: FontWeight.w500,
                  ),
                  ),
                ],
              ),

              // Reset (Right)
              Padding(
                padding: const EdgeInsets.only(bottom: 12, left: 30),
                child: _buildControlCircle(Iconsax.refresh, size: 50, iconSize: 24, onTap: onReset),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildControlCircle(IconData icon, {required double size, required double iconSize, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: MyColors.primary.withOpacity(0.1),
          border: Border.all(color: MyColors.primary.withOpacity(0.2)),
        ),
        child: Icon(icon, color: MyColors.primary, size: iconSize),
      ),
    );
  }
}
