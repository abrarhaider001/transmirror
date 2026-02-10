import 'package:flutter/material.dart';
import 'package:google_mlkit_translation/google_mlkit_translation.dart';
import 'package:iconsax/iconsax.dart';
import 'package:transmirror/core/utils/constants/colors.dart';
import 'package:transmirror/core/widgets/layout_app_bar.dart';

class DownloadModelsPage extends StatefulWidget {
  const DownloadModelsPage({super.key});

  @override
  State<DownloadModelsPage> createState() => _DownloadModelsPageState();
}

class _DownloadModelsPageState extends State<DownloadModelsPage> {
  final OnDeviceTranslatorModelManager _modelManager =
      OnDeviceTranslatorModelManager();
  final Set<String> _downloadedModels = {};
  final Set<String> _downloadingModels = {};
  final List<TranslateLanguage> _languages = TranslateLanguage.values;

  @override
  void initState() {
    super.initState();
    _checkDownloadedModels();
  }

  Future<void> _checkDownloadedModels() async {
    final downloaded = <String>{};
    for (final language in _languages) {
      if (await _modelManager.isModelDownloaded(language.bcpCode)) {
        downloaded.add(language.bcpCode);
      }
    }
    if (mounted) {
      setState(() {
        _downloadedModels.addAll(downloaded);
      });
    }
  }

  Future<void> _downloadModel(TranslateLanguage language) async {
    final code = language.bcpCode;
    setState(() {
      _downloadingModels.add(code);
    });

    try {
      final result = await _modelManager.downloadModel(code);
      if (result && mounted) {
        setState(() {
          _downloadedModels.add(code);
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              '${_getLanguageName(language)} model downloaded successfully',
            ),
          ),
        );
      } else if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Failed to download ${_getLanguageName(language)} model',
            ),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error: $e')));
      }
    } finally {
      if (mounted) {
        setState(() {
          _downloadingModels.remove(code);
        });
      }
    }
  }

  Future<void> _deleteModel(TranslateLanguage language) async {
    final code = language.bcpCode;
    try {
      final result = await _modelManager.deleteModel(code);
      if (result && mounted) {
        setState(() {
          _downloadedModels.remove(code);
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${_getLanguageName(language)} model deleted'),
          ),
        );
      }
    } catch (e) {
      debugPrint('Error deleting model: $e');
    }
  }

  String _getLanguageName(TranslateLanguage language) {
    String name = language.name.toLowerCase();
    return name[0].toUpperCase() + name.substring(1).replaceAll('_', ' ');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors.softGrey,
      body: SafeArea(
        child: Column(
          children: [
            const LayoutPagesAppBar(title: 'Download Models'),
            Expanded(
              child: Scrollbar(
                thumbVisibility: true,
                child: ListView.builder(
                  padding: const EdgeInsets.all(20),
                  itemCount: _languages.length,
                  itemBuilder: (context, index) {
                    final language = _languages[index];
                    final isDownloaded = _downloadedModels.contains(
                      language.bcpCode,
                    );
                    final isDownloading = _downloadingModels.contains(
                      language.bcpCode,
                    );

                    return Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 16,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.02),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              _getLanguageName(language),
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: MyColors.textPrimary,
                              ),
                            ),
                          ),
                          if (isDownloading)
                            const SizedBox(
                              width: 24,
                              height: 24,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: MyColors.primary,
                              ),
                            )
                          else if (isDownloaded)
                            GestureDetector(
                              onTap: () => _deleteModel(
                                language,
                              ), // Optional: Allow deletion
                              child: const Icon(
                                Iconsax.tick_circle,
                                color: Colors.green,
                                size: 28,
                              ),
                            )
                          else
                            GestureDetector(
                              onTap: () => _downloadModel(language),
                              child: const Icon(
                                Icons.download_rounded,
                                color: MyColors.primary,
                                size: 28,
                              ),
                            ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
