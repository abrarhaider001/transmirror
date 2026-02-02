import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:transmirror/core/utils/constants/colors.dart';
import 'package:transmirror/core/utils/theme/widget_themes/button_theme.dart';
import 'package:transmirror/core/utils/theme/widget_themes/text_field_theme.dart';
import 'package:transmirror/core/utils/theme/widget_themes/text_theme.dart';
import 'package:transmirror/view_model/login_controller.dart';
import 'package:transmirror/core/routes/app_routes.dart';

class LoginForm extends StatelessWidget {
  final LoginController controller;
   const LoginForm({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Form(
      key: controller.formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text('Email address', style: MyTextTheme.lightTextTheme.titleLarge),
          const SizedBox(height: 8),
          TextFormField(
            controller: controller.emailController,
            keyboardType: TextInputType.emailAddress,
            decoration: MyTextFormFieldTheme.lightInputDecoration(
              hintText: 'example123@gmail.com',
              prefixIcon: const Icon(Icons.email_outlined, color: MyColors.primary),
            ),
            validator: (v) => (v == null || v.isEmpty) ? 'Required' : null,
          ),
          const SizedBox(height: 20),
          Text('Password', style: MyTextTheme.lightTextTheme.titleLarge),
          const SizedBox(height: 8),
          Obx(
            () => TextFormField(
              controller: controller.passwordController,
              obscureText: controller.obscure.value,
              decoration: MyTextFormFieldTheme.lightInputDecoration(
                hintText: '••••••••',
                prefixIcon: const Icon(Icons.lock_outline, color: MyColors.primary),
                suffixIcon: IconButton(
                  icon: Icon(
                    controller.obscure.value ? Icons.visibility_off : Icons.visibility,
                    color: MyColors.primary,
                  ),
                  onPressed: controller.toggleObscure,
                ),
              ),
              validator: (v) => (v == null || v.isEmpty) ? 'Required' : null,
            ),
          ),
          const SizedBox(height: 12),
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: () {
                final email = controller.emailController.text.trim();
                Get.toNamed(AppRoutes.forgotPassword, arguments: {'email': email});
              },
              child: const Text('Forgot Password?', style: TextStyle(color: MyColors.primary)),
            ),
          ),
          const SizedBox(height: 18),
          Obx(
            () => GradientElevatedButton(
              onPressed: controller.isLoading.value ? null : controller.login,
              child: controller.isLoading.value
                  ? const SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                    )
                  : const Text('Login'),
            ),
          ),
        ],
      ),
    );
  }
}

