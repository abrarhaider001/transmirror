import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_mlkit_translation/google_mlkit_translation.dart';
import 'package:iconsax/iconsax.dart';
import 'package:transmirror/core/utils/constants/sizes.dart';
import 'package:transmirror/core/utils/popups/app_snackbar.dart';
import 'package:transmirror/core/utils/theme/widget_themes/text_field_theme.dart';
import 'package:transmirror/core/utils/translate_language_country_code.dart';
import 'package:transmirror/core/widgets/layout_app_bar.dart';
import 'package:transmirror/core/widgets/main/stt/circular_country_flag.dart';

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

    final name = _getLanguageName(language);
    if (mounted) {
      AppSnackBar.info(
        'Downloading $name model…',
        context: context,
      );
    }

    try {
      final result = await _modelManager.downloadModel(code);
      if (result && mounted) {
        setState(() {
          _downloadedModels.add(code);
        });
        AppSnackBar.success(
          '$name model downloaded successfully.',
          context: context,
        );
      } else if (mounted) {
        AppSnackBar.error(
          'Could not download the $name model.',
          context: context,
        );
      }
    } catch (e) {
      if (mounted) {
        AppSnackBar.error('Error: $e', context: context);
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

    final cs = Theme.of(context).colorScheme;
    final bool? confirm = await Get.dialog<bool>(
      AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        backgroundColor: cs.surface,
        title: Text(
          'Delete Model',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: cs.onSurface,
              ),
        ),
        content: Text(
          'Are you sure you want to delete the ${_getLanguageName(language)} translation model?',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: cs.onSurfaceVariant,
              ),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(result: false),
            child: Text(
              'Cancel',
              style: TextStyle(color: cs.onSurfaceVariant),
            ),
          ),
          TextButton(
            onPressed: () => Get.back(result: true),
            child: Text(
              'Delete',
              style: TextStyle(
                color: cs.error,
                fontWeight: FontWeight.bold,
              ),
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
        AppSnackBar.success(
          '${_getLanguageName(language)} model removed.',
          context: context,
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
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final fieldStyle = TextStyle(
      color: cs.onSurface,
      fontSize: 14,
    );
    final iconColor = cs.onSurfaceVariant;

    return Scaffold(
      backgroundColor: cs.surface,
      body: SafeArea(
        child: Column(
          children: [
            const LayoutPagesAppBar(
              title: 'Download Models',
              showTrailing: false,
            ),

            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: MySizes.defaultPagePadding,
                vertical: 10,
              ),
              child: TextField(
                controller: _searchController,
                style: fieldStyle,
                decoration: MyTextFormFieldTheme.compactInputDecoration(
                  context,
                  hintText: 'Search model...',
                  prefixIcon: Icon(
                    Iconsax.search_normal,
                    color: iconColor,
                    size: MySizes.iconSm,
                  ),
                ),
              ),
            ),

            Expanded(
              child: Scrollbar(
                thumbVisibility: true,
                child: ListView(
                  padding: const EdgeInsets.fromLTRB(
                    MySizes.defaultPagePadding,
                    0,
                    MySizes.defaultPagePadding,
                    8,
                  ),
                  children: [
                    if (_filteredLanguages.isEmpty)
                      const SizedBox.shrink()
                    else
                      Material(
                        color: cs.surfaceContainerHighest.withValues(
                          alpha: 0.55,
                        ),
                        borderRadius: BorderRadius.circular(16),
                        clipBehavior: Clip.antiAlias,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            for (var i = 0;
                                i < _filteredLanguages.length;
                                i++) ...[
                              if (i > 0)
                                Divider(
                                  height: 1,
                                  thickness: 1,
                                  color: cs.outline,
                                ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 14,
                                ),
                                child: Row(
                                  children: [
                                    CircularCountryFlag(
                                      countryCode:
                                          countryCodeForTranslateLanguage(
                                        _filteredLanguages[i],
                                      ),
                                      size: 30,
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Text(
                                        _getLanguageName(
                                          _filteredLanguages[i],
                                        ),
                                        style: theme.textTheme.bodyLarge
                                            ?.copyWith(
                                          color: cs.onSurface,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                    _buildTrailingAction(
                                      context,
                                      _filteredLanguages[i],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ],
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

  Widget _buildTrailingAction(
    BuildContext context,
    TranslateLanguage language,
  ) {
    final cs = Theme.of(context).colorScheme;
    final isDownloaded = _downloadedModels.contains(language.bcpCode);
    final isDownloading = _downloadingModels.contains(language.bcpCode);

    if (isDownloading) {
      return SizedBox(
        width: 24,
        height: 24,
        child: CircularProgressIndicator(
          strokeWidth: 2,
          color: cs.primary,
        ),
      );
    }
    if (isDownloaded) {
      return GestureDetector(
        onTap: () => _deleteModel(language),
        child: Icon(
          Iconsax.trash,
          color: cs.error,
          size: 24,
        ),
      );
    }
    return GestureDetector(
      onTap: () => _downloadModel(language),
      child: Icon(
        Iconsax.document_download,
        color: cs.primary,
        size: 24,
      ),
    );
  }
}
