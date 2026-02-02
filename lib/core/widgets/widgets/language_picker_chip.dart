import 'package:flutter/material.dart';
import 'package:google_mlkit_translation/google_mlkit_translation.dart';
import 'package:iconsax/iconsax.dart';
import 'package:transmirror/core/utils/constants/colors.dart';

class LanguagePickerChip extends StatelessWidget {
  final TranslateLanguage selectedLanguage;
  final ValueChanged<TranslateLanguage> onLanguageChanged;
  final String label;

  const LanguagePickerChip({
    super.key,
    required this.selectedLanguage,
    required this.onLanguageChanged,
    this.label = '',
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
    return GestureDetector(
      onTap: () => _showLanguagePicker(context),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        decoration: BoxDecoration(
          color: MyColors.grey.withOpacity(0.3),
          borderRadius: BorderRadius.circular(30),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (label.isNotEmpty) ...[
              Text(
                '$label: ',
                style: const TextStyle(
                  color: MyColors.textSecondary,
                  fontWeight: FontWeight.w500,
                  fontSize: 12,
                ),
              ),
            ],
            Text(
              _getLanguageName(selectedLanguage),
              style: const TextStyle(
                color: MyColors.textPrimary,
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
            ),
            const SizedBox(width: 8),
            const Icon(
              Iconsax.arrow_down_1,
              size: 16,
              color: MyColors.textPrimary,
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
    return Container(
      height: MediaQuery.of(context).size.height * 0.7, // Max height
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          // Handle bar
          Container(
            width: 40,
            height: 4,
            margin: const EdgeInsets.symmetric(vertical: 12),
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          // Search Field
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search language...',
                hintStyle: TextStyle(fontSize: 14, color: Colors.grey),
                prefixIcon: const Icon(Iconsax.search_normal, color: Colors.grey,),
                filled: true,
                fillColor: MyColors.softGrey,
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
                      color: isSelected ? MyColors.primary : Colors.black87,
                    ),
                  ),
                  trailing: isSelected
                      ? const Icon(Iconsax.tick_circle, color: MyColors.primary)
                      : null,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  tileColor: isSelected
                      ? MyColors.primary.withOpacity(0.05)
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
