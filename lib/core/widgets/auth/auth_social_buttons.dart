import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:transmirror/core/utils/constants/image_strings.dart';
import 'package:transmirror/core/utils/constants/sizes.dart';

/// Shared sizing for auth pill buttons.
abstract final class AuthPillStyles {
  static const double radius = 28;
  static const double height = 46;
}

/// Pill (e.g. Google) — uses [ThemeData.colorScheme].
class AuthLightPillButton extends StatelessWidget {
  const AuthLightPillButton({
    super.key,
    required this.onTap,
    required this.label,
    required this.leading,
  });

  final VoidCallback onTap;
  final String label;
  final Widget leading;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Material(
      color: cs.surface,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AuthPillStyles.radius),
        side: BorderSide(color: cs.outline),
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: SizedBox(
          height: AuthPillStyles.height,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              leading,
              const SizedBox(width: 10),
              Text(
                label,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: cs.onSurface,
                      fontWeight: FontWeight.w600,
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Single Google sign-in row (login layout).
class ContinueWithGoogleButton extends StatelessWidget {
  const ContinueWithGoogleButton({super.key, required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return AuthLightPillButton(
      onTap: onTap,
      label: 'Continue with Google',
      leading: SizedBox(
        width: MySizes.iconSm,
        height: MySizes.iconSm,
        child: Image.asset(
          MyImages.googleLogo,
          fit: BoxFit.contain,
          filterQuality: FilterQuality.high,
          errorBuilder: (context, error, stackTrace) {
            return Icon(
              Iconsax.global,
              size: 28,
              color: cs.onSurface,
            );
          },
        ),
      ),
    );
  }
}

/// Google + Email options (register flow).
class AuthSocialButtons extends StatelessWidget {
  const AuthSocialButtons({
    super.key,
    required this.onGoogle,
    required this.onEmail,
  });

  final VoidCallback onGoogle;
  final VoidCallback onEmail;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ContinueWithGoogleButton(onTap: onGoogle),
        const SizedBox(height: 12),
        _OutlinedAuthButton(
          label: 'Continue with Email',
          onTap: onEmail,
          leading: Icon(
            Iconsax.sms,
            color: cs.onSurfaceVariant,
            size: 22,
          ),
        ),
      ],
    );
  }
}

class _OutlinedAuthButton extends StatelessWidget {
  const _OutlinedAuthButton({
    required this.label,
    required this.onTap,
    required this.leading,
  });

  final String label;
  final VoidCallback onTap;
  final Widget leading;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(AuthPillStyles.radius),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Ink(
          height: AuthPillStyles.height,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AuthPillStyles.radius),
            border: Border.all(color: cs.outline),
            color: Color.alphaBlend(
              cs.outline.withValues(alpha: 0.22),
              cs.surface,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              leading,
              const SizedBox(width: 10),
              Text(
                label,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: cs.onSurface,
                      fontWeight: FontWeight.w600,
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
