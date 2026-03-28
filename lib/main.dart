import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:launcher_shortcuts/launcher_shortcuts.dart';
import 'package:logger/logger.dart';
import 'package:transmirror/core/routes/app_pages.dart';
import 'package:transmirror/core/routes/app_routes.dart';
import 'package:transmirror/core/utils/constants/colors.dart';
import 'package:transmirror/core/utils/theme/theme.dart';
import 'package:transmirror/core/utils/local_storage/storage_utility.dart';
import 'package:transmirror/firebase_options.dart';
import 'package:transmirror/view_model/home_mode_controller.dart';
import 'package:transmirror/view/overlay/resizable_overlay.dart';

Future<void> main() async {
  var logger = Logger();
  WidgetsFlutterBinding.ensureInitialized();
  await LauncherShortcuts.initialize();

  LauncherShortcuts.shortcutStream.listen((String type) async {
    if (type == 'start_recording') {
      Get.offAllNamed(AppRoutes.speechToText);
    }
  });

  if (kIsWeb) {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  } else {
    await Firebase.initializeApp();
    if (kDebugMode) {
      logger.d("Firebase initialized!!");
    }
  }

  await MyLocalStorage.init('app');
  Get.put(HomeModeController(), permanent: true);
  runApp(const MyApp());
}

@pragma("vm:entry-point")
void overlayMain() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: ResizableOverlay(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'transmirror',
      theme: MyAppTheme.lightTheme.copyWith(
        textSelectionTheme: const TextSelectionThemeData(
          cursorColor: MyColors.primary,
          selectionColor: Color(0x80368d9c),
          selectionHandleColor: MyColors.primary,
        ),
      ),
      darkTheme: MyAppTheme.darkTheme.copyWith(
        textSelectionTheme: TextSelectionThemeData(
          cursorColor: MyColors.darkLink,
          selectionColor: MyColors.darkLink.withOpacity(0.35),
          selectionHandleColor: MyColors.darkLink,
        ),
      ),
      themeMode: ThemeMode.system,
      initialRoute: AppRoutes.splash,
      getPages: AppPages.pages,
    );
  }
}
