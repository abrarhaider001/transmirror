import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:transmirror/core/utils/constants/colors.dart';
import 'package:transmirror/core/utils/constants/sizes.dart';
import 'package:transmirror/core/widgets/auth/auth_button_progressive_dots.dart';
import 'package:transmirror/core/widgets/auth/auth_field_styles.dart';
import 'package:transmirror/core/utils/theme/widget_themes/button_theme.dart';
import 'package:transmirror/core/utils/theme/widget_themes/text_field_theme.dart';
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
      return AuthFieldStyles.labelDark(context);
    }
    return Theme.of(context).textTheme.titleLarge!;
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text('Email address', style: _labelStyle(context)),
          const SizedBox(height: 8),
          TextFormField(
            controller: controller.emailController,
            keyboardType: TextInputType.emailAddress,
            style: darkAuth
                ? const TextStyle(color: Colors.white, fontSize: 14)
                : const TextStyle(fontSize: 14),
            decoration: _fieldDeco(
              hint: 'example@email.com',
              prefix: Icon(Iconsax.sms, color: iconColor, size: MySizes.iconSm),
            ),
          ),
          const SizedBox(height: 16),
          Text('Password', style: _labelStyle(context)),
          const SizedBox(height: 8),
          Obx(
            () => TextFormField(
              controller: controller.passwordController,
              obscureText: controller.obscure.value,
              style: darkAuth
                  ? const TextStyle(color: Colors.white, fontSize: 14)
                  : const TextStyle(fontSize: 14),
              decoration: _fieldDeco(
                hint: '••••••••',
                prefix: Icon(
                  Iconsax.lock,
                  color: iconColor,
                  size: MySizes.iconSm,
                ),
                suffix: IconButton(
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(
                    minWidth: 40,
                    minHeight: 36,
                  ),
                  icon: Icon(
                    controller.obscure.value ? Iconsax.eye_slash : Iconsax.eye,
                    color: iconColor,
                    size: MySizes.iconSm,
                  ),
                  onPressed: controller.toggleObscure,
                ),
              ),
            ),
          ),
          const SizedBox(height: 10),
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: () {
                final email = controller.emailController.text.trim();
                Get.toNamed(
                  AppRoutes.forgotPassword,
                  arguments: {'email': email},
                );
              },
              child: Text(
                'Forgot password?',
                style: TextStyle(
                  color: darkAuth ? MyColors.darkLink : MyColors.primary,
                  fontWeight: FontWeight.w600,
                  fontSize: MySizes.fontSizeXs,
                ),
              ),
            ),
          ),
          const SizedBox(height: 10),
          Obx(
            () => GradientElevatedButton(
              onPressed: controller.isLoading.value ? null : controller.login,
              backgroundColor: darkAuth ? MyColors.darkLink : MyColors.primary,
              borderColor: darkAuth ? MyColors.darkLink : MyColors.primary,
              radius: 14,
              height: 44,
              padding: 10,
              child: controller.isLoading.value
                  ? const AuthButtonProgressiveDots(size: 22)
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (showLoginLeadingIcon) ...[
                          const Icon(
                            Iconsax.user,
                            color: Colors.white,
                            size: MySizes.iconSm,
                          ),
                          const SizedBox(width: 8),
                        ],
                        Text(
                          loginButtonLabel,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            fontSize: 15,
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
