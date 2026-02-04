import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_overlay_window/flutter_overlay_window.dart';
// import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:transmirror/core/utils/constants/colors.dart';

class OverlayEntryWidget extends StatelessWidget {
  const OverlayEntryWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      resizeToAvoidBottomInset: false,
      body: Center(
        child: Container(
          height: 200,
          width: 200,
          decoration: BoxDecoration(
            color: Colors.red, // Bright red for visibility
            border: Border.all(color: Colors.white, width: 4),
            borderRadius: BorderRadius.circular(20),
          ),
          child: const Center(
            child: Text(
              "Overlay Works",
              style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ),
    );
  }
}
