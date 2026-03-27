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
import 'package:transmirror/core/widgets/main/home/home_mode_toggle.dart';
import 'package:transmirror/core/widgets/main/home/home_search_bar.dart';
import 'package:transmirror/model/user_model.dart';
import 'package:transmirror/view_model/home_mode_controller.dart';

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
              HomeHeader(name: name),
              const SizedBox(height: 20),
              Obx(
                () => HomeModeToggle(
                  selected: modeController.mode.value,
                  onChanged: modeController.setMode,
                ),
              ),
              const SizedBox(height: 20),
              Expanded(
                child: Obx(() {
                  if (modeController.mode.value == AppMode.duo) {
                    return const DuoModePlaceholder();
                  }
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const HomeSearchBar(),
                      const SizedBox(height: 20),
                      Expanded(
                        child: GridView.count(
                          crossAxisCount: 2,
                          crossAxisSpacing: 16,
                          mainAxisSpacing: 16,
                          childAspectRatio: 0.82,
                          children: [
                            HomeFeatureTile(
                              title: 'Text Note',
                              subtitle: 'Write and save notes instantly',
                              icon: Iconsax.note,
                              gradientColors: const [
                                Color(0xFF8FA87A),
                                Color(0xFF6B7F5C),
                              ],
                              accentGlow: const Color(0xFF8FA87A),
                              onTap: () => Get.toNamed(AppRoutes.textNote),
                            ),
                            HomeFeatureTile(
                              title: 'Text to Speech',
                              subtitle: 'Turn text into clear, natural voice',
                              icon: Iconsax.text,
                              gradientColors: const [
                                Color(0xFF7BA8FF),
                                Color(0xFF4F7FD4),
                              ],
                              accentGlow: const Color(0xFF6B9BFA),
                              onTap: () => Get.toNamed(AppRoutes.textToSpeech),
                            ),
                            HomeFeatureTile(
                              title: 'Speech to Text',
                              subtitle: 'Speak and convert voice to text',
                              icon: Iconsax.voice_square,
                              gradientColors: const [
                                Color(0xFFA78BFA),
                                Color(0xFF7C3AED),
                              ],
                              accentGlow: const Color(0xFF8B5CF6),
                              onTap: () => Get.toNamed(AppRoutes.speechToText),
                            ),
                            HomeFeatureTile(
                              title: 'Document Viewer',
                              subtitle: 'Open and view your files and documents',
                              icon: Iconsax.document,
                              gradientColors: const [
                                Color(0xFF2DD4BF),
                                Color(0xFF0D9488),
                              ],
                              accentGlow: const Color(0xFF14B8A6),
                              onTap: () => Get.toNamed(AppRoutes.aiResponse),
                            ),
                            HomeFeatureTile(
                              title: 'Extract Text',
                              subtitle: 'Extract text from photos or gallery',
                              icon: Iconsax.scan,
                              gradientColors: const [
                                Color(0xFFFBBF24),
                                Color(0xFFEA580C),
                              ],
                              accentGlow: const Color(0xFFF59E0B),
                              onTap: () => Get.toNamed(AppRoutes.imageSelection),
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
