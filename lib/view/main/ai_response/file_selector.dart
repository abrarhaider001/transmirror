import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:file_selector/file_selector.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:transmirror/core/utils/constants/colors.dart';
import 'package:transmirror/core/widgets/layout_app_bar.dart';
import 'package:transmirror/view/main/ai_response/document_viewer_page.dart';

const XTypeGroup _kDocumentTypeGroup = XTypeGroup(
  label: 'documents',
  extensions: <String>['pdf'],
);

class AiResponsePage extends StatefulWidget {
  const AiResponsePage({super.key});

  @override
  State<AiResponsePage> createState() => _AiResponsePageState();
}

class _AiResponsePageState extends State<AiResponsePage> {
  final List<XFile> _documents = [];

  Future<int> _getAndroidSdkVersion() async {
    if (Platform.isAndroid) {
      final androidInfo = await DeviceInfoPlugin().androidInfo;
      return androidInfo.version.sdkInt;
    }
    return 0;
  }

  Future<bool> _ensureStoragePermission() async {
    if (!GetPlatform.isAndroid) return true;

    final sdk = await _getAndroidSdkVersion();
    final Permission permission =
        sdk >= 33 ? Permission.photos : Permission.storage;

    PermissionStatus status = await permission.status;
    if (status.isGranted) return true;

    status = await permission.request();
    if (!status.isGranted) {
      if (status.isPermanentlyDenied) {
        await openAppSettings();
      }
      debugPrint('DOC_DEBUG: Storage/photos permission not granted');
      return false;
    }

    debugPrint('DOC_DEBUG: Storage/photos permission granted');
    return true;
  }

  Future<void> _pickDocuments() async {
    final hasPermission = await _ensureStoragePermission();
    if (!hasPermission) return;

    try {
      final XFile? file = await openFile(
        acceptedTypeGroups: const <XTypeGroup>[_kDocumentTypeGroup],
      );

      if (file == null) {
        debugPrint('DOC_DEBUG: User cancelled file picker');
        return;
      }

      setState(() {
        _documents.add(file);
      });

      await _openDocument(file);
    } catch (e) {
      debugPrint('DOC_DEBUG: Error while picking document: $e');
    }
  }

  Future<void> _openDocument(XFile file) async {
    Get.to(
      () => DocumentViewerPage(
        filePath: file.path,
        fileName: file.name,
      ),
    );
  }

  IconData _getIconForFile(XFile file) {
    final name = file.name.toLowerCase();
    if (name.endsWith('.pdf')) return Icons.picture_as_pdf;
    return Icons.insert_drive_file;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors.softGrey,
      body: SafeArea(
        child: Column(
          children: [
            const LayoutPagesAppBar(title: 'Documents', showTrailing: false),
            Expanded(
              child: Container(
                margin: const EdgeInsets.fromLTRB(20, 10, 20, 20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: MyColors.primary.withOpacity(0.1),
                      blurRadius: 15,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Expanded(
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.fromLTRB(20, 20, 20, 16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Add your files',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                                color: MyColors.textPrimary,
                              ),
                            ),
                            const SizedBox(height: 4),
                            const Text(
                              'Bring in PDF documents from your device.',
                              style: TextStyle(
                                fontSize: 13,
                                color: MyColors.textSecondary,
                              ),
                            ),
                            const SizedBox(height: 16),
                            Container(
                              padding:
                                  const EdgeInsets.fromLTRB(16, 20, 16, 16),
                              decoration: BoxDecoration(
                                color: MyColors.softGrey.withOpacity(0.5),
                                borderRadius: BorderRadius.circular(18),
                                border: Border.all(
                                  color: MyColors.primary.withOpacity(0.2),
                                ),
                              ),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Container(
                                    width: 52,
                                    height: 52,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      shape: BoxShape.circle,
                                      boxShadow: [
                                        BoxShadow(
                                          color:
                                              Colors.black.withOpacity(0.04),
                                          blurRadius: 10,
                                          offset: const Offset(0, 4),
                                        ),
                                      ],
                                    ),
                                    child: const Icon(
                                      Icons.cloud_upload_outlined,
                                      color: MyColors.primary,
                                      size: 28,
                                    ),
                                  ),
                                  const SizedBox(height: 12),
                                  const Text(
                                    'Browse and open a file from this device',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 13,
                                      color: MyColors.textSecondary,
                                    ),
                                  ),
                                  const SizedBox(height: 16),
                                  SizedBox(
                                    height: 40,
                                    child: ElevatedButton(
                                      onPressed: _pickDocuments,
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: MyColors.primary,
                                        foregroundColor: Colors.white,
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 24,
                                        ),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(999),
                                        ),
                                      ),
                                      child: const Text(
                                        'Browse files',
                                        style: TextStyle(
                                          fontSize: 13,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  const Text(
                                    'Supported: PDF',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 11,
                                      color: MyColors.textSecondary,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const Divider(height: 1),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 8, 20, 4),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: const [
                          Text(
                            'Recent files',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: MyColors.textPrimary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: _documents.isEmpty
                          ? const Center(
                              child: Text(
                                'No recent files',
                                style: TextStyle(
                                  fontSize: 13,
                                  color: MyColors.textSecondary,
                                ),
                              ),
                            )
                          : ListView.separated(
                              padding: const EdgeInsets.fromLTRB(
                                  20, 4, 20, 20),
                              itemCount: _documents.length > 10
                                  ? 10
                                  : _documents.length,
                              separatorBuilder: (context, index) =>
                                  const SizedBox(height: 8),
                              itemBuilder: (context, index) {
                                final file =
                                    _documents.reversed.toList()[index];
                                return ListTile(
                                  onTap: () => _openDocument(file),
                                  leading: Container(
                                    width: 40,
                                    height: 40,
                                    decoration: BoxDecoration(
                                      color: MyColors.softGrey,
                                      borderRadius:
                                          BorderRadius.circular(12),
                                    ),
                                    child: Icon(
                                      _getIconForFile(file),
                                      color: MyColors.primary,
                                    ),
                                  ),
                                  title: Text(
                                    file.name,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      color: MyColors.textPrimary,
                                    ),
                                  ),
                                  trailing: const Icon(
                                    Icons.arrow_forward_ios,
                                    size: 14,
                                    color: MyColors.textSecondary,
                                  ),
                                );
                              },
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
}
