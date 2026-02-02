import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:transmirror/core/utils/constants/image_strings.dart';

class OnboardingItem {
  final String title;
  final String subtitle;
  final String imageAsset;
  OnboardingItem({
    required this.title,
    required this.subtitle,
    required this.imageAsset,
  });
}

class OnboardingController extends GetxController {
  final pageController = PageController();
  final currentIndex = 0.obs;

  late final List<OnboardingItem> items;

  @override
  void onInit() {
    items = [
      OnboardingItem(
        title: 'Find Trusted Services Near You',
        subtitle:
            "Get instant access to verified professionals for any task — anytime, anywhere.",
        imageAsset: MyImages.onBoardingImage1,
      ),
      OnboardingItem(
        title: 'Book Services in Minutes',
        subtitle:
            'Choose a service, select your time, and book instantly—no waiting, no hassle.',
        imageAsset: MyImages.onBoardingImage2,
      ),
      OnboardingItem(
        title: 'Safe & Reliable Professionals',
        subtitle:
            'All service providers are verified to ensure your safety and high-quality work.',
        imageAsset: MyImages.onBoardingImage3,
      ),
    ];
    super.onInit();
  }

  bool get isFirst => currentIndex.value == 0;
  bool get isLast => currentIndex.value == items.length - 1;

  void next() {
    if (!isLast) {
      pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.ease,
      );
    }
  }

  void back() {
    if (!isFirst) {
      pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.ease,
      );
    }
  }
}
