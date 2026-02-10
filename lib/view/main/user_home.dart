import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:typed_data';
import 'dart:io';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:flutter/rendering.dart';
import 'package:path_provider/path_provider.dart';
import 'package:iconsax/iconsax.dart';
import 'package:logger/logger.dart';
import 'package:transmirror/core/routes/app_routes.dart';
import 'package:transmirror/core/utils/constants/colors.dart';
import 'package:transmirror/core/utils/constants/sizes.dart';
import 'package:transmirror/core/utils/local_storage/storage_utility.dart';
import 'package:transmirror/core/widgets/main/home/home_header.dart';
import 'package:transmirror/core/widgets/main/home/home_note_card.dart';
import 'package:transmirror/core/widgets/main/home/home_search_bar.dart';
import 'package:transmirror/model/user_model.dart';

import 'package:gal/gal.dart';
import 'package:transmirror/view/main/ocr/image_ocr_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  UserModel? _user;
  final _textRecognizer = TextRecognizer();
  final _logger = Logger();
  final GlobalKey _globalKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    final data = MyLocalStorage.instance().readData<dynamic>('user') as Map<String, dynamic>?;
    if (data != null) {
      _user = UserModel.fromJson(data);
    }
  }

  @override
  void dispose() {
    _textRecognizer.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final name = _user?.fullName ?? 'Guest';

    return RepaintBoundary(
      key: _globalKey,
      child: Container(
        color: Theme.of(context).scaffoldBackgroundColor,
        child: SafeArea(
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
                      onTap: () async {
                        // 1. Capture Widget (Permission-less)
                        try {
                          RenderRepaintBoundary boundary = _globalKey.currentContext!.findRenderObject() as RenderRepaintBoundary;
                          ui.Image image = await boundary.toImage(pixelRatio: 3.0);
                          ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);
                          if (byteData != null) {
                            final Uint8List pngBytes = byteData.buffer.asUint8List();
                            final tempDir = await getTemporaryDirectory();
                            final file = await File('${tempDir.path}/screenshot_${DateTime.now().millisecondsSinceEpoch}.png').create();
                            await file.writeAsBytes(pngBytes);
                            
                            // Save to Gallery
                            try {
                              await Gal.putImage(file.path);
                              _logger.i("Screenshot saved to gallery at: ${file.path}");
                            } catch (e) {
                              _logger.e("Error saving to gallery: $e");
                            }

                            // Show the captured image
                            Get.to(() => ImageOcrPage(imagePath: file.path));
                          }
                        } catch (e) {
                          _logger.e("Error capturing screen: $e");
                        }
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    )
    );
  }
}






