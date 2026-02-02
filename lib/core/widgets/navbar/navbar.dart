import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:transmirror/core/widgets/navbar/custom_bottom_nav_bar.dart';
import 'package:iconsax/iconsax.dart';
import 'package:transmirror/view/main/profile.dart';
import 'package:transmirror/view/main/user_home.dart';
import 'package:transmirror/view_model/navbar_controller.dart';

class Navbar extends StatefulWidget {
  const Navbar({super.key, this.initialIndex = 0});

  final int initialIndex;

  @override
  State<Navbar> createState() => _NavbarState();
}

class _NavbarState extends State<Navbar> {
  NavbarController? _controller;

  NavbarController get controller {
    if (_controller == null) {
      _controller = Get.put(NavbarController());
      _controller!.selectedIndex.value = widget.initialIndex;
    } else if (!Get.isRegistered<NavbarController>()) {
      // Re-register if it was deleted but state persisted
      Get.put(_controller!);
    }
    return _controller!;
  }

  @override
  void dispose() {
    Get.delete<NavbarController>();
    super.dispose();
  }

  List<Widget> get _pages => const [
        HomePage(),
        ProfilePage(),
      ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true, // Allow body to extend behind navbar if needed, helpful for full screen effects
      body: Stack(
        children: [
          // const CustomBackground(),
          Obx(() => IndexedStack(index: controller.selectedIndex.value, children: _pages)),
        ],
      ),
      bottomNavigationBar: Obx(() => CustomBottomNavBar(
        currentIndex: controller.selectedIndex.value,
        onTap: (i) => controller.changeIndex(i),
        items: const [
          BottomNavigationBarItem(icon: Icon(Iconsax.home_1), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Iconsax.user), label: 'Profile'),
        ],
      )),
    );
  }
}

