import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:transmirror/core/routes/app_routes.dart';
import 'package:transmirror/core/utils/constants/sizes.dart';
import 'package:transmirror/core/utils/popups/app_snackbar.dart';
import 'package:transmirror/core/widgets/auth/auth_brand_header.dart';
import 'package:transmirror/core/widgets/auth/auth_footer.dart';
import 'package:transmirror/core/widgets/auth/auth_gradient_background.dart';
import 'package:transmirror/core/widgets/auth/auth_social_buttons.dart';
import 'package:transmirror/core/widgets/auth/login_form.dart';
import 'package:transmirror/view_model/login_controller.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(LoginController());

    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: AuthGradientBackground(
        child: SafeArea(
          bottom: true,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    return SingleChildScrollView(
                      padding: const EdgeInsets.fromLTRB(24, 24, 24, 24),
                      keyboardDismissBehavior:
                          ScrollViewKeyboardDismissBehavior.onDrag,
                      child: ConstrainedBox(
                        constraints: BoxConstraints(
                          minHeight: constraints.maxHeight,
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            AuthBrandHeader(
                              title: 'Welcome',
                              subtitle: 'Sign in to continue to transmirror',
                            ),
                            const SizedBox(height: MySizes.spaceBtwSections),
                            LoginForm(
                              controller: controller,
                              loginButtonLabel: 'Login',
                              showLoginLeadingIcon: true,
                            ),
                            const SizedBox(height: MySizes.defaultSpace),
                            const _OrDivider(),
                            const SizedBox(height: MySizes.spaceBtwItems),
                            ContinueWithGoogleButton(
                              onTap: () => AppSnackBar.info(
                                'Sign in with Google is not available yet.',
                              ),
                            ),
                            const SizedBox(height: 24),
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
            ],
          ),
        ),
      ),
    );
  }
}

class _OrDivider extends StatelessWidget {
  const _OrDivider();

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final line = cs.outline;
    return Row(
      children: [
        Expanded(child: Divider(color: line, thickness: 1)),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            'Or',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: cs.onSurfaceVariant,
                  fontWeight: FontWeight.w500,
                ),
          ),
        ),
        Expanded(child: Divider(color: line, thickness: 1)),
      ],
    );
  }
}
