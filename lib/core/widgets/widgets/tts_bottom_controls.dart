import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:transmirror/core/utils/constants/colors.dart';

class TTSBottomControls extends StatefulWidget {
  final bool isPlaying;
  final bool isProcessing;
  final VoidCallback onActionPressed;
  final VoidCallback onStopPressed;
  final Function(double) onVolumeChanged;
  final Function(double) onPitchChanged;
  final Function(double) onRateChanged;

  const TTSBottomControls({
    super.key,
    required this.isPlaying,
    required this.isProcessing,
    required this.onActionPressed,
    required this.onStopPressed,
    required this.onVolumeChanged,
    required this.onPitchChanged,
    required this.onRateChanged,
  });

  @override
  State<TTSBottomControls> createState() => _TTSBottomControlsState();
}

class _TTSBottomControlsState extends State<TTSBottomControls> with SingleTickerProviderStateMixin {
  bool _showSettings = false;

  void _toggleSettings() {
    setState(() {
      _showSettings = !_showSettings;
    });
  }

  void _showSliderDialog(String title, double value, double min, double max, Function(double) onChanged) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title, style: const TextStyle(color: MyColors.primary)),
        content: SizedBox(
          height: 50,
          child: StatefulBuilder(
            builder: (context, setState) {
              return Slider(
                value: value,
                min: min,
                max: max,
                activeColor: MyColors.primary,
                onChanged: (val) {
                  setState(() => value = val);
                  onChanged(val);
                },
              );
            },
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Done'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 20,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: Row(
        children: [
          // Animated Settings Section
          GestureDetector(
            onTap: _toggleSettings,
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: _showSettings ? MyColors.primary : MyColors.softGrey,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Iconsax.setting_2,
                color: _showSettings ? Colors.white : MyColors.primary,
                size: 24,
              ),
            ),
          ),
          
          // Expandable Settings Buttons
          AnimatedSize(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            child: SizedBox(
              width: _showSettings ? null : 0,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(width: 10),
                  _buildSettingButton(Iconsax.volume_high, () => _showSliderDialog('Volume', 1.0, 0.0, 1.0, widget.onVolumeChanged)),
                  const SizedBox(width: 10),
                  _buildSettingButton(Iconsax.timer_1, () => _showSliderDialog('Speed (Rate)', 0.5, 0.0, 1.0, widget.onRateChanged)),
                  const SizedBox(width: 10),
                  _buildSettingButton(Iconsax.music, () => _showSliderDialog('Pitch', 1.0, 0.5, 2.0, widget.onPitchChanged)),
                ],
              ),
            ),
          ),

          const Spacer(),

          // Main Action Button
                  GestureDetector(
                    onTap: widget.isPlaying ? widget.onStopPressed : (widget.isProcessing ? null : widget.onActionPressed),
                    child: Container(
                      width: 70,
                      height: 70,
                      decoration: BoxDecoration(
                        color: widget.isPlaying ? MyColors.error : MyColors.primary,
                        borderRadius: BorderRadius.circular(24),
                        boxShadow: [
                          BoxShadow(
                            color: (widget.isPlaying ? MyColors.error : MyColors.primary).withOpacity(0.4),
                            blurRadius: 15,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: widget.isProcessing
                          ? const Center(
                              child: SizedBox(
                                height: 30,
                                width: 30,
                                child: CircularProgressIndicator(color: Colors.white, strokeWidth: 3),
                              ),
                            )
                          : Icon(
                              widget.isPlaying ? Iconsax.pause : Iconsax.volume_high,
                              color: Colors.white,
                              size: 32,
                            ),
                    ),
                  ),
        ],
      ),
    );
  }

  Widget _buildSettingButton(IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: MyColors.softGrey,
          shape: BoxShape.circle,
        ),
        child: Icon(icon, size: 20, color: MyColors.secondary),
      ),
    );
  }
}
