import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:transmirror/core/utils/constants/colors.dart';
import 'package:transmirror/core/utils/constants/sizes.dart';
import 'package:transmirror/core/utils/theme/widget_themes/button_theme.dart';
import 'package:transmirror/core/utils/theme/widget_themes/text_field_theme.dart';
import 'package:transmirror/core/widgets/auth/auth_button_progressive_dots.dart';
import 'package:transmirror/core/widgets/auth/auth_field_styles.dart';
import 'package:transmirror/view_model/forgot_password_controller.dart';
import 'package:transmirror/core/utils/theme/theme.dart';
import 'package:transmirror/core/widgets/auth/auth_brand_header.dart';
import 'package:transmirror/core/widgets/auth/auth_gradient_background.dart';
import 'package:transmirror/core/widgets/auth/auth_top_bar.dart';

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
      backgroundColor: Colors.transparent,
      resizeToAvoidBottomInset: true,
      body: AuthGradientBackground(
        child: Theme(
          data: MyAppTheme.darkTheme.copyWith(
            scaffoldBackgroundColor: Colors.transparent,
          ),
          child: SafeArea(
            bottom: true,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Padding(
                  padding: EdgeInsets.only(left: 24, right: 24, top: 4),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: AuthTopBar(),
                  ),
                ),
                Expanded(
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      return SingleChildScrollView(
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        keyboardDismissBehavior:
                            ScrollViewKeyboardDismissBehavior.onDrag,
                        child: ConstrainedBox(
                          constraints: BoxConstraints(
                            minHeight: constraints.maxHeight,
                          ),
                          child: Form(
                            key: c.formKey,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                const AuthBrandHeader(
                                  title: 'Reset password',
                                  subtitle:
                                      'We will email a password reset link to your account.',
                                ),
                                const SizedBox(height: MySizes.spaceBtwSections),
                                Text(
                                  'Email address',
                                  style: AuthFieldStyles.labelDark(context),
                                ),
                                const SizedBox(height: 8),
                                TextFormField(
                                  controller: c.emailController,
                                  keyboardType: TextInputType.emailAddress,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 14,
                                  ),
                                  decoration:
                                      MyTextFormFieldTheme.authDarkInputDecoration(
                                    hintText: 'example123@gmail.com',
                                    prefixIcon: Icon(
                                      Iconsax.sms,
                                      color: Colors.white70,
                                      size: MySizes.iconSm,
                                    ),
                                  ),
                                  validator: (v) => (v == null || v.isEmpty)
                                      ? 'Required'
                                      : null,
                                ),
                                const SizedBox(height: MySizes.defaultSpace),
                                Obx(
                                  () => GradientElevatedButton(
                                    onPressed: c.isLoading.value
                                        ? null
                                        : c.sendReset,
                                    backgroundColor: MyColors.darkLink,
                                    borderColor: MyColors.darkLink,
                                    radius: 14,
                                    height: 44,
                                    padding: 10,
                                    child: c.isLoading.value
                                        ? const AuthButtonProgressiveDots(
                                            size: 22,
                                          )
                                        : const Text(
                                            'Send reset link',
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
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
