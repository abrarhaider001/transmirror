import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:transmirror/core/utils/constants/colors.dart';
import 'package:transmirror/view_model/forgot_password_controller.dart';
import 'package:transmirror/core/widgets/auth/auth_top_bar.dart';
import 'package:transmirror/core/widgets/custom_background.dart';
import 'package:transmirror/core/widgets/auth/auth_header.dart';
import 'package:transmirror/core/utils/theme/widget_themes/button_theme.dart';
import 'package:transmirror/core/utils/theme/widget_themes/text_field_theme.dart';
import 'package:transmirror/core/utils/theme/widget_themes/text_theme.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});
  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  @override
  Widget build(BuildContext context) {
    final c = Get.put(ForgotPasswordController());
    return Scaffold(
      body: Stack(
        children: [
          const CustomBackground(),
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
              child: Form(
                key: c.formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const AuthTopBar(),
                    const SizedBox(height: 30),
                    const AuthHeader(
                      title: 'Reset Password',
                      subtitle: 'We will email a password reset link to your account',
                    ),
                    const SizedBox(height: 38),
                    Text('Email address', style: MyTextTheme.lightTextTheme.titleLarge),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: c.emailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: MyTextFormFieldTheme.lightInputDecoration(
                        hintText: 'example123@gmail.com',
                        prefixIcon: const Icon(Icons.email_outlined, color: MyColors.primary),
                      ),
                      validator: (v) => (v == null || v.isEmpty) ? 'Required' : null,
                    ),
                    const SizedBox(height: 24),
                    Obx(
                      () => GradientElevatedButton(
                        onPressed: c.isLoading.value ? null : c.sendReset,
                        child: c.isLoading.value
                            ? const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                ),
                              )
                            : const Text(
                                'Send Reset Link',
                                style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
                              ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
