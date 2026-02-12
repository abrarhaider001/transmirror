import 'package:flutter/material.dart';
import 'package:get/get.dart';
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
  
  final TextEditingController _searchController = TextEditingController();
  List<TranslateLanguage> _filteredLanguages = [];

  @override
  void initState() {
    super.initState();
    _filteredLanguages = _languages;
    _searchController.addListener(_filterLanguages);
    _loadModels();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _filterLanguages() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredLanguages = _languages.where((lang) {
        return _getLanguageName(lang).toLowerCase().contains(query);
      }).toList();
    });
  }

  Future<void> _loadModels() async {
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
    
    // Show confirmation dialog
    final bool? confirm = await Get.dialog<bool>(
      AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text(
          'Delete Model',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        content: Text(
          'Are you sure you want to delete the ${_getLanguageName(language)} translation model?',
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(result: false),
            child: const Text(
              'Cancel',
              style: TextStyle(color: MyColors.textSecondary),
            ),
          ),
          TextButton(
            onPressed: () => Get.back(result: true),
            child: const Text(
              'Delete',
              style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );

    if (confirm != true) return;

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
            const LayoutPagesAppBar(title: 'Download Models', showTrailing: false),
            
            // Search Field
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: 'Search model...',
                  hintStyle: const TextStyle(fontSize: 14, color: Colors.grey),
                  prefixIcon: const Icon(Iconsax.search_normal, color: Colors.grey,),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.symmetric(vertical: 12),
                ),
              ),
            ),

            Expanded(
              child: Scrollbar(
                thumbVisibility: true,
                child: ListView.builder(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 8),
                  itemCount: _filteredLanguages.length,
                  itemBuilder: (context, index) {
                    final language = _filteredLanguages[index];
                    final isDownloaded = _downloadedModels.contains(
                      language.bcpCode,
                    );
                    final isDownloading = _downloadingModels.contains(
                      language.bcpCode,
                    );

                    return Container(
                      margin: const EdgeInsets.only(bottom: 1),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 16,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        // borderRadius: BorderRadius.circular(20),
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
                                fontSize: 14,
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
                                Iconsax.trash,
                                color: Colors.red,
                                size: 24,
                              ),
                            )
                          else
                            GestureDetector(
                              onTap: () => _downloadModel(language),
                              child: const Icon(
                                Icons.downloading_sharp,
                                color: MyColors.primary,
                                size: 24,
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
