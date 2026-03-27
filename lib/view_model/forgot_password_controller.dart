import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:transmirror/core/utils/popups/app_snackbar.dart';
import 'package:transmirror/core/routes/app_routes.dart';

class ForgotPasswordController extends GetxController {
  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final isLoading = false.obs;

  void prefillEmail() {
    final loggedInEmail = FirebaseAuth.instance.currentUser?.email;
    if (loggedInEmail != null && loggedInEmail.isNotEmpty) {
      emailController.text = loggedInEmail;
      return;
    }
    final args = Get.arguments as Map<String, dynamic>?;
    final argEmail = args?['email'] as String?;
    if (argEmail != null && argEmail.isNotEmpty) {
      emailController.text = argEmail;
    }
  }

  Future<void> sendReset() async {
    if (!(formKey.currentState?.validate() ?? false)) return;
    final email = emailController.text.trim();
    isLoading.value = true;
    try {
      final qs = await FirebaseFirestore.instance
          .collection('users')
          .where('email', isEqualTo: email)
          .limit(1)
          .get();
      if (qs.docs.isEmpty) {
        AppSnackBar.error('This email is not registered.');
        isLoading.value = false;
        return;
      }
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      AppSnackBar.success(
        'A reset link has been sent to $email. Check your inbox and spam folder.',
      );
      Get.offNamed(AppRoutes.login);
    } catch (e) {
      AppSnackBar.error('Could not send reset link: $e');
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onInit() {
    prefillEmail();
    super.onInit();
  }

  @override
  void onClose() {
    emailController.dispose();
    super.onClose();
  }
}
