import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:transmirror/core/utils/constants/sizes.dart';
import 'package:transmirror/core/widgets/auth/auth_button_progressive_dots.dart';
import 'package:transmirror/core/widgets/auth/auth_field_styles.dart';
import 'package:transmirror/core/utils/theme/widget_themes/button_theme.dart';
import 'package:transmirror/core/utils/theme/widget_themes/text_field_theme.dart';
import 'package:transmirror/view_model/login_controller.dart';
import 'package:transmirror/core/routes/app_routes.dart';

class LoginForm extends StatelessWidget {
  final LoginController controller;
  final String loginButtonLabel;
  final bool showLoginLeadingIcon;

  const LoginForm({
    super.key,
    required this.controller,
    this.loginButtonLabel = 'Login',
    this.showLoginLeadingIcon = true,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final fieldStyle = TextStyle(
      color: cs.onSurface,
      fontSize: 14,
    );
    final iconColor = cs.onSurfaceVariant;

    return Form(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text('Email address', style: AuthFieldStyles.labelAuth(context)),
          const SizedBox(height: 8),
          TextFormField(
            controller: controller.emailController,
            keyboardType: TextInputType.emailAddress,
            style: fieldStyle,
            decoration: MyTextFormFieldTheme.compactInputDecoration(
              context,
              hintText: 'example@email.com',
              prefixIcon: Icon(Iconsax.sms, color: iconColor, size: MySizes.iconSm),
            ),
          ),
          const SizedBox(height: 16),
          Text('Password', style: AuthFieldStyles.labelAuth(context)),
          const SizedBox(height: 8),
          Obx(
            () => TextFormField(
              controller: controller.passwordController,
              obscureText: controller.obscure.value,
              style: fieldStyle,
              decoration: MyTextFormFieldTheme.compactInputDecoration(
                context,
                hintText: '••••••••',
                prefixIcon: Icon(
                  Iconsax.lock,
                  color: iconColor,
                  size: MySizes.iconSm,
                ),
                suffixIcon: IconButton(
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
                  color: cs.primary,
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
              backgroundColor: cs.primary,
              borderColor: cs.primary,
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
                          Icon(
                            Iconsax.user,
                            color: cs.onPrimary,
                            size: MySizes.iconSm,
                          ),
                          const SizedBox(width: 8),
                        ],
                        Text(
                          loginButtonLabel,
                          style: TextStyle(
                            color: cs.onPrimary,
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
