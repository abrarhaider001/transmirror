import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:transmirror/services/auth_service.dart';
import 'package:transmirror/core/routes/app_routes.dart';
import 'package:transmirror/core/utils/local_storage/storage_utility.dart';
import 'package:transmirror/model/user_model.dart';
import 'package:transmirror/core/utils/exceptions/exceptions.dart';
import 'package:transmirror/core/utils/exceptions/firebase_auth_exceptions.dart';
import 'package:transmirror/core/utils/constants/colors.dart';

class LoginController extends GetxController {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final obscure = true.obs;
  final isLoading = false.obs;
  final formKey = GlobalKey<FormState>();

  void toggleObscure() => obscure.value = !obscure.value;

  Future<void> login() async {
    if (!(formKey.currentState?.validate() ?? false)) return;

    isLoading.value = true;
    try {
      await AuthService.instance.loginWithEmailPassword(
        email: emailController.text.trim(),
        password: passwordController.text,
      );

      final uid = FirebaseAuth.instance.currentUser!.uid;
      final snap = await FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .get();
      final data = snap.data() ?? {};
      final createdAtTs = data['createdAt'];
      final createdAt = createdAtTs is Timestamp
          ? createdAtTs.toDate()
          : DateTime.now();


      final deviceTokens =
          ((data['metadata'] as Map<String, dynamic>? ??
                          const {})['deviceTokens']
                      as List<dynamic>? ??
                  const [])
              .map((e) => e.toString())
              .toList();

      final userModel = UserModel(
        id: uid,
        fullName: (data['fullName'] as String?) ?? '',
        email: (data['email'] as String?) ?? emailController.text.trim(),
        profileImageUrl: (data['profileImageUrl'] as String?) ?? '',
        createdAt: createdAt,
        deviceTokens: deviceTokens,
      );

      await MyLocalStorage.instance().writeData('user', userModel.toJson());
      await MyLocalStorage.instance().writeData('isUserLoggedIn', true);

      Get.offAllNamed(AppRoutes.home);

    } on MyFirebaseAuthException catch (e) {
      final msg = e.message;
      Get.snackbar(
        'Login failed',
        msg,
        backgroundColor: MyColors.error.withOpacity(0.5),
      );
    } on FirebaseAuthException catch (e) {
      final msg = MyExceptions.fromCode(e.code).message;
      Get.snackbar(
        'Login failed',
        msg,
        backgroundColor: MyColors.error.withOpacity(0.5),
      );
    } catch (e) {
      final msg = e is MyExceptions ? e.message : const MyExceptions().message;
      Get.snackbar(
        'Login failed',
        msg,
        backgroundColor: MyColors.error.withOpacity(0.5),
      );
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}
