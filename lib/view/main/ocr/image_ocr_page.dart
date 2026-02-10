import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_mlkit_language_id/google_mlkit_language_id.dart';
import 'package:transmirror/core/routes/app_routes.dart';
import 'package:transmirror/core/utils/constants/colors.dart';
import 'package:transmirror/core/widgets/layout_app_bar.dart';
import 'package:transmirror/core/widgets/swipe_text_selector.dart';

class ImageOcrPage extends StatefulWidget {
  final String imagePath;
  final double? initialX;
  final double? initialY;
  final double? initialWidth;
  final double? initialHeight;

  const ImageOcrPage({
    super.key, 
    required this.imagePath,
    this.initialX,
    this.initialY,
    this.initialWidth,
    this.initialHeight,
  });

  @override
  State<ImageOcrPage> createState() => _ImageOcrPageState();
}

class _ImageOcrPageState extends State<ImageOcrPage> {
  bool _isProcessing = false;
  String? _extractedText;
  String? _detectedLanguage;

  Future<void> _handleTextSelected(String text) async {
    if (text.trim().isEmpty) return;

    setState(() {
      _isProcessing = true;
      _extractedText = text;
      _detectedLanguage = null; // Reset while identifying
    });

    try {
      // Identify Language
      final languageIdentifier = LanguageIdentifier(confidenceThreshold: 0.5);
      final String languageCode = await languageIdentifier.identifyLanguage(text);
      languageIdentifier.close();

      if (!mounted) return;
      
      setState(() {
        _detectedLanguage = languageCode;
      });
      
    } catch (e) {
      debugPrint("Error identifying language: $e");
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Error: $e")));
      }
    } finally {
      if (mounted) {
        setState(() {
          _isProcessing = false;
        });
      }
    }
  }

  String _getLanguageName(String code) {
    final Map<String, String> languages = {
      'en': 'English',
      'es': 'Spanish',
      'fr': 'French',
      'de': 'German',
      'it': 'Italian',
      'pt': 'Portuguese',
      'ru': 'Russian',
      'zh': 'Chinese',
      'ja': 'Japanese',
      'ko': 'Korean',
      'hi': 'Hindi',
      'ar': 'Arabic',
      'tr': 'Turkish',
      'nl': 'Dutch',
      'pl': 'Polish',
      'sv': 'Swedish',
      'fi': 'Finnish',
      'da': 'Danish',
      'no': 'Norwegian',
      'cs': 'Czech',
      'el': 'Greek',
      'he': 'Hebrew',
      'id': 'Indonesian',
      'ms': 'Malay',
      'th': 'Thai',
      'vi': 'Vietnamese',
      'uk': 'Ukrainian',
      'ro': 'Romanian',
      'hu': 'Hungarian',
      'und': 'Undetermined',
    };
    return languages[code] ?? code;
  }

  void _handleCopy() {
    if (_extractedText != null && _extractedText!.isNotEmpty) {
      Clipboard.setData(ClipboardData(text: _extractedText!));
    }
  }

  void _handleView() {
    if (_extractedText != null && _extractedText!.isNotEmpty) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text("Extracted Text"),
          content: SingleChildScrollView(
            child: Text(_extractedText!),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Close"),
            ),
          ],
        ),
      );
    }
  }

  void _handleSpeech() {
    if (_extractedText != null && _extractedText!.isNotEmpty) {
      Get.toNamed(
        AppRoutes.textToSpeech, 
        arguments: {
          'text': _extractedText,
          'detectedLanguage': _detectedLanguage
        }
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors.softGrey,
      body: SafeArea(
        child: Column(
          children: [
            const LayoutPagesAppBar(
              title: 'Swipe over the text to extract it',
              showBack: true,
              showTrailing: false,
            ),
            
            Expanded(
              child: Stack(
                fit: StackFit.expand,
                children: [
                  // Swipe Text Selector
                  SwipeTextSelector(
                    image: File(widget.imagePath),
                    onTextSelected: _handleTextSelected,
                    detectedLanguage: _detectedLanguage != null ? _getLanguageName(_detectedLanguage!) : null,
                    onCopyPressed: _handleCopy,
                    onSpeechPressed: _handleSpeech,
                    onViewPressed: _handleView,
                  ),
                  
                  if (_isProcessing)
                    Container(
                      color: MyColors.primaryBackground.withOpacity(0.5),
                      child: const Center(
                        child: CircularProgressIndicator(),
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
