import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:transmirror/core/utils/constants/colors.dart';
import 'package:transmirror/core/utils/theme/widget_themes/button_theme.dart';
import 'package:transmirror/core/utils/theme/widget_themes/text_field_theme.dart';
import 'package:transmirror/core/utils/theme/widget_themes/text_theme.dart';
import 'package:transmirror/view_model/login_controller.dart';
import 'package:transmirror/core/routes/app_routes.dart';

class LoginForm extends StatelessWidget {
  final LoginController controller;
  final bool darkAuth;
  final String loginButtonLabel;
  final bool showLoginLeadingIcon;

  const LoginForm({
    super.key,
    required this.controller,
    this.darkAuth = false,
    this.loginButtonLabel = 'Login',
    this.showLoginLeadingIcon = true,
  });

  TextStyle _labelStyle(BuildContext context) {
    if (darkAuth) {
      return const TextStyle(
        color: Colors.white,
        fontSize: 15,
        fontWeight: FontWeight.w600,
      );
    }
    return MyTextTheme.lightTextTheme.titleLarge!;
  }

  InputDecoration _fieldDeco({
    required String hint,
    Widget? prefix,
    Widget? suffix,
  }) {
    if (darkAuth) {
      return MyTextFormFieldTheme.authDarkInputDecoration(
        hintText: hint,
        prefixIcon: prefix,
        suffixIcon: suffix,
      );
    }
    return MyTextFormFieldTheme.lightInputDecoration(
      hintText: hint,
      prefixIcon: prefix,
      suffixIcon: suffix,
    );
  }

  @override
  Widget build(BuildContext context) {
    final iconColor = darkAuth ? Colors.white70 : MyColors.primary;

    return Form(
      key: controller.formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text('Email address', style: _labelStyle(context)),
          const SizedBox(height: 8),
          TextFormField(
            controller: controller.emailController,
            keyboardType: TextInputType.emailAddress,
            style: darkAuth ? const TextStyle(color: Colors.white) : null,
            decoration: _fieldDeco(
              hint: 'example@email.com',
              prefix: Icon(Iconsax.sms, color: iconColor),
            ),
            validator: (v) => (v == null || v.isEmpty) ? 'Required' : null,
          ),
          const SizedBox(height: 20),
          Text('Password', style: _labelStyle(context)),
          const SizedBox(height: 8),
          Obx(
            () => TextFormField(
              controller: controller.passwordController,
              obscureText: controller.obscure.value,
              style: darkAuth ? const TextStyle(color: Colors.white) : null,
              decoration: _fieldDeco(
                hint: '••••••••',
                prefix: Icon(Iconsax.lock, color: iconColor),
                suffix: IconButton(
                  icon: Icon(
                    controller.obscure.value ? Iconsax.eye_slash : Iconsax.eye,
                    color: iconColor,
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
              child: Text(
                'Forgot password?',
                style: TextStyle(
                  color: darkAuth ? MyColors.darkLink : MyColors.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
          const SizedBox(height: 18),
          Obx(
            () => GradientElevatedButton(
              onPressed: controller.isLoading.value ? null : controller.login,
              backgroundColor: darkAuth ? MyColors.darkLink : MyColors.primary,
              borderColor: darkAuth ? MyColors.darkLink : MyColors.primary,
              radius: 18,
              height: 52,
              child: controller.isLoading.value
                  ? const SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                    )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (showLoginLeadingIcon) ...[
                          const Icon(Iconsax.user, color: Colors.white, size: 22),
                          const SizedBox(width: 10),
                        ],
                        Text(
                          loginButtonLabel,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
