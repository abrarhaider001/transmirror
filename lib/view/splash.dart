import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:transmirror/core/routes/app_routes.dart';
import 'package:transmirror/core/utils/constants/image_strings.dart';
import 'package:transmirror/core/utils/device/device_utility.dart';
import 'package:transmirror/core/widgets/custom_background.dart';

class Splash extends StatefulWidget {
  const Splash({super.key});

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  @override
  void initState() {
    super.initState();
    _initFlow();
  }

  Future<void> _initFlow() async {
    await Future.delayed(const Duration(seconds: 2));
    if (!mounted) return;
    // final flagFirst = MyLocalStorage.instance().readData<dynamic>('isFirstTime') as bool?;
    // final isFirstTime = flagFirst ?? true;
    // if (isFirstTime) {
    //   Get.offAllNamed(AppRoutes.onBoarding);
    //   return;
    // }
    // final loggedFlag = MyLocalStorage.instance().readData<dynamic>('isUserLoggedIn') as bool?;
    // final isUserLoggedIn = loggedFlag ?? false;
    // Get.offAllNamed(isUserLoggedIn ? AppRoutes.home : AppRoutes.login);
    Get.offAllNamed(AppRoutes.home);

  }
  @override
  Widget build(BuildContext context) {
    final width = MyDeviceUtils.getScreenWidth(context);
    return Scaffold(
      body: Stack(
        children: [
          const CustomBackground(),
          Center(
            child: Image.asset(
              MyImages.splashImage,
              width: width * 0.5,
              fit: BoxFit.contain,
            ),
          ),
        ],
      ),
    );
  }
}
