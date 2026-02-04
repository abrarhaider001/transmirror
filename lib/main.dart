import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
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

Future<void> main() async {
  var logger = Logger();
    //firebase connection
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
  runApp(const MyApp());
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
      initialRoute: AppRoutes.splash,
      getPages: AppPages.pages,

    );
  }
}
