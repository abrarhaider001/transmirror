import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import 'package:share_plus/share_plus.dart';
import 'package:transmirror/core/routes/app_routes.dart';
import 'package:transmirror/core/utils/constants/text_strings.dart';
import 'package:transmirror/core/utils/local_storage/storage_utility.dart';
import 'package:transmirror/core/utils/popups/app_snackbar.dart';
import 'package:transmirror/core/widgets/custom_dialogs/delete_account_confirm_dialog.dart';
import 'package:transmirror/core/widgets/custom_dialogs/logout_confirm_dialog.dart';
import 'package:transmirror/core/widgets/main/profile/account_settings_app_bar.dart';
import 'package:transmirror/core/widgets/main/profile/profile_footer_button.dart';
import 'package:transmirror/core/widgets/main/profile/profile_identity_section.dart';
import 'package:transmirror/core/widgets/main/profile/profile_layout.dart';
import 'package:transmirror/core/widgets/main/profile/profile_primary_actions_row.dart';
import 'package:transmirror/core/widgets/main/profile/profile_section_label.dart';
import 'package:transmirror/core/widgets/main/profile/profile_social_actions_row.dart';
import 'package:transmirror/core/widgets/main/profile/profile_tile.dart';
import 'package:transmirror/core/services/launcher_shortcut_service.dart';
import 'package:transmirror/model/user_model.dart';
import 'package:transmirror/view_model/theme_mode_controller.dart';
import 'package:url_launcher/url_launcher.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});
  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  UserModel? _user;
  bool _areShortcutsEnabled = false;

  @override
  void initState() {
    super.initState();
    final data =
        MyLocalStorage.instance().readData<dynamic>('user')
            as Map<String, dynamic>?;
    if (data != null) {
      _user = UserModel.fromJson(data);
    }
    _areShortcutsEnabled = LauncherShortcutService.instance.areShortcutsEnabled;
  }

  String get _subtitle {
    final u = _user;
    if (u == null) return MyTexts.tProfileSubHeading;
    final joined = DateFormat.yMMMMd().format(u.createdAt);
    return 'Joined $joined · ${u.email}';
  }

  Future<void> _launchExternal(String url) async {
    final uri = Uri.parse(url);
    if (!await canLaunchUrl(uri)) {
      if (mounted) {
        AppSnackBar.error('Could not open link', context: context);
      }
      return;
    }
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  }

  Future<void> _shareApp() async {
    await Share.share(
      'Try Transmirror — translation and voice tools in one place.',
    );
  }

  void _showLogoutDialog() {
    showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (dialogContext) {
        return LogoutConfirmDialog(
          onConfirm: () async {
            Navigator.of(dialogContext).pop();
            try {
              final uid = FirebaseAuth.instance.currentUser?.uid;
              if (uid != null) {
                await FirebaseFirestore.instance
                    .collection('users')
                    .doc(uid)
                    .update({
                      'isOnline': false,
                      'lastActive': FieldValue.serverTimestamp(),
                    });
              }
              await FirebaseAuth.instance.signOut();
            } catch (_) {}
            await MyLocalStorage.instance().removeData('isUserLoggedIn');
            await MyLocalStorage.instance().removeData('user');
            Get.offAllNamed(AppRoutes.login);
          },
        );
      },
    );
  }

  Future<void> _deleteAccount() async {
    try {
      await FirebaseAuth.instance.currentUser?.delete();
    } on FirebaseAuthException catch (e) {
      if (!mounted) return;
      if (e.code == 'requires-recent-login') {
        AppSnackBar.error(
          'Please sign in again, then delete your account.',
          context: context,
        );
      } else {
        AppSnackBar.error(
          e.message ?? 'Could not delete account',
          context: context,
        );
      }
      return;
    } catch (e) {
      if (mounted) {
        AppSnackBar.error('Could not delete account', context: context);
      }
      return;
    }
    await MyLocalStorage.instance().removeData('isUserLoggedIn');
    await MyLocalStorage.instance().removeData('user');
    if (mounted) Get.offAllNamed(AppRoutes.login);
  }

  void _showDeleteAccountDialog() {
    showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return DeleteAccountConfirmDialog(
          onConfirm: () {
            Navigator.of(dialogContext).pop();
            _deleteAccount();
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final name = _user?.fullName ?? 'Your Name';
    final profileUrl = _user?.profileImageUrl ?? '';

    final horizontal = ProfileLayout.pagePadding(context);

    return SafeArea(
      child: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            padding: horizontal.copyWith(bottom: 24),
            child: Center(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  maxWidth: ProfileLayout.maxContentWidth,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    AccountSettingsAppBar(
                      title: MyTexts.tAccountSettings,
                      showBack: false,
                    ),
                    const SizedBox(height: 8),
                    ProfileIdentitySection(
                      displayName: name,
                      subtitle: _subtitle,
                      profileImageUrl: profileUrl,
                      showProBadge: false,
                    ),
                    const SizedBox(height: 16),
                    ProfilePrimaryActionsRow(
                      primaryLabel: MyTexts.tAddFriends,
                      onPrimaryPressed: () => Get.toNamed(AppRoutes.invite),
                      onIconPressed: _shareApp,
                    ),
                    const SizedBox(height: 24),
                    const ProfileSectionLabel('Edit Profile'),
                    ProfileTile(
                      icon: Iconsax.user,
                      label: MyTexts.tEditProfile,
                      onTap: () => AppSnackBar.info(
                        'Edit profile coming soon',
                        context: context,
                      ),
                    ),
                    ProfileTile(
                      icon: Iconsax.notification,
                      label: 'Notifications',
                      onTap: () => AppSnackBar.info(
                        'Notification settings coming soon',
                        context: context,
                      ),
                    ),
                    Builder(
                      builder: (context) {
                        final themeController = Get.find<ThemeModeController>();
                        final isDark =
                            Theme.of(context).brightness == Brightness.dark;
                        return ProfileTile(
                          icon: Iconsax.moon,
                          label: MyTexts.tDarkMode,
                          trailing: Switch.adaptive(
                            value: isDark,
                            onChanged: (value) {
                              themeController.setThemeMode(
                                value ? ThemeMode.dark : ThemeMode.light,
                              );
                            },
                          ),
                          onTap: () {
                            themeController.setThemeMode(
                              isDark ? ThemeMode.light : ThemeMode.dark,
                            );
                          },
                        );
                      },
                    ),
                    const SizedBox(height: 16),
                    ProfileTile(
                      icon: Iconsax.shopping_cart,
                      label: 'Subscription plan',
                      trailingBadge: 'Free',
                      onTap: () => Get.toNamed(AppRoutes.subscription),
                    ),
                    ProfileTile(
                      icon: Iconsax.card,
                      label: 'Wallet',
                      onTap: () => Get.toNamed(AppRoutes.wallet),
                    ),
                    ProfileTile(
                      icon: Iconsax.message_question,
                      label: 'FAQ',
                      onTap: () => Get.toNamed(AppRoutes.helpSupport),
                    ),
                    ProfileTile(
                      icon: Iconsax.document,
                      label: 'Terms of use',
                      onTap: () => Get.toNamed(AppRoutes.termsConditions),
                    ),
                    ProfileTile(
                      icon: Iconsax.shield_tick,
                      label: 'Privacy policy',
                      onTap: () => Get.toNamed(AppRoutes.privacyPolicy),
                    ),
                    ProfileTile(
                      icon: Iconsax.document_download,
                      label: 'Download language Models',
                      onTap: () => Get.toNamed(AppRoutes.downloadModels),
                    ),
                    ProfileTile(
                      icon: Iconsax.flash_1,
                      label: 'Launcher Shortcuts',
                      trailing: SizedBox(
                        height: 24,
                        width: 44,
                        child: FittedBox(
                          fit: BoxFit.contain,
                          child: Switch.adaptive(
                            value: _areShortcutsEnabled,
                            onChanged: (value) {
                              setState(() {
                                _areShortcutsEnabled = value;
                              });
                              LauncherShortcutService.instance
                                  .toggleShortcuts(value);
                            },
                          ),
                        ),
                      ),
                      onTap: () {
                        final newValue = !_areShortcutsEnabled;
                        setState(() {
                          _areShortcutsEnabled = newValue;
                        });
                        LauncherShortcutService.instance
                            .toggleShortcuts(newValue);
                      },
                    ),
                    const SizedBox(height: 20),
                    ProfileSocialActionsRow(
                      onShare: _shareApp,
                      onRate: () => _launchExternal(MyTexts.storeListingUrl),
                      onFollow: () => _launchExternal(MyTexts.socialFollowUrl),
                    ),
                    const SizedBox(height: 28),
                    ProfileFooterButton(
                      label: 'Log out',
                      onPressed: _showLogoutDialog,
                    ),
                    const SizedBox(height: 12),
                    ProfileFooterButton(
                      label: 'Delete account',
                      destructive: true,
                      onPressed: _showDeleteAccountDialog,
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
