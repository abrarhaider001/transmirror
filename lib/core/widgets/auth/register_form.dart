import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:transmirror/core/utils/constants/colors.dart';
import 'package:transmirror/core/utils/constants/sizes.dart';
import 'package:transmirror/core/widgets/auth/auth_button_progressive_dots.dart';
import 'package:transmirror/core/widgets/auth/auth_field_styles.dart';
import 'package:transmirror/core/utils/theme/widget_themes/button_theme.dart';
import 'package:transmirror/core/utils/theme/widget_themes/text_field_theme.dart';
import 'package:transmirror/view_model/register_controller.dart';

class RegisterForm extends StatelessWidget {
  final RegisterController controller;
  final bool darkAuth;

  const RegisterForm({
    super.key,
    required this.controller,
    this.darkAuth = false,
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
    final linkAccent = darkAuth ? MyColors.darkLink : MyColors.primary;

    return Form(
      key: controller.formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text('Full Name', style: _labelStyle(context)),
          const SizedBox(height: 8),
          TextFormField(
            controller: controller.nameController,
            textInputAction: TextInputAction.next,
            style: darkAuth
                ? const TextStyle(color: Colors.white, fontSize: 14)
                : const TextStyle(fontSize: 14),
            decoration: _fieldDeco(
              hint: 'John Doe',
              prefix: Icon(Iconsax.user, color: iconColor, size: MySizes.iconSm),
            ),
            validator: (v) {
              if (v == null || v.isEmpty) return 'Required';
              if (v.length > 15) return 'Maximum 15 characters';
              return null;
            },
          ),
          const SizedBox(height: 16),
          Text('Email address', style: _labelStyle(context)),
          const SizedBox(height: 8),
          TextFormField(
            controller: controller.emailController,
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.next,
            style: darkAuth
                ? const TextStyle(color: Colors.white, fontSize: 14)
                : const TextStyle(fontSize: 14),
            decoration: _fieldDeco(
              hint: 'example123@gmail.com',
              prefix: Icon(Iconsax.sms, color: iconColor, size: MySizes.iconSm),
            ),
            validator: (v) => (v == null || v.isEmpty) ? 'Required' : null,
          ),
          const SizedBox(height: 16),
          Text('Password', style: _labelStyle(context)),
          const SizedBox(height: 8),
          Obx(
            () => TextFormField(
              controller: controller.passwordController,
              obscureText: controller.obscure1.value,
              textInputAction: TextInputAction.next,
              style: darkAuth
                  ? const TextStyle(color: Colors.white, fontSize: 14)
                  : const TextStyle(fontSize: 14),
              decoration: _fieldDeco(
                hint: '••••••••',
                prefix: Icon(Iconsax.lock, color: iconColor, size: MySizes.iconSm),
                suffix: IconButton(
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(
                    minWidth: 40,
                    minHeight: 36,
                  ),
                  icon: Icon(
                    controller.obscure1.value ? Iconsax.eye_slash : Iconsax.eye,
                    color: iconColor,
                    size: MySizes.iconSm,
                  ),
                  onPressed: controller.toggleObscure1,
                ),
              ),
              validator: (v) => (v == null || v.isEmpty) ? 'Required' : null,
            ),
          ),
          const SizedBox(height: 16),
          Text('Confirm Password', style: _labelStyle(context)),
          const SizedBox(height: 8),
          Obx(
            () => TextFormField(
              controller: controller.confirmController,
              obscureText: controller.obscure2.value,
              style: darkAuth
                  ? const TextStyle(color: Colors.white, fontSize: 14)
                  : const TextStyle(fontSize: 14),
              decoration: _fieldDeco(
                hint: '••••••••',
                prefix: Icon(Iconsax.lock, color: iconColor, size: MySizes.iconSm),
                suffix: IconButton(
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(
                    minWidth: 40,
                    minHeight: 36,
                  ),
                  icon: Icon(
                    controller.obscure2.value ? Iconsax.eye_slash : Iconsax.eye,
                    color: iconColor,
                    size: MySizes.iconSm,
                  ),
                  onPressed: controller.toggleObscure2,
                ),
              ),
              validator: (v) => (v == null || v.isEmpty)
                  ? 'Required'
                  : (controller.passwordController.text != v)
                  ? 'Passwords do not match'
                  : null,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Obx(
                () => SizedBox(
                  width: 24,
                  height: 24,
                  child: Checkbox(
                    value: controller.termsAccepted.value,
                    onChanged: (v) => controller.toggleTerms(),
                    activeColor: linkAccent,
                    checkColor: Colors.white,
                    side: BorderSide(color: linkAccent.withOpacity(0.8)),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text.rich(
                  TextSpan(
                    text: 'I agree to the ',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: darkAuth ? Colors.white70 : null,
                    ),
                    children: [
                      TextSpan(
                        text: 'Terms & Conditions',
                        style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                          color: linkAccent,
                          fontWeight: FontWeight.bold,
                          decoration: TextDecoration.underline,
                          decorationColor: linkAccent,
                        ),
                      ),
                      const TextSpan(text: ' and '),
                      TextSpan(
                        text: 'Privacy Policy',
                        style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                          color: linkAccent,
                          fontWeight: FontWeight.bold,
                          decoration: TextDecoration.underline,
                          decorationColor: linkAccent,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 36),
          Obx(
            () => GradientElevatedButton(
              onPressed: controller.isLoading.value
                  ? null
                  : controller.register,
              backgroundColor: darkAuth ? MyColors.darkLink : MyColors.primary,
              borderColor: darkAuth ? MyColors.darkLink : MyColors.primary,
              radius: 14,
              height: 44,
              padding: 10,
              child: controller.isLoading.value
                  ? const AuthButtonProgressiveDots(size: 22)
                  : const Text(
                      'Create account',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 15,
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
