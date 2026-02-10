import 'package:flutter/material.dart';

class SelectionBox extends StatelessWidget {
  final double x;
  final double y;
  final double width;
  final double height;
  final double minWidth;
  final double minHeight;
  final Function(double dx, double dy) onMove;
  final Function(double dx, double dy, {bool top, bool bottom, bool left, bool right}) onResize;

  const SelectionBox({
    super.key,
    required this.x,
    required this.y,
    required this.width,
    required this.height,
    this.minWidth = 100,
    this.minHeight = 80,
    required this.onMove,
    required this.onResize,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: x,
      top: y,
      width: width,
      height: height,
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
                onMove(details.delta.dx, details.delta.dy);
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
          onResize(
            details.delta.dx,
            details.delta.dy,
            top: top,
            bottom: bottom,
            left: left,
            right: right,
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
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
