import 'package:flutter/material.dart';
import 'package:google_mlkit_translation/google_mlkit_translation.dart';
import 'package:iconsax/iconsax.dart';
import 'package:transmirror/core/utils/translate_language_country_code.dart';
import 'package:transmirror/core/widgets/main/stt/circular_country_flag.dart';

class LanguagePickerChip extends StatelessWidget {
  final TranslateLanguage selectedLanguage;
  final ValueChanged<TranslateLanguage> onLanguageChanged;
  final String label;
  /// Optional leading widget (e.g. circular flag) shown before the language name.
  final Widget? leading;

  const LanguagePickerChip({
    super.key,
    required this.selectedLanguage,
    required this.onLanguageChanged,
    this.label = '',
    this.leading,
  });

  String _getLanguageName(TranslateLanguage language) {
    String name = language.name.toLowerCase();
    return name[0].toUpperCase() + name.substring(1);
  }

  void _showLanguagePicker(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _LanguageSelectionSheet(
        selectedLanguage: selectedLanguage,
        onLanguageSelected: onLanguageChanged,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return GestureDetector(
      onTap: () => _showLanguagePicker(context),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        decoration: BoxDecoration(
          color: cs.surfaceContainerHighest.withOpacity(0.85),
          borderRadius: BorderRadius.circular(30),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (leading != null) ...[
              leading!,
              const SizedBox(width: 8),
            ],
            if (label.isNotEmpty) ...[
              Text(
                '$label: ',
                style: TextStyle(
                  color: cs.onSurfaceVariant,
                  fontWeight: FontWeight.w500,
                  fontSize: 12,
                ),
              ),
            ],
            Flexible(
              child: Text(
                _getLanguageName(selectedLanguage),
                style: TextStyle(
                  color: cs.onSurface,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(width: 6),
            Icon(
              Iconsax.arrow_down_1,
              size: 16,
              color: cs.onSurface,
            ),
          ],
        ),
      ),
    );
  }
}

class _LanguageSelectionSheet extends StatefulWidget {
  final TranslateLanguage selectedLanguage;
  final ValueChanged<TranslateLanguage> onLanguageSelected;

  const _LanguageSelectionSheet({
    required this.selectedLanguage,
    required this.onLanguageSelected,
  });

  @override
  State<_LanguageSelectionSheet> createState() =>
      _LanguageSelectionSheetState();
}

class _LanguageSelectionSheetState extends State<_LanguageSelectionSheet> {
  final TextEditingController _searchController = TextEditingController();
  List<TranslateLanguage> _filteredLanguages = TranslateLanguage.values;

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_filterLanguages);
  }

  void _filterLanguages() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredLanguages = TranslateLanguage.values.where((lang) {
        return lang.name.toLowerCase().contains(query);
      }).toList();
    });
  }

  String _getLanguageName(TranslateLanguage language) {
    String name = language.name.toLowerCase();
    return name[0].toUpperCase() + name.substring(1);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Container(
      height: MediaQuery.of(context).size.height * 0.7, // Max height
      decoration: BoxDecoration(
        color: cs.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          // Handle bar
          Container(
            width: 40,
            height: 4,
            margin: const EdgeInsets.symmetric(vertical: 12),
            decoration: BoxDecoration(
              color: cs.outlineVariant.withOpacity(0.5),
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          // Search Field
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: TextField(
              controller: _searchController,
              style: TextStyle(color: cs.onSurface),
              decoration: InputDecoration(
                hintText: 'Search language...',
                hintStyle: TextStyle(fontSize: 14, color: cs.onSurfaceVariant),
                prefixIcon: Icon(Iconsax.search_normal, color: cs.onSurfaceVariant),
                filled: true,
                fillColor: cs.surfaceContainerHighest,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(vertical: 12),
              ),
            ),
          ),

          // List
          Expanded(
            child: ListView.builder(
              itemCount: _filteredLanguages.length,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              itemBuilder: (context, index) {
                final lang = _filteredLanguages[index];
                final isSelected = lang == widget.selectedLanguage;

                return ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 8),
                  leading: CircularCountryFlag(
                    countryCode: countryCodeForTranslateLanguage(lang),
                    size: 28,
                  ),
                  onTap: () {
                    widget.onLanguageSelected(lang);
                    Navigator.pop(context);
                  },
                  title: Text(
                    _getLanguageName(lang),
                    style: TextStyle(
                      fontWeight: isSelected
                          ? FontWeight.bold
                          : FontWeight.normal,
                      color: isSelected ? cs.primary : cs.onSurface,
                    ),
                  ),
                  trailing: isSelected
                      ? Icon(Iconsax.tick_circle, color: cs.primary)
                      : null,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  tileColor: isSelected
                      ? cs.primary.withOpacity(0.08)
                      : null,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
