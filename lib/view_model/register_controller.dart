import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:transmirror/services/auth_service.dart';
import 'package:transmirror/core/routes/app_routes.dart';
import 'package:transmirror/core/utils/local_storage/storage_utility.dart';
import 'package:transmirror/core/utils/exceptions/exceptions.dart';
import 'package:transmirror/core/utils/exceptions/firebase_auth_exceptions.dart';
import 'package:transmirror/core/utils/constants/colors.dart';

class RegisterController extends GetxController {
  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmController = TextEditingController();
  final nameController = TextEditingController();

  final obscure1 = true.obs;
  final obscure2 = true.obs;
  final isLoading = false.obs;
  final termsAccepted = false.obs;

  void toggleObscure1() => obscure1.value = !obscure1.value;
  void toggleObscure2() => obscure2.value = !obscure2.value;
  void toggleTerms() => termsAccepted.value = !termsAccepted.value;

  Future<void> register() async {
    if (!(formKey.currentState?.validate() ?? false)) return;
    if (!termsAccepted.value) {
      Get.snackbar(
        'Required',
        'Please accept the Terms and Conditions to proceed',
        backgroundColor: MyColors.error.withOpacity(0.5),
        colorText: Colors.white,
      );
      return;
    }
    
    isLoading.value = true;
    try {
      await AuthService.instance.signupWithEmailPassword(
        email: emailController.text.trim(),
        password: passwordController.text,
        fullName: nameController.text.trim(),
      );
      await MyLocalStorage.instance().writeData(
        'isUserLoggedIn',
        true,
      );
      Get.offAllNamed(AppRoutes.home);
    } on MyFirebaseAuthException catch (e) {
      final msg = e.message;
      Get.snackbar('Signup failed', msg, backgroundColor: MyColors.error.withOpacity(0.5));
    } on FirebaseAuthException catch (e) {
      final msg = MyExceptions.fromCode(e.code).message;
      Get.snackbar('Signup failed', msg, backgroundColor: MyColors.error.withOpacity(0.5));
    } catch (e) {
      final msg = e is MyExceptions ? e.message : const MyExceptions().message;
      Get.snackbar('Signup failed', msg, backgroundColor: MyColors.error.withOpacity(0.5));
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmController.dispose();
    super.onClose();
  }
}
