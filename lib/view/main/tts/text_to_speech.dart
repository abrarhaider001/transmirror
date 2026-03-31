import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:get/get.dart';
import 'package:google_mlkit_translation/google_mlkit_translation.dart';
import 'package:share_plus/share_plus.dart';
import 'package:transmirror/core/utils/constants/sizes.dart';
import 'package:transmirror/core/utils/popups/app_snackbar.dart';
import 'package:transmirror/core/widgets/main/stt/stt_rounded_card.dart';
import 'package:transmirror/core/widgets/main/stt/stt_translate_app_bar.dart';
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

  final TextEditingController _customTextController = TextEditingController();
  bool _isProcessing = false;

  bool _isTranslateMode = false;
  TranslateLanguage _selectedTargetLanguage = TranslateLanguage.urdu;
  TranslateLanguage _selectedSourceLanguage = TranslateLanguage.english;
  OnDeviceTranslator? _customTranslator;
  final OnDeviceTranslatorModelManager _modelManager =
      OnDeviceTranslatorModelManager();

  static const double _cardRadius = 26;

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
        _customTextController.text = args['text'] as String;
      }
      if (args['detectedLanguage'] != null) {
        _trySetSourceLanguage(args['detectedLanguage'] as String);
      }
    }
  }

  void _trySetSourceLanguage(String langCode) {
    try {
      final matched = TranslateLanguage.values.firstWhere(
        (l) =>
            l.bcpCode == langCode ||
            l.name.toLowerCase() == langCode.toLowerCase(),
        orElse: () => TranslateLanguage.english,
      );

      final isEnglish = langCode == 'en' || langCode.toLowerCase() == 'english';
      if (matched != TranslateLanguage.english || isEnglish) {
        setState(() {
          _selectedSourceLanguage = matched;
        });
      }
    } catch (_) {}
  }

  Future<void> _initTts() async {
    await _flutterTts.setSharedInstance(true);
    await _flutterTts
        .setIosAudioCategory(IosTextToSpeechAudioCategory.ambient, [
          IosTextToSpeechAudioCategoryOptions.allowBluetooth,
          IosTextToSpeechAudioCategoryOptions.allowBluetoothA2DP,
          IosTextToSpeechAudioCategoryOptions.mixWithOthers,
        ], IosTextToSpeechAudioMode.voicePrompt);
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
    if (_currentlyPlayingLanguage == languageCode) {
      await _flutterTts.stop();
      setState(() {
        _currentlyPlayingLanguage = null;
      });
      return;
    }

    await _flutterTts.stop();

    setState(() {
      _currentlyPlayingLanguage = languageCode;
    });

    await _flutterTts.setLanguage(languageCode);
    await _flutterTts.speak(text);
  }

  Future<void> _handleCustomAction() async {
    if (_customTextController.text.trim().isEmpty) return;

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

        final bool sourceDownloaded = await _modelManager.isModelDownloaded(
          sourceLang.bcpCode,
        );
        final bool targetDownloaded = await _modelManager.isModelDownloaded(
          targetLang.bcpCode,
        );

        if (!sourceDownloaded) {
          await _modelManager.downloadModel(sourceLang.bcpCode);
        }
        if (!targetDownloaded) {
          await _modelManager.downloadModel(targetLang.bcpCode);
        }

        _customTranslator?.close();
        _customTranslator = OnDeviceTranslator(
          sourceLanguage: sourceLang,
          targetLanguage: targetLang,
        );

        textToSpeak = await _customTranslator!.translateText(
          _customTextController.text,
        );
        languageCode = targetLang.bcpCode;
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
        AppSnackBar.error('Error: $e', context: context);
      }
    }
  }

  void _shareTypedText() {
    final t = _customTextController.text.trim();
    if (t.isEmpty) return;
    Share.share(t);
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
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return Scaffold(
      backgroundColor: cs.surface,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SttTranslateAppBar(
              title: 'Text to Speech',
              onBack: () => Navigator.of(context).pop(),
              onShare: _shareTypedText,
            ),
            TTSModeSelector(
              isTranslateMode: _isTranslateMode,
              onModeChanged: (val) {
                setState(() => _isTranslateMode = val);
              },
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(
                  MySizes.defaultPagePadding,
                  4,
                  MySizes.defaultPagePadding,
                  MySizes.lg,
                ),
                child: SttRoundedCard(
                  radius: _cardRadius,
                  padding: EdgeInsets.zero,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _customTextController,
                          maxLines: null,
                          expands: true,
                          textAlignVertical: TextAlignVertical.top,
                          style: theme.textTheme.bodyLarge?.copyWith(
                            color: cs.onSurface,
                            height: 1.45,
                            fontWeight: FontWeight.w500,
                          ),
                          decoration: InputDecoration(
                            hintText: 'Type something to speak...',
                            hintStyle: theme.textTheme.bodyMedium?.copyWith(
                              color: cs.onSurfaceVariant.withOpacity(0.85),
                            ),
                            filled: true,
                            fillColor: Colors.transparent,
                            border: InputBorder.none,
                            enabledBorder: InputBorder.none,
                            focusedBorder: InputBorder.none,
                            contentPadding: const EdgeInsets.fromLTRB(
                              18,
                              20,
                              18,
                              12,
                            ),
                          ),
                        ),
                      ),
                      TTSInputOverlay(
                        isTranslateMode: _isTranslateMode,
                        sourceLanguage: _selectedSourceLanguage,
                        targetLanguage: _selectedTargetLanguage,
                        onSourceChanged: (val) =>
                            setState(() => _selectedSourceLanguage = val),
                        onTargetChanged: (val) =>
                            setState(() => _selectedTargetLanguage = val),
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
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
