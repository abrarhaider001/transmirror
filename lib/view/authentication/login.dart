import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:transmirror/core/routes/app_routes.dart';
import 'package:transmirror/core/widgets/custom_background.dart';
import 'package:transmirror/view_model/login_controller.dart';
import 'package:transmirror/core/widgets/auth/auth_header.dart';
import 'package:transmirror/core/widgets/auth/login_form.dart';
import 'package:transmirror/core/widgets/auth/auth_footer.dart';
 

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(LoginController());
    return Scaffold(
      body: Stack(
        children: [
          const CustomBackground(),
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 30),
                  const AuthHeader(
                    title: 'Welcome',
                    subtitle: 'Hello there, sign in to continue!',
                  ),
                  const SizedBox(height: 48),
                  LoginForm(controller: controller),
                  const SizedBox(height: 20),
                  AuthFooter(
                    text: "Don't have an account? ",
                    actionText: 'Register!',
                    onTap: () => Get.toNamed(AppRoutes.register),
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
