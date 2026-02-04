import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_overlay_window/flutter_overlay_window.dart';

class ResizableOverlay extends StatefulWidget {
  const ResizableOverlay({super.key});

  @override
  State<ResizableOverlay> createState() => _ResizableOverlayState();
}

class _ResizableOverlayState extends State<ResizableOverlay> {
  // Initial size should match what is passed in showOverlay
  double _width = 300;
  double _height = 300;
  
  // Color for the container
  Color _containerColor = Colors.white;

  @override
  void initState() {
    super.initState();
    FlutterOverlayWindow.overlayListener.listen((event) {
      log("Overlay received event: $event");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Stack(
        children: [
          Container(
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
              color: _containerColor,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey.shade300, width: 1),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 8,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: Column(
              children: [
                // Header / Close button area
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 12.0),
                      child: Text(
                        "Overlay", 
                        style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey[800])
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close, color: Colors.grey),
                      onPressed: () async {
                        await FlutterOverlayWindow.closeOverlay();
                      },
                    ),
                  ],
                ),
                
                // Content Area
                Expanded(
                  child: Center(
                    child: Text(
                      "Resizable Container",
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                  ),
                ),
              ],
            ),
          ),
          
          // Resize Handle at Bottom Right
          Positioned(
            bottom: 0,
            right: 0,
            child: GestureDetector(
              onPanUpdate: (details) async {
                setState(() {
                  _width += details.delta.dx;
                  _height += details.delta.dy;
                  
                  // Enforce minimum size
                  if (_width < 150) _width = 150;
                  if (_height < 150) _height = 150;
                });
                
                await FlutterOverlayWindow.resizeOverlay(
                  _width.toInt(), 
                  _height.toInt()
                  , false);
              },
              child: Container(
                width: 30,
                height: 30,
                decoration: BoxDecoration(
                  color: Colors.transparent,
                  borderRadius: const BorderRadius.only(
                    bottomRight: Radius.circular(12),
                  ),
                ),
                child: const Icon(
                  Icons.open_in_full_rounded, // or filter_list or drag_handle
                  color: Colors.blueAccent,
                  size: 20,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
