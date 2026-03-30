import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:transmirror/core/routes/app_routes.dart';
import 'package:transmirror/core/utils/constants/enums.dart';
import 'package:transmirror/core/utils/constants/sizes.dart';
import 'package:transmirror/core/utils/local_storage/storage_utility.dart';
import 'package:transmirror/core/widgets/main/home/duo_mode_placeholder.dart';
import 'package:transmirror/core/widgets/main/home/home_feature_tile.dart';
import 'package:transmirror/core/widgets/main/home/home_header.dart';
import 'package:transmirror/model/user_model.dart';
import 'package:transmirror/view_model/home_mode_controller.dart';
import 'package:transmirror/view_model/navbar_controller.dart';

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
    final data =
        MyLocalStorage.instance().readData<dynamic>('user')
            as Map<String, dynamic>?;
    if (data != null) {
      _user = UserModel.fromJson(data);
    }
  }

  @override
  Widget build(BuildContext context) {
    final name = _user?.fullName ?? 'Guest';
    final modeController = Get.find<HomeModeController>();

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(MySizes.defaultPagePadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Obx(
                () => HomeHeader(
                  name: name,
                  selectedMode: modeController.mode.value,
                  onModeChanged: modeController.setMode,
                  onMenuTap: () {
                    if (Get.isRegistered<NavbarController>()) {
                      Get.find<NavbarController>().changeIndex(1);
                    }
                  },
                ),
              ),
              const SizedBox(height: 20),
              Expanded(
                child: Obx(
                  () => AnimatedSwitcher(
                    duration: Duration.zero,
                    switchInCurve: Curves.easeOut,
                    switchOutCurve: Curves.easeIn,
                    child: modeController.mode.value == AppMode.duo
                        ? const DuoModePlaceholder(key: ValueKey('duo'))
                        : const _SoloGrid(key: ValueKey('solo')),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SoloGrid extends StatelessWidget {
  const _SoloGrid({super.key});

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 2,
      crossAxisSpacing: 16,
      mainAxisSpacing: 16,
      childAspectRatio: 0.82,
      children: [
        HomeFeatureTile(
          key: const ValueKey('text_note'),
          title: 'Text Note',
          subtitle: 'Write and save notes instantly',
          icon: Iconsax.note,
          onTap: () => Get.toNamed(AppRoutes.textNote),
        ),
        HomeFeatureTile(
          key: const ValueKey('text_to_speech'),
          title: 'Text to Speech',
          subtitle: 'Turn text into clear, natural voice',
          icon: Iconsax.text,
          onTap: () => Get.toNamed(AppRoutes.textToSpeech),
        ),
        HomeFeatureTile(
          key: const ValueKey('speech_to_text'),
          title: 'Speech to Text',
          subtitle: 'Speak and convert voice to text',
          icon: Iconsax.voice_square,
          onTap: () => Get.toNamed(AppRoutes.speechToText),
        ),
        HomeFeatureTile(
          key: const ValueKey('doc_viewer'),
          title: 'Document Viewer',
          subtitle: 'Open and view your files and documents',
          icon: Iconsax.document,
          onTap: () => Get.toNamed(AppRoutes.aiResponse),
        ),
        HomeFeatureTile(
          key: const ValueKey('extract_text'),
          title: 'Extract Text',
          subtitle: 'Extract text from photos or gallery',
          icon: Iconsax.scan,
          onTap: () => Get.toNamed(AppRoutes.imageSelection),
        ),
      ],
    );
  }
}
