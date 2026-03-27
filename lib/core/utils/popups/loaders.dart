import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'app_snackbar.dart';

class MyLoaders {
  static void hideSnackBar() {
    final ctx = Get.context ?? Get.overlayContext;
    if (ctx == null) return;
    ScaffoldMessenger.of(ctx).hideCurrentSnackBar();
  }

  static void customToast({required String message}) {
    AppSnackBar.show(message);
  }

  static void successSnackBar({required String message}) {
    AppSnackBar.success(message);
  }

  static void warningSnackBar({required String message}) {
    AppSnackBar.warning(message);
  }

  static void errorSnackBar({required String message}) {
    AppSnackBar.error(message);
  }
}
