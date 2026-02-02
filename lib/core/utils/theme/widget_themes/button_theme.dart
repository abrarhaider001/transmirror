import 'package:flutter/material.dart';
import '../../constants/colors.dart';

class MyButtonTheme {
  static BoxDecoration primaryGradient({double radius = 24}) {
    return BoxDecoration(
      color: MyColors.primary,
      borderRadius: BorderRadius.circular(radius),
    );
  }
}
class GradientElevatedButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final Widget child;
  final double height;
  final double width;
  final double radius;
  final Color backgroundColor;
  final Color? borderColor;
  final Color? textColor;
  final double padding;

  const GradientElevatedButton({
    super.key,
    required this.onPressed,
    required this.child,
    this.height = 44,
    this.width = 120,
    this.radius = 12,
    this.backgroundColor = MyColors.primary,
    this.borderColor = MyColors.primary,
    this.textColor = MyColors.white,
    this.padding = 14,
  });



  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          elevation: 0,
          backgroundColor: backgroundColor,
          foregroundColor: textColor,
          minimumSize: Size.zero,
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          padding: EdgeInsets.symmetric(vertical: padding),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radius),
            side: BorderSide(
              color: borderColor ?? MyColors.primary,
              width: 2,
            ),
          ),
        ),
        child: child,
      ),
    );
  }
}
