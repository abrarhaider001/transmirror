import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:transmirror/core/routes/app_routes.dart';
import 'package:transmirror/core/utils/constants/colors.dart';
import 'package:transmirror/core/utils/constants/image_strings.dart';
import 'package:transmirror/core/utils/popups/app_snackbar.dart';
import 'package:transmirror/core/widgets/auth/auth_brand_header.dart';
import 'package:transmirror/core/widgets/auth/auth_footer.dart';
import 'package:transmirror/core/utils/theme/theme.dart';
import 'package:transmirror/core/widgets/auth/auth_gradient_background.dart';
import 'package:transmirror/core/widgets/auth/auth_legal_footer.dart';
import 'package:transmirror/core/widgets/auth/auth_social_buttons.dart';
import 'package:transmirror/core/widgets/auth/login_form.dart';
import 'package:transmirror/view_model/login_controller.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(LoginController());

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
                                logoAsset: MyImages.logoImage,
                                title: 'Welcome',
                                subtitle: 'Sign in to continue to transmirror',
                              ),
                              const SizedBox(height: 28),
                              LoginForm(
                                controller: controller,
                                darkAuth: true,
                                loginButtonLabel: 'Login',
                                showLoginLeadingIcon: true,
                              ),
                              const SizedBox(height: 24),
                              _OrDivider(),
                              const SizedBox(height: 24),
                              ContinueWithGoogleButton(
                                onTap: () => AppSnackBar.info(
                                  'Sign in with Google is not available yet.',
                                ),
                              ),
                              const SizedBox(height: 8),
                              AuthFooter(
                                text: "Don't have an account? ",
                                actionText: 'Register',
                                onTap: () => Get.toNamed(AppRoutes.register),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.fromLTRB(24, 8, 24, 12),
                  child: AuthLegalFooter(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _OrDivider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final line = MyColors.darkOnSurfaceMuted.withOpacity(0.5);
    return Row(
      children: [
        Expanded(child: Divider(color: line, thickness: 1)),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            'Or',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: MyColors.darkOnSurfaceMuted,
                  fontWeight: FontWeight.w500,
                ),
          ),
        ),
        Expanded(child: Divider(color: line, thickness: 1)),
      ],
    );
  }
}
