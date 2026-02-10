import 'dart:developer';
import 'dart:isolate';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_overlay_window/flutter_overlay_window.dart';
import 'package:iconsax/iconsax.dart';

import 'package:transmirror/view/overlay/selection_box.dart';

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
      if (event is Map && event['type'] == 'result') {
        _showResultDialog(event['text']);
      } else if (event is String && event.startsWith('Error')) {
         _showResultDialog(event);
      }
    });
  }

  void _showResultDialog(String text) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Extracted Text"),
        content: SingleChildScrollView(child: Text(text)),
        actions: [
          TextButton(
            onPressed: () {
              Clipboard.setData(ClipboardData(text: text));
              Navigator.pop(context);
            }, 
            child: const Text("Copy")
          ),
          TextButton(
            onPressed: () => Navigator.pop(context), 
            child: const Text("Close")
          ),
        ],
      ),
    );
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
          SelectionBox(
            x: _x,
            y: _y,
            width: _width,
            height: _height,
            minWidth: _minWidth,
            minHeight: _minHeight,
            onMove: _updatePosition,
            onResize: _resize,
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
            top: 280,
            right: 20,
            child: _buildActionButton(
              icon: Iconsax.magicpen,
              onTap: () async {
                // Lookup Main App Port
                final SendPort? mainPort = IsolateNameServer.lookupPortByName('main_app_port');
                if (mainPort != null) {
                  mainPort.send({
                    'action': 'capture',
                    'x': _x,
                    'y': _y,
                    'w': _width,
                    'h': _height,
                    'ratio': MediaQuery.of(context).devicePixelRatio,
                  });
                } else {
                  log("Main Port not found");
                }
              },
            ),
          ),
        ],
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
