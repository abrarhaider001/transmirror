import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:transmirror/core/utils/constants/image_strings.dart';
import 'package:transmirror/core/utils/popups/app_snackbar.dart';
import 'package:transmirror/core/widgets/auth/auth_brand_header.dart';
import 'package:transmirror/core/widgets/auth/auth_footer.dart';
import 'package:transmirror/core/utils/theme/theme.dart';
import 'package:transmirror/core/widgets/auth/auth_gradient_background.dart';
import 'package:transmirror/core/widgets/auth/auth_legal_footer.dart';
import 'package:transmirror/core/widgets/auth/auth_social_buttons.dart';
import 'package:transmirror/core/widgets/auth/auth_top_bar.dart';
import 'package:transmirror/core/widgets/auth/register_form.dart';
import 'package:transmirror/view_model/register_controller.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  bool _showEmailForm = false;

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(RegisterController());

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
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              AuthBrandHeader(
                                logoAsset: MyImages.googleLogo,
                                title: 'Create an account',
                                subtitle:
                                    'This allows you to save your insights and personalize your journey.',
                              ),
                              const SizedBox(height: 28),
                              if (!_showEmailForm) ...[
                                AuthSocialButtons(
                                  onGoogle: () => AppSnackBar.info(
                                    'Sign up with Google is not available yet.',
                                  ),
                                  onEmail: () =>
                                      setState(() => _showEmailForm = true),
                                ),
                                const SizedBox(height: 16),
                                AuthFooter(
                                  text: 'Already have an account? ',
                                  actionText: 'Log in',
                                  onTap: () => Get.back(),
                                ),
                              ] else ...[
                                RegisterForm(
                                  controller: controller,
                                  darkAuth: true,
                                ),
                                const SizedBox(height: 8),
                                TextButton(
                                  onPressed: () =>
                                      setState(() => _showEmailForm = false),
                                  child: const Text(
                                    'Other sign-up options',
                                    style: TextStyle(
                                      color: Colors.white70,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 16),
                                AuthFooter(
                                  text: 'Already have an account? ',
                                  actionText: 'Log in',
                                  onTap: () => Get.back(),
                                ),
                              ],
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.fromLTRB(24, 8, 24, 12),
                  child: AuthLegalFooter(
                    prefix: 'By registering you agree to our ',
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
