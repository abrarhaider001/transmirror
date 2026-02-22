import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:swipe_image_ocr/swipe_image_ocr.dart';
import 'package:transmirror/core/utils/constants/colors.dart';

class SwipeTextSelector extends StatefulWidget {
  final File image;
  final Function(String) onTextSelected;
  final VoidCallback? onScanStarted;
  final String? detectedLanguage;
  final VoidCallback? onCopyPressed;
  final VoidCallback? onSpeechPressed;
  final VoidCallback? onViewPressed;

  const SwipeTextSelector({
    super.key,
    required this.image,
    required this.onTextSelected,
    this.onScanStarted,
    this.detectedLanguage,
    this.onCopyPressed,
    this.onSpeechPressed,
    this.onViewPressed,
  });

  @override
  State<SwipeTextSelector> createState() => _SwipeTextSelectorState();
}

class _SwipeTextSelectorState extends State<SwipeTextSelector> {
  double _pointerSize = 15.0;
  Uint8List? _imageBytes;
  double _aspectRatio = 1.0;

  @override
  void initState() {
    super.initState();
    _loadImageBytes();
  }

  Future<void> _loadImageBytes() async {
    final bytes = await widget.image.readAsBytes();
    
    double aspectRatio = 1.0;
    try {
      final codec = await ui.instantiateImageCodec(bytes);
      final frameInfo = await codec.getNextFrame();
      final image = frameInfo.image;
      aspectRatio = image.width / image.height;
    } catch (e) {
      debugPrint("Error calculating aspect ratio: $e");
    }

    if (mounted) {
      setState(() {
        _imageBytes = bytes;
        _aspectRatio = aspectRatio;
      });
    }
  }

  Widget _buildIconButton(IconData icon, VoidCallback? onPressed) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          color: MyColors.white,
          shape: BoxShape.circle,
          border: Border.all(color: MyColors.grey.withOpacity(0.2)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Icon(icon, color: MyColors.textPrimary, size: 24),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_imageBytes == null) {
      return const Center(child: CircularProgressIndicator());
    }

    return Column(
      children: [
        Expanded(
          child: Container(
            width: double.infinity,
            color: Colors.grey[200],
            child: Stack(
              children: [
                Center(
                  child: AspectRatio(
                    aspectRatio: _aspectRatio,
                    child: Listener(
                      onPointerUp: (_) => widget.onScanStarted?.call(),
                      child: SwipeImageOCR(
                        imageBytes: _imageBytes!,
                        onTextRead: (text) {
                          if (text != null) {
                            widget.onTextSelected(text);
                          }
                        },
                        strokeWidth: _pointerSize,
                        swipeColor: MyColors.primary.withOpacity(0.5),
                        indicatorColor: MyColors.primary,
                      ),
                    ),
                  ),
                ),
                if (widget.detectedLanguage != null)
                  Positioned(
                    bottom: 20,
                    right: 20,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _buildIconButton(Iconsax.eye, widget.onViewPressed),
                      const SizedBox(height: 12),
                      _buildIconButton(Iconsax.copy, widget.onCopyPressed),
                      const SizedBox(height: 12),
                      _buildIconButton(Iconsax.volume_high, widget.onSpeechPressed),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
        Container(
          color: MyColors.primaryBackground,
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Pointer Size",
                style: TextStyle(color: MyColors.textPrimary, fontWeight: FontWeight.bold),
              ),
              Row(
                children: [
                  const Text("5.0", style: TextStyle(color: MyColors.textPrimary)),
                  Expanded(
                    child: Slider(
                      value: _pointerSize,
                      min: 5.0,
                      max: 50.0,
                      activeColor: MyColors.primary,
                      inactiveColor: MyColors.softGrey,
                      onChanged: (value) {
                        setState(() {
                          _pointerSize = value;
                        });
                      },
                    ),
                  ),
                  const Text("50.0", style: TextStyle(color: MyColors.textPrimary)),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
