import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_overlay_window/flutter_overlay_window.dart';
import 'package:iconsax/iconsax.dart';

class ResizableOverlay extends StatefulWidget {
  const ResizableOverlay({super.key});

  @override
  State<ResizableOverlay> createState() => _ResizableOverlayState();
}

class _ResizableOverlayState extends State<ResizableOverlay> {
  // Initial size and position of the selection box
  double _x = 50;
  double _y = 200;
  double _width = 300;
  double _height = 150;
  
  // Minimum size constraints
  final double _minWidth = 100;
  final double _minHeight = 80;

  @override
  void initState() {
    super.initState();
    FlutterOverlayWindow.overlayListener.listen((event) {
      log("Overlay received event: $event");
    });
  }

  void _updatePosition(double dx, double dy) {
    setState(() {
      _x += dx;
      _y += dy;
    });
  }

  void _resize(double dx, double dy, {bool left = false, bool top = false, bool right = false, bool bottom = false}) {
    setState(() {
      if (left) {
        if (_width - dx >= _minWidth) {
          _x += dx;
          _width -= dx;
        }
      }
      if (right) {
        if (_width + dx >= _minWidth) {
          _width += dx;
        }
      }
      if (top) {
        if (_height - dy >= _minHeight) {
          _y += dy;
          _height -= dy;
        }
      }
      if (bottom) {
        if (_height + dy >= _minHeight) {
          _height += dy;
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,

      child: Stack(
        children: [
          // The Selection Box
          Positioned(
            left: _x,
            top: _y,
            width: _width,
            height: _height,
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                // 1. Visual Border (The Box itself)
                Container(
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.black, width: 2),
                  ),
                ),

                // 2. Move Detector (Center Area)
                // Inset by 20px to avoid conflict with edge resize handles
                Positioned(
                  top: 20, 
                  bottom: 20, 
                  left: 20, 
                  right: 20,
                  child: GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onPanUpdate: (details) {
                      _updatePosition(details.delta.dx, details.delta.dy);
                    },
                    child: Container(color: Colors.transparent),
                  ),
                ),

                // 3. Edge Handles (Resize)
                _buildEdgeHandle(top: true),
                _buildEdgeHandle(bottom: true),
                _buildEdgeHandle(left: true),
                _buildEdgeHandle(right: true),
              ],
            ),
          ),

          // Close Button (Top Right of Screen)
          Positioned(
            top: 180,
            right: 20,
            child: _buildActionButton(
              icon: Icons.close,
              onTap: () async {
                await FlutterOverlayWindow.closeOverlay();
              },
            ),
          ),          
          // Start Extracting Button (Top Right of Screen)
          Positioned(
            top: 240,
            right: 20,
            child: _buildActionButton(
              icon: Iconsax.magicpen,
              onTap: () async {
                await FlutterOverlayWindow.closeOverlay();
              },
            ),
          ),
        ],
      ),
    
    );
  }

  Widget _buildEdgeHandle({bool top = false, bool bottom = false, bool left = false, bool right = false}) {
    // Thickness of the invisible touch area
    const double touchThickness = 50.0;
    // Offset to center the touch area on the border (thickness / 2)
    const double offset = -25.0; 

    return Positioned(
      top: top ? offset : (bottom ? null : 0),
      bottom: bottom ? offset : (top ? null : 0),
      left: left ? offset : (right ? null : 0),
      right: right ? offset : (left ? null : 0),
      height: (top || bottom) ? touchThickness : null,
      width: (left || right) ? touchThickness : null,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onPanUpdate: (details) {
          _resize(
            details.delta.dx, 
            details.delta.dy, 
            top: top, 
            bottom: bottom, 
            left: left, 
            right: right
          );
        },
        child: Container(
          color: Colors.transparent,
          child: Center(
            child: Container(
              width: (top || bottom) ? 40 : 6,
              height: (left || right) ? 40 : 6,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(3),
                border: Border.all(color: Colors.black, width: 1),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 4,
                  )
                ]
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildActionButton({required IconData icon, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.black,
          shape: BoxShape.circle,
          border: Border.all(color: Colors.white, width: 2),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 8,
            )
          ]
        ),
        child: Icon(icon, color: Colors.white, size: 24),
      ),
    );
  }
}
