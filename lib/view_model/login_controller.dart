import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:transmirror/core/routes/app_routes.dart';
import 'package:transmirror/core/utils/local_storage/storage_utility.dart';

class LoginController extends GetxController {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final obscure = true.obs;
  final isLoading = false.obs;

  void toggleObscure() => obscure.value = !obscure.value;

  /// Navigates to home without credential validation (per product flow).
  Future<void> login() async {
    if (isLoading.value) return;
    isLoading.value = true;
    try {
      await MyLocalStorage.instance().writeData('isUserLoggedIn', true);
      Get.offAllNamed(AppRoutes.home);
    } finally {
      if (!isClosed) isLoading.value = false;
    }
  }

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}
