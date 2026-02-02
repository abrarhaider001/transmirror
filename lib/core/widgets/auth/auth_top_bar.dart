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
              onTap: () => Get.back(),
              child: Ink(
                width: 40,
                height: 40,
                decoration: const BoxDecoration(
                  color: MyColors.grey,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.arrow_back, color: Colors.black),
              ),
            ),
          ),
      ],
    );
  }
}
