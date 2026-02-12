import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:get/get.dart';
import 'package:google_mlkit_translation/google_mlkit_translation.dart';
import 'package:transmirror/core/utils/constants/colors.dart';
import 'package:transmirror/core/widgets/layout_app_bar.dart';
import 'package:transmirror/core/widgets/widgets/tts_input_overlay.dart';
import 'package:transmirror/core/widgets/widgets/tts_mode_selector.dart';

class TextToSpeechPage extends StatefulWidget {
  const TextToSpeechPage({super.key});

  @override
  State<TextToSpeechPage> createState() => _TextToSpeechPageState();
}

class _TextToSpeechPageState extends State<TextToSpeechPage> {
  final FlutterTts _flutterTts = FlutterTts();
  String? _currentlyPlayingLanguage;

  // Translation related
  final TextEditingController _customTextController = TextEditingController();
  bool _isProcessing = false;

  bool _isTranslateMode = false;
  TranslateLanguage _selectedTargetLanguage = TranslateLanguage.urdu;
  TranslateLanguage _selectedSourceLanguage = TranslateLanguage.english;
  OnDeviceTranslator? _customTranslator;
  final OnDeviceTranslatorModelManager _modelManager = OnDeviceTranslatorModelManager();
  
  @override
  void initState() {
    super.initState();
    _initTts();
    _handleArguments();
  }

  void _handleArguments() {
    final args = Get.arguments;
    if (args is Map) {
      if (args['text'] != null) {
        _customTextController.text = args['text'];
      }
      if (args['detectedLanguage'] != null) {
        _trySetSourceLanguage(args['detectedLanguage']);
      }
    }
  }

  void _trySetSourceLanguage(String langCode) {
     // Try to find matching TranslateLanguage
     try {
       // Check against bcpCode or name
       final matched = TranslateLanguage.values.firstWhere(
         (l) => l.bcpCode == langCode || l.name.toLowerCase() == langCode.toLowerCase(), 
         orElse: () => TranslateLanguage.english
       );
       // If we found a match (and it wasn't just the default 'english' fallback unless the input was actually english)
       // Actually firstWhere with orElse returns english if not found.
       // We can check if langCode matches english properties.
       
       bool isEnglish = langCode == 'en' || langCode.toLowerCase() == 'english';
       if (matched != TranslateLanguage.english || isEnglish) {
          setState(() {
            _selectedSourceLanguage = matched;
          });
       }
     } catch (_) {}
  }

  Future<void> _initTts() async {
    await _flutterTts.setSharedInstance(true);
    await _flutterTts.setIosAudioCategory(
        IosTextToSpeechAudioCategory.ambient,
        [
          IosTextToSpeechAudioCategoryOptions.allowBluetooth,
          IosTextToSpeechAudioCategoryOptions.allowBluetoothA2DP,
          IosTextToSpeechAudioCategoryOptions.mixWithOthers
        ],
        IosTextToSpeechAudioMode.voicePrompt);
    await _flutterTts.awaitSpeakCompletion(true);
    await _flutterTts.setVolume(1.0);
    await _flutterTts.setSpeechRate(0.5);
    await _flutterTts.setPitch(1.0);

    _flutterTts.setStartHandler(() {
      setState(() {});
    });

    _flutterTts.setCompletionHandler(() {
      setState(() {
        _currentlyPlayingLanguage = null;
      });
    });

    _flutterTts.setErrorHandler((msg) {
      setState(() {
        _currentlyPlayingLanguage = null;
      });
    });
  }

  Future<void> _speak(String text, String languageCode) async {
    // If currently playing this language, stop it
    if (_currentlyPlayingLanguage == languageCode) {
      await _flutterTts.stop();
      setState(() {
        _currentlyPlayingLanguage = null;
      });
      return;
    }

    // Stop any other playing
    await _flutterTts.stop();

    setState(() {
      _currentlyPlayingLanguage = languageCode;
    });

    // Try to map language code if possible, else rely on BCP code
    await _flutterTts.setLanguage(languageCode);
    await _flutterTts.speak(text);
  }

  Future<void> _handleCustomAction() async {
    if (_customTextController.text.trim().isEmpty) return;

    // Hide keyboard
    FocusScope.of(context).unfocus();

    setState(() {
      _isProcessing = true;
    });

    try {
      String textToSpeak = _customTextController.text;
      String languageCode = _selectedSourceLanguage.bcpCode;

      if (_isTranslateMode) {
        final sourceLang = _selectedSourceLanguage;
        final targetLang = _selectedTargetLanguage;

        // Check downloads
        final bool sourceDownloaded = await _modelManager.isModelDownloaded(sourceLang.bcpCode);
        final bool targetDownloaded = await _modelManager.isModelDownloaded(targetLang.bcpCode);

        if (!sourceDownloaded) {
          await _modelManager.downloadModel(sourceLang.bcpCode);
        }
        if (!targetDownloaded) {
          await _modelManager.downloadModel(targetLang.bcpCode);
        }

        // Create translator if needed
        _customTranslator?.close();
        _customTranslator = OnDeviceTranslator(
          sourceLanguage: sourceLang,
          targetLanguage: targetLang,
        );

        textToSpeak = await _customTranslator!.translateText(_customTextController.text);
        languageCode = targetLang.bcpCode; // Use BCP code for TTS
      }

      await _speak(textToSpeak, languageCode);

      setState(() {
        _isProcessing = false;
      });
    } catch (e) {
      setState(() {
        _isProcessing = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
      }
    }
  }

  @override
  void dispose() {
    _flutterTts.stop();
    _customTextController.dispose();
    _customTranslator?.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors.softGrey,
      body: SafeArea(
        child: Column(
          children: [
            //Appbar
            LayoutPagesAppBar(
              title: 'Text to Speech',
            ),
            
            // Mode Selector
            TTSModeSelector(
              isTranslateMode: _isTranslateMode,
              onModeChanged: (val) {
                setState(() => _isTranslateMode = val);
              },
            ),
        
            // Input Area with Overlay
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
                child: Stack(
                  children: [
                    TextField(
                      controller: _customTextController,
                      decoration: const InputDecoration(
                        hintText: 'Type something to speak...',
                        border: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        disabledBorder: InputBorder.none,
                        errorBorder: InputBorder.none,
                        focusedErrorBorder: InputBorder.none,
                        contentPadding: EdgeInsets.fromLTRB(20, 24, 20, 100),
                        hintStyle: TextStyle(fontSize: 14, color: Colors.grey),
                      ),
                      maxLines: null,
                      expands: true,
                      textAlignVertical: TextAlignVertical.top,
                      style: const TextStyle(
                        fontSize: 12,
                        height: 1.5,
                        color: MyColors.primary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Positioned(
                      left: 0,
                      right: 0,
                      bottom: 0,
                      child: TTSInputOverlay(
                        isTranslateMode: _isTranslateMode,
                        sourceLanguage: _selectedSourceLanguage,
                        targetLanguage: _selectedTargetLanguage,
                        onSourceChanged: (val) => setState(() => _selectedSourceLanguage = val),
                        onTargetChanged: (val) => setState(() => _selectedTargetLanguage = val),
                        isPlaying: _currentlyPlayingLanguage != null,
                        isProcessing: _isProcessing,
                        onActionPressed: _handleCustomAction,
                        onStopPressed: () async {
                          await _flutterTts.stop();
                          setState(() {
                            _currentlyPlayingLanguage = null;
                            _isProcessing = false;
                          });
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
