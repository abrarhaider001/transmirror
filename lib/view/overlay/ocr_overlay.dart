import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_overlay_window/flutter_overlay_window.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:transmirror/core/utils/constants/colors.dart';

// Entry point for the overlay
@pragma("vm:entry-point")
void overlayMain() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: OcrOverlayWidget(),
  ));
}

class OcrOverlayWidget extends StatefulWidget {
  const OcrOverlayWidget({super.key});

  @override
  State<OcrOverlayWidget> createState() => _OcrOverlayWidgetState();
}

class _OcrOverlayWidgetState extends State<OcrOverlayWidget> {
  String _extractedText = '';
  bool _isExtracting = false;
  final _textRecognizer = TextRecognizer(script: TextRecognitionScript.latin);
  
  // UI State for the floating box
  double _height = 250;
  double _top = 100;
  // We'll center horizontally or allow moving? 
  // For simplicity, let's keep it centered horizontally or use margin.
  // Using Positioned with left/right logic is good.
  
  @override
  void initState() {
    super.initState();
    FlutterOverlayWindow.overlayListener.listen((event) {
      log("Current Event: $event");
    });
  }

  @override
  void dispose() {
    _textRecognizer.close();
    super.dispose();
  }

  Future<void> _extractText() async {
    setState(() {
      _isExtracting = true;
      _extractedText = '';
    });

    // Simulated extraction
    await Future.delayed(const Duration(seconds: 2));

    setState(() {
      _isExtracting = false;
      _extractedText = "This is a simulated extracted text.\n(Screen capture requires native MediaProjection implementation)";
    });
  }

  Future<void> _closeOverlay() async {
    await FlutterOverlayWindow.closeOverlay();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    const double horizontalMargin = 20;
    final double boxWidth = screenWidth - (horizontalMargin * 2);

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          Positioned(
            top: _top,
            left: horizontalMargin,
            width: boxWidth,
            height: _height,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.1), // Faint background to see through
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: MyColors.primary, width: 2),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                children: [
                  // Header / Drag Handle
                  GestureDetector(
                    onPanUpdate: (details) {
                      setState(() {
                        _top += details.delta.dy;
                        // Limit top to avoid going off screen
                        if (_top < 0) _top = 0;
                      });
                    },
                    child: Container(
                      height: 40,
                      width: double.infinity,
                      decoration: const BoxDecoration(
                        color: MyColors.primary,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(10),
                          topRight: Radius.circular(10),
                        ),
                      ),
                      child: Row(
                        children: [
                          const SizedBox(width: 40), // Spacer for centering
                          const Expanded(
                            child: Icon(Icons.drag_handle, color: Colors.white),
                          ),
                          IconButton(
                            onPressed: _closeOverlay,
                            icon: const Icon(Icons.close, color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                  ),
                  
                  // Content Area
                  Expanded(
                    child: Center(
                      child: _extractedText.isNotEmpty
                          ? Container(
                              padding: const EdgeInsets.all(16),
                              margin: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: SingleChildScrollView(
                                child: Text(
                                  _extractedText,
                                  style: const TextStyle(color: Colors.black, fontSize: 14),
                                ),
                              ),
                            )
                          : Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.crop_free, color: MyColors.primary, size: 40),
                              const SizedBox(height: 8),
                              const Text(
                                "Align text within this box",
                                style: TextStyle(color: MyColors.primary, fontWeight: FontWeight.bold),
                              ),
                               if (_isExtracting)
                                 const Padding(
                                   padding: EdgeInsets.only(top: 20),
                                   child: CircularProgressIndicator(color: MyColors.primary),
                                 )
                            ],
                          ),
                    ),
                  ),

                  // Bottom Actions
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                         ElevatedButton.icon(
                          onPressed: _isExtracting ? null : _extractText,
                          icon: const Icon(Icons.text_fields),
                          label: const Text("Extract Text"),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: MyColors.primary,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                          ),
                         ),
                      ],
                    ),
                  ),
                  
                  // Resize Handle
                  GestureDetector(
                    onVerticalDragUpdate: (details) {
                      setState(() {
                        _height += details.delta.dy;
                        if (_height < 150) _height = 150; // Minimum height
                      });
                    },
                    child: Container(
                      height: 24,
                      decoration: BoxDecoration(
                        color: MyColors.primary.withOpacity(0.9),
                        borderRadius: const BorderRadius.only(
                          bottomLeft: Radius.circular(10),
                          bottomRight: Radius.circular(10),
                        ),
                      ),
                      child: const Center(
                        child: Icon(Icons.unfold_more, color: Colors.white, size: 18),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
