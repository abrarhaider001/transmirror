import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:transmirror/core/utils/constants/colors.dart';

class AuthTopBar extends StatelessWidget {
  final bool showBack;
  final VoidCallback? onBack;

  const AuthTopBar({super.key, this.showBack = true, this.onBack});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        if (showBack)
          Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(20),
              onTap: onBack ?? () => Get.back(),
              child: Ink(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.1),
                  shape: BoxShape.circle,
                  border: Border.all(color: MyColors.darkOutline),
                ),
                child: Icon(
                  Icons.arrow_back,
                  color: MyColors.darkOnBackground,
                  size: 22,
                ),
              ),
            ),
          ),
      ],
    );
  }
}
