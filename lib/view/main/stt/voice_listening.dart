import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:get/get.dart';
import 'package:google_mlkit_translation/google_mlkit_translation.dart';
import 'package:iconsax/iconsax.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:transmirror/core/utils/constants/colors.dart';
import 'package:transmirror/core/widgets/layout_app_bar.dart';
import 'package:transmirror/core/widgets/widgets/stt_input_overlay.dart';
import 'package:transmirror/core/widgets/widgets/tts_mode_selector.dart';

class VoiceListeningPage extends StatefulWidget {
  const VoiceListeningPage({super.key});

  @override
  State<VoiceListeningPage> createState() => _VoiceListeningPageState();
}

class _VoiceListeningPageState extends State<VoiceListeningPage> {
  static final SpeechToText _speechToText = SpeechToText();
  final FlutterTts _flutterTts = FlutterTts();
  final TextEditingController _textController = TextEditingController();
  final OnDeviceTranslatorModelManager _modelManager =
      OnDeviceTranslatorModelManager();
  OnDeviceTranslator? _translator;

  bool _speechEnabled = false;
  bool _isRecording = false;
  final bool _isProcessing = false;
  bool _isTranslateMode = false;
  bool _isSpeaking = false;

  String _lastWords = '';
  String _translatedText = '';
  String _pendingTranslationText = '';
  bool _isTranslating = false;
  Timer? _timer;
  int _seconds = 0;

  TranslateLanguage _selectedSourceLanguage = TranslateLanguage.english;
  TranslateLanguage _selectedTargetLanguage = TranslateLanguage.urdu;

  @override
  void initState() {
    super.initState();
    _initSpeech();
    _initTts();
  }

  Future<void> _initTts() async {
    // await _flutterTts.setSharedInstance(true);
    await _flutterTts.setVolume(1.0);
    await _flutterTts.setSpeechRate(0.5);
    await _flutterTts.setPitch(1.0);

    _flutterTts.setStartHandler(() {
      setState(() => _isSpeaking = true);
    });

    _flutterTts.setCompletionHandler(() {
      setState(() => _isSpeaking = false);
    });

    _flutterTts.setErrorHandler((msg) {
      setState(() => _isSpeaking = false);
    });
  }

  /// This has to happen only once per app
  void _initSpeech() async {
    final myHash = hashCode;
    debugPrint('STT_DEBUG [$myHash]: Initializing Speech to Text...');
    
    // Check if initialized, if not initialize it
    if (!_speechToText.isAvailable) {
      _speechEnabled = await _speechToText.initialize(
        onStatus: (status) {
          debugPrint('STT_DEBUG [GLOBAL]: Status updated -> $status');
          // Handle status globally since listen() doesn't support onStatus
          if (status == 'notListening' || status == 'done') {
            if (mounted && _isRecording) {
              debugPrint('STT_DEBUG [$myHash]: Silence/Stop detected by global status. Stopping...');
              _stopRecording();
            }
          }
        },
        onError: (errorNotification) {
          debugPrint('STT_DEBUG [GLOBAL]: Error occurred -> ${errorNotification.errorMsg}');
          if (mounted) {
            _stopRecording();
          }
        },
        finalTimeout: const Duration(seconds: 2),
      );
    } else {
      _speechEnabled = true;
    }
    
    debugPrint('STT_DEBUG [$myHash]: Initialization complete. Enabled: $_speechEnabled');
    if (mounted) {
      setState(() {});
    }
  }

  void _startRecording() async {
    final myHash = hashCode;
    debugPrint('STT_DEBUG [$myHash]: Attempting to start recording...');
    
    if (!_speechEnabled) {
      debugPrint('STT_DEBUG [$myHash]: Cannot start - Speech not enabled');
      return;
    }
    
    // Stop any ongoing TTS before starting to listen
    if (_isSpeaking) {
      debugPrint('STT_DEBUG [$myHash]: Ongoing TTS detected, stopping TTS...');
      await _flutterTts.stop();
      if (mounted) setState(() => _isSpeaking = false);
    }

    _textController.clear();
    _lastWords = '';
    _translatedText = '';
    _seconds = 0;

    debugPrint('STT_DEBUG [$myHash]: Calling _speechToText.listen() with locale: ${_selectedSourceLanguage.bcpCode}');
    
    // Cancel any previous listen to clear listeners
    await _speechToText.cancel();
    await Future.delayed(const Duration(milliseconds: 100));

    await _speechToText.listen(
      onResult: (result) {
        if (!mounted) {
          debugPrint('STT_DEBUG [$myHash]: Result ignored - unmounted.');
          return;
        }
        debugPrint('STT_DEBUG [$myHash]: Result received. Final? -> ${result.finalResult}');
        _onSpeechResult(result);
        
        // Manual stop logic if silence detected by engine
        if (result.finalResult) {
           debugPrint('STT_DEBUG [$myHash]: Final result received. Stopping...');
           _stopRecording();
        }
      },
      localeId: _selectedSourceLanguage.bcpCode,
      cancelOnError: true,
      partialResults: true,
      listenMode: ListenMode.dictation,
      pauseFor: const Duration(seconds: 3),
    );

    setState(() {
      _isRecording = true;
      debugPrint('STT_DEBUG [$myHash]: UI _isRecording set to true');
    });
    _startTimer();
  }

  void _stopRecording() async {
    final myHash = hashCode;
    debugPrint('STT_DEBUG [$myHash]: _stopRecording() called. current _isRecording: $_isRecording');
    if (_isRecording) {
      debugPrint('STT_DEBUG [$myHash]: Stopping speechToText instance...');
      await _speechToText.stop();
      _stopTimer();
      if (mounted) {
        setState(() {
          _isRecording = false;
          debugPrint('STT_DEBUG [$myHash]: UI _isRecording reset to false');
        });
      }
    }
  }

  void _onSpeechResult(SpeechRecognitionResult result) {
    if (!mounted) return;

    final newWords = result.recognizedWords;
    if (newWords == _lastWords) return;

    setState(() {
      _lastWords = newWords;
      if (!_isTranslateMode) {
        _textController.text = _lastWords;
      }

      // Auto translate if in translate mode
      if (_isTranslateMode && _lastWords.isNotEmpty) {
        _handleAutoTranslate(_lastWords);
      }

      _textController.selection = TextSelection.fromPosition(
        TextPosition(offset: _textController.text.length),
      );
    });
  }

  Future<void> _handleAutoTranslate(String text) async {
    if (_isTranslating) {
      _pendingTranslationText = text;
      return;
    }

    setState(() => _isTranslating = true);

    try {
      final sourceLang = _selectedSourceLanguage;
      final targetLang = _selectedTargetLanguage;

      // Initialize translator once if languages haven't changed
      if (_translator == null) {
        // Check downloads
        if (!(await _modelManager.isModelDownloaded(sourceLang.bcpCode))) {
          await _modelManager.downloadModel(sourceLang.bcpCode);
        }
        if (!(await _modelManager.isModelDownloaded(targetLang.bcpCode))) {
          await _modelManager.downloadModel(targetLang.bcpCode);
        }

        _translator = OnDeviceTranslator(
          sourceLanguage: sourceLang,
          targetLanguage: targetLang,
        );
      }

      final translated = await _translator!.translateText(text);

      if (mounted) {
        setState(() {
          _translatedText = translated;
          _textController.text = translated;
        });
      }
    } catch (e) {
      debugPrint('Translation error: $e');
    } finally {
      if (mounted) {
        setState(() => _isTranslating = false);
        // Process pending translation if text changed while translating
        if (_pendingTranslationText.isNotEmpty &&
            _pendingTranslationText != text) {
          final nextText = _pendingTranslationText;
          _pendingTranslationText = '';
          _handleAutoTranslate(nextText);
        }
      }
    }
  }

  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _seconds++;
      });
    });
  }

  void _stopTimer() {
    _timer?.cancel();
  }

  String get _formattedTime {
    final duration = Duration(seconds: _seconds);
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return "$minutes:$seconds";
  }

  void _handleCopy() {
    if (_textController.text.isNotEmpty) {
      Clipboard.setData(ClipboardData(text: _textController.text));
    }
  }

  void _handleView() {
    if (_lastWords.isEmpty && _translatedText.isEmpty) return;

    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Extracted Text',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: MyColors.primary,
                    ),
                  ),
                  IconButton(
                    onPressed: () => Get.back(),
                    icon: const Icon(Icons.close, color: Colors.grey),
                  ),
                ],
              ),
              // const SizedBox(height: 16),
              if (_isTranslateMode) ...[
                const Text(
                  'Original:',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: MyColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  _lastWords,
                  style: const TextStyle(
                    fontSize: 14,
                    color: MyColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Translated:',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: MyColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  _translatedText,
                  style: const TextStyle(
                    fontSize: 14,
                    color: MyColors.textPrimary,
                  ),
                ),
              ] else ...[
                Text(
                  _lastWords,
                  style: const TextStyle(
                    fontSize: 14,
                    color: MyColors.textPrimary,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _handleSpeak() async {
    final textToSpeak = _isTranslateMode ? _translatedText : _lastWords;
    if (textToSpeak.isEmpty) return;

    if (_isSpeaking) {
      await _flutterTts.stop();
      setState(() => _isSpeaking = false);
    } else {
      final lang = _isTranslateMode
          ? _selectedTargetLanguage
          : _selectedSourceLanguage;
      await _flutterTts.setLanguage(lang.bcpCode);
      await _flutterTts.speak(textToSpeak);
    }
  }

  @override
  void dispose() {
    final myHash = hashCode;
    debugPrint('STT_DEBUG [$myHash]: Disposing VoiceListeningPage. Force cancelling STT...');
    _timer?.cancel();
    _speechToText.stop();
    _speechToText.cancel(); // Force release native resources
    _flutterTts.stop();
    _textController.dispose();
    _translator?.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors.softGrey,
      body: SafeArea(
        child: Column(
          children: [
            const LayoutPagesAppBar(
              title: 'Speech to Text',
              showBack: true,
              showTrailing: false,
            ),

            TTSModeSelector(
              isTranslateMode: _isTranslateMode,
              onModeChanged: (val) {
                setState(() {
                  _isTranslateMode = val;
                  _textController.clear();
                  _lastWords = '';
                  _translatedText = '';
                  _pendingTranslationText = '';
                  _translator?.close();
                  _translator = null;
                });
              },
            ),

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
                    // Action Buttons (View, Copy, Speak)
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          if (_isTranslateMode)
                            _buildActionButton(
                              icon: Iconsax.eye,
                              onTap: _handleView,
                            ),
                          const SizedBox(width: 8),
                          _buildActionButton(
                            icon: Iconsax.copy,
                            onTap: _handleCopy,
                          ),
                          const SizedBox(width: 8),
                          _buildActionButton(
                            icon: _isSpeaking
                                ? Iconsax.stop
                                : Iconsax.volume_high,
                            onTap: _handleSpeak,
                          ),
                        ],
                      ),
                    ),

                    // Text Area
                    Expanded(
                      child: TextField(
                        controller: _textController,
                        readOnly: true,
                        decoration: InputDecoration(
                          hintText: _speechEnabled
                              ? 'Tap the microphone to start speaking...'
                              : 'Speech recognition not available',
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.all(20),
                          hintStyle: const TextStyle(
                            fontSize: 14,
                            color: Colors.grey,
                          ),
                        ),
                        maxLines: null,
                        expands: true,
                        textAlignVertical: TextAlignVertical.top,
                        style: const TextStyle(
                          fontSize: 14,
                          height: 1.5,
                          color: MyColors.primary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),

                    // Input Overlay
                    STTInputOverlay(
                      isTranslateMode: _isTranslateMode,
                      sourceLanguage: _selectedSourceLanguage,
                      targetLanguage: _selectedTargetLanguage,
                      onSourceChanged: (val) {
                        setState(() {
                          _selectedSourceLanguage = val;
                          _translator?.close();
                          _translator = null;
                        });
                      },
                      onTargetChanged: (val) {
                        setState(() {
                          _selectedTargetLanguage = val;
                          _translator?.close();
                          _translator = null;
                        });
                      },
                      isRecording: _isRecording,
                      isProcessing: _isProcessing,
                      onRecordPressed: _startRecording,
                      onStopPressed: _stopRecording,
                      formattedTime: _formattedTime,
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

  Widget _buildActionButton({
    required IconData icon,
    required VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: MyColors.softGrey,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, size: 18, color: MyColors.primary),
      ),
    );
  }
}
