import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:file_selector/file_selector.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:transmirror/core/utils/constants/colors.dart';
import 'package:transmirror/core/utils/theme/widget_themes/text_theme.dart';
import 'package:transmirror/core/widgets/layout_app_bar.dart';
import 'package:transmirror/view/main/ai_response/document_viewer_page.dart';
import 'package:transmirror/view/main/ocr/image_ocr_page.dart';

class ImageSelectionPage extends StatefulWidget {
  const ImageSelectionPage({super.key});

  @override
  State<ImageSelectionPage> createState() => _ImageSelectionPageState();
}

class _ImageSelectionPageState extends State<ImageSelectionPage> {
  // -1: None, 0: Camera, 1: Gallery, 2: Files
  int _selectedIndex = -1;
  final ImagePicker _picker = ImagePicker();

  Future<void> _handleSelection() async {
    if (_selectedIndex == -1) return;

    if (_selectedIndex == 0 || _selectedIndex == 1) {
      await _pickFromCameraOrGallery();
    } else if (_selectedIndex == 2) {
      await _pickFromFiles();
    }
  }

  Future<void> _pickFromCameraOrGallery() async {
    final source =
        _selectedIndex == 0 ? ImageSource.camera : ImageSource.gallery;
    final permission = _selectedIndex == 0
        ? Permission.camera
        : (GetPlatform.isAndroid && (await _getAndroidSdkVersion()) >= 33
            ? Permission.photos
            : Permission.storage);

    PermissionStatus status = await permission.status;
    if (!status.isGranted) {
      status = await permission.request();
      if (!status.isGranted) {
        if (status.isPermanentlyDenied) {
          openAppSettings();
        }
        return;
      }
    }

    try {
      final XFile? image = await _picker.pickImage(source: source);
      if (image != null) {
        Get.to(() => ImageOcrPage(imagePath: image.path));
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to pick image: $e',
        backgroundColor: Colors.red.withOpacity(0.1),
        colorText: Colors.red,
      );
    }
  }

  Future<void> _pickFromFiles() async {
    Permission permission;
    if (GetPlatform.isAndroid && (await _getAndroidSdkVersion()) >= 33) {
      permission = Permission.photos;
    } else {
      permission = Permission.storage;
    }

    PermissionStatus status = await permission.status;
    if (!status.isGranted) {
      status = await permission.request();
      if (!status.isGranted) {
        if (status.isPermanentlyDenied) {
          openAppSettings();
        }
        return;
      }
    }

    const XTypeGroup documentGroup = XTypeGroup(
      label: 'documents',
      extensions: <String>['pdf', 'doc', 'docx'],
    );

    try {
      final XFile? file = await openFile(
        acceptedTypeGroups: const <XTypeGroup>[documentGroup],
      );

      if (file == null) {
        return;
      }

      Get.to(
        () => DocumentViewerPage(
          filePath: file.path,
          fileName: file.name,
        ),
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to pick file: $e',
        backgroundColor: Colors.red.withOpacity(0.1),
        colorText: Colors.red,
      );
    }
  }

  Future<int> _getAndroidSdkVersion() async {
    if (Platform.isAndroid) {
      final androidInfo = await DeviceInfoPlugin().androidInfo;
      return androidInfo.version.sdkInt;
    }
    return 0;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors.softGrey,
      body: SafeArea(
        child: Column(
          children: [
            const LayoutPagesAppBar(
              title: 'Select File Source',
              showBack: true,
              showTrailing: false,
            ),

            Expanded(
              child: Container(
                padding: const EdgeInsets.all(24.0),
                decoration: BoxDecoration(
                  color: MyColors.softGrey,
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildOptionCard(
                      index: 0,
                      icon: Icons.photo_camera_back_outlined,
                      title: 'Start with a photo',
                      subtitle:
                          'Snap a picture to extract text from the world around you.',
                    ),
                    const SizedBox(height: 16),
                    _buildOptionCard(
                      index: 1,
                      icon: Icons.photo_outlined,
                      title: 'Picture perfect',
                      subtitle:
                          'Try using photos from your gallery to analyse complex documents.',
                    ),
                    const SizedBox(height: 16),
                    _buildOptionCard(
                      index: 2,
                      icon: Icons.description_outlined,
                      title: 'Pick a document',
                      subtitle:
                          'Choose a PDF or Word document from your device.',
                    ),
                    const Spacer(),
                    SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: ElevatedButton(
                        onPressed: _selectedIndex != -1
                            ? _handleSelection
                            : null,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black,
                          disabledBackgroundColor: Colors.grey[300],
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          elevation: 0,
                        ),
                        child: const Text(
                          'Continue',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOptionCard({
    required int index,
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    final isSelected = _selectedIndex == index;

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedIndex = index;
        });
      },
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? Colors.black : Colors.transparent,
            width: 1,
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey[200]!),
              ),
              child: Icon(icon, color: Colors.black, size: 24),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style:
                        MyTextTheme.lightTextTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ) ??
                        const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                      height: 1.4,
                    ),
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
