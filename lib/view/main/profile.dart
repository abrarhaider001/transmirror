import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:transmirror/core/utils/constants/colors.dart';
import 'package:transmirror/core/utils/local_storage/storage_utility.dart';
import 'package:transmirror/core/widgets/layout_app_bar.dart';
import 'package:get/get.dart';
import 'package:transmirror/core/routes/app_routes.dart';
import 'package:transmirror/core/widgets/custom_dialogs/logout_confirm_dialog.dart';
import 'package:transmirror/core/widgets/main/profile/profile_header.dart';
import 'package:transmirror/model/user_model.dart';
import 'package:transmirror/core/widgets/main/profile/profile_tile.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:transmirror/core/services/launcher_shortcut_service.dart';

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

  @override
  Widget build(BuildContext context) {
    final name = _user?.fullName ?? 'Your Name';
    final email = _user?.email ?? 'you@example.com';
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            LayoutPagesAppBar(
              title: 'Profile',
              showBack: false,
              showTrailing: false,
            ),
            const SizedBox(height: 16),
            ProfileHeader(name: name, email: email),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: MyColors.lightGrey,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  const ProfileTile(
                    icon: Iconsax.user,
                    label: 'Account Settings',
                  ),
                  const SizedBox(height: 10),
                  ProfileTile(
                    icon: Iconsax.card,
                    label: 'Wallet',
                    onTap: () => Get.toNamed(AppRoutes.wallet),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: MyColors.lightGrey,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  ProfileTile(
                    icon: Icons.shortcut_outlined,
                    label: 'Launcher Shortcuts',
                    trailing: SizedBox(
                      height: 24,
                      width: 40,
                      child: Transform.scale(
                        scale: 0.8,
                        child: Switch(
                          value: _areShortcutsEnabled,
                          activeColor: MyColors.primary,
                          activeTrackColor: MyColors.grey,
                          inactiveTrackColor: MyColors.softGrey,
                          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          onChanged: (value) {
                            setState(() {
                              _areShortcutsEnabled = value;
                            });
                            LauncherShortcutService.instance.toggleShortcuts(value);
                          },
                        ),
                      ),
                    ),
                    onTap: () {
                      final newValue = !_areShortcutsEnabled;
                      setState(() {
                        _areShortcutsEnabled = newValue;
                      });
                      LauncherShortcutService.instance.toggleShortcuts(newValue);
                    },
                  ),
                  const SizedBox(height: 10),
                  ProfileTile(
                    icon: Iconsax.convert,
                    label: 'Terms & Conditions',
                    onTap: () => Get.toNamed(AppRoutes.termsConditions),
                  ),
                  const SizedBox(height: 10),
                  ProfileTile(
                    icon: Iconsax.support,
                    label: 'Help & Support',
                    onTap: () => Get.toNamed(AppRoutes.helpSupport),
                  ),
                  const SizedBox(height: 10),
                  ProfileTile(
                    icon: Iconsax.info_circle,
                    label: 'Privacy Policy',
                    onTap: () => Get.toNamed(AppRoutes.privacyPolicy),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            InkWell(
              onTap: _showLogoutDialog,
              borderRadius: BorderRadius.circular(16),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 14,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFF1F2),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  children: const [
                    Icon(Iconsax.logout, color: MyColors.red),
                    SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Logout',
                        style: TextStyle(
                          color: MyColors.red,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    Icon(Iconsax.arrow_right_3, color: MyColors.red),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showLogoutDialog() {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) {
        return LogoutConfirmDialog(
          onConfirm: () async {
            Navigator.of(context).pop();
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
}
