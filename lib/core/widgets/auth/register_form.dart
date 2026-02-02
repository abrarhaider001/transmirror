import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:transmirror/core/utils/constants/colors.dart';
import 'package:transmirror/core/utils/theme/widget_themes/button_theme.dart';
import 'package:transmirror/core/utils/theme/widget_themes/text_field_theme.dart';
import 'package:transmirror/view_model/register_controller.dart';

class RegisterForm extends StatelessWidget {
  final RegisterController controller;
  const RegisterForm({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Form(
      key: controller.formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 20),
          Text('Full Name', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 8),
          TextFormField(
            controller: controller.nameController,
            textInputAction: TextInputAction.next,
            decoration: MyTextFormFieldTheme.lightInputDecoration(
              hintText: 'John Doe',
              prefixIcon: const Icon(
                Icons.person_outline,
                color: MyColors.primary,
              ),
            ),
            validator: (v) {
              if (v == null || v.isEmpty) return 'Required';
              if (v.length > 15) return 'Maximum 15 characters';
              return null;
            },
          ),
          const SizedBox(height: 20),
          Text('Email address', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 8),
          TextFormField(
            controller: controller.emailController,
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.next,
            decoration: MyTextFormFieldTheme.lightInputDecoration(
              hintText: 'example123@gmail.com',
              prefixIcon: const Icon(
                Icons.email_outlined,
                color: MyColors.primary,
              ),
            ),
            validator: (v) => (v == null || v.isEmpty) ? 'Required' : null,
          ),
          const SizedBox(height: 20),
          Text('Password', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 8),
          Obx(
            () => TextFormField(
              controller: controller.passwordController,
              obscureText: controller.obscure1.value,
              textInputAction: TextInputAction.next,
              decoration: MyTextFormFieldTheme.lightInputDecoration(
                hintText: '••••••••',
                prefixIcon: const Icon(
                  Icons.lock_outline,
                  color: MyColors.primary,
                ),
                suffixIcon: IconButton(
                  icon: Icon(
                    controller.obscure1.value
                        ? Icons.visibility_off
                        : Icons.visibility,
                    color: MyColors.primary,
                  ),
                  onPressed: controller.toggleObscure1,
                ),
              ),
              validator: (v) => (v == null || v.isEmpty) ? 'Required' : null,
            ),
          ),
          const SizedBox(height: 20),
          Text(
            'Confirm Password',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 8),
          Obx(
            () => TextFormField(
              controller: controller.confirmController,
              obscureText: controller.obscure2.value,
              decoration: MyTextFormFieldTheme.lightInputDecoration(
                hintText: '••••••••',
                prefixIcon: const Icon(
                  Icons.lock_outline,
                  color: MyColors.primary,
                ),
                suffixIcon: IconButton(
                  icon: Icon(
                    controller.obscure2.value
                        ? Icons.visibility_off
                        : Icons.visibility,
                    color: MyColors.primary,
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
            children: [
              Obx(
                () => SizedBox(
                  width: 24,
                  height: 24,
                  child: Checkbox(
                    value: controller.termsAccepted.value,
                    onChanged: (v) => controller.toggleTerms(),
                    activeColor: MyColors.primary,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text.rich(
                  TextSpan(
                    text: 'I agree to the ',
                    style: Theme.of(context).textTheme.bodyMedium,
                    children: [
                      TextSpan(
                        text: 'Terms & Conditions',
                        style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                              color: MyColors.primary,
                              fontWeight: FontWeight.bold,
                              decoration: TextDecoration.underline,
                              decorationColor: MyColors.primary,
                            ),
                      ),
                      const TextSpan(text: ' and '),
                      TextSpan(
                        text: 'Privacy Policy',
                        style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                              color: MyColors.primary,
                              fontWeight: FontWeight.bold,
                              decoration: TextDecoration.underline,
                              decorationColor: MyColors.primary,
                            ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 44),
          Obx(
            () => GradientElevatedButton(
              onPressed: controller.isLoading.value ? null : controller.register,
              child: controller.isLoading.value
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                  : const Text(
                      'Register',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
