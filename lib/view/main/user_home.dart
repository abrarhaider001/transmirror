import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:flutter_overlay_window/flutter_overlay_window.dart';
import 'package:transmirror/core/routes/app_routes.dart';
import 'package:transmirror/core/utils/constants/colors.dart';
import 'package:transmirror/core/utils/constants/sizes.dart';
import 'package:transmirror/core/utils/local_storage/storage_utility.dart';
import 'package:transmirror/core/widgets/main/home/home_header.dart';
import 'package:transmirror/core/widgets/main/home/home_note_card.dart';
import 'package:transmirror/core/widgets/main/home/home_search_bar.dart';
import 'package:transmirror/model/user_model.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  UserModel? _user;

  @override
  void initState() {
    super.initState();
    final data = MyLocalStorage.instance().readData<dynamic>('user') as Map<String, dynamic>?;
    if (data != null) {
      _user = UserModel.fromJson(data);
    }
  }

  Future<void> _showOverlay() async {
    final bool? status = await FlutterOverlayWindow.isPermissionGranted();
    if (status != true) {
      final bool? granted = await FlutterOverlayWindow.requestPermission();
      if (granted != true) return;
    }
    
    await FlutterOverlayWindow.showOverlay(
      enableDrag: true,
      overlayTitle: "Extract Text",
      flag: OverlayFlag.defaultFlag,
      alignment: OverlayAlignment.center,
      visibility: NotificationVisibility.visibilityPublic,
      positionGravity: PositionGravity.auto,
      height: WindowSize.matchParent,
      width: WindowSize.matchParent,
    );
  }

  @override
  Widget build(BuildContext context) {
    final name = _user?.fullName ?? 'Guest';

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(MySizes.defaultPagePadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            HomeHeader(name: name),
            const SizedBox(height: 32),
            const HomeSearchBar(),
            const SizedBox(height: 32),
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 0.8,
                children: [
                  HomeNoteCard(
                    title: 'Text Note',
                    subtitle: 'Write and save notes instantly',
                    icon: Iconsax.note,
                    onTap: () => Get.toNamed(AppRoutes.textNote),
                  ),
                  HomeNoteCard(
                    title: 'Text to Speech',
                    subtitle: 'Turn text into clear, natural voice',
                    icon: Iconsax.text,
                    backgroundColor: const Color(0xFF6B9BFA), // Blue color from image
                    textColor: MyColors.white,
                    subtitleColor: MyColors.white.withOpacity(0.8),
                    isActive: true,
                    onTap: () => Get.toNamed(AppRoutes.textToSpeech),
                  ),
                  HomeNoteCard(
                    title: 'Speech to Text',
                    subtitle: 'Speak and convert voice to text',
                    icon: Iconsax.voice_square,
                    onTap: () => Get.toNamed(AppRoutes.speechToText),
                  ),
                  HomeNoteCard(
                    title: 'AI Response',
                    subtitle: 'Get smart, context-aware replies',
                    icon: Iconsax.magicpen, // Or similar AI icon
                    onTap: () => Get.toNamed(AppRoutes.aiResponse),
                  ),
                  HomeNoteCard(
                    title: 'Extract Text',
                    subtitle: 'Copy text from any screen',
                    icon: Iconsax.scan,
                    onTap: _showOverlay,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}






