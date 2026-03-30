import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:get/get.dart';
import 'package:google_mlkit_translation/google_mlkit_translation.dart';
import 'package:iconsax/iconsax.dart';
import 'package:share_plus/share_plus.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:transmirror/core/utils/constants/sizes.dart';
import 'package:transmirror/core/widgets/main/stt/stt_recommended_section.dart';
import 'package:transmirror/core/widgets/main/stt/stt_speak_freely_panel.dart';
import 'package:transmirror/core/widgets/main/stt/stt_translate_app_bar.dart';
import 'package:transmirror/core/widgets/main/stt/stt_translate_cards_stack.dart';
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

  final ScrollController _scrollController = ScrollController();

  bool _speechEnabled = false;
  bool _isRecording = false;
  bool _isTranslateMode = false;
  bool _isSpeaking = false;

  String _lastWords = '';
  String _translatedText = '';
  String _pendingTranslationText = '';
  bool _isTranslating = false;
  Timer? _timer;
  int _seconds = 0;

  bool _scrollbarVisible = false;
  Timer? _scrollbarHideTimer;

  TranslateLanguage _selectedSourceLanguage = TranslateLanguage.english;
  TranslateLanguage _selectedTargetLanguage = TranslateLanguage.urdu;

  static const double _cardRadius = 26;

  @override
  void initState() {
    super.initState();
    _initSpeech();
    _initTts();
  }

  Future<void> _initTts() async {
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

  void _initSpeech() async {
    final myHash = hashCode;
    debugPrint('STT_DEBUG [$myHash]: Initializing Speech to Text...');

    if (!_speechToText.isAvailable) {
      _speechEnabled = await _speechToText.initialize(
        onStatus: (status) {
          debugPrint('STT_DEBUG [GLOBAL]: Status updated -> $status');
          if (status == 'notListening' || status == 'done') {
            if (mounted && _isRecording) {
              debugPrint(
                'STT_DEBUG [$myHash]: Silence/Stop detected by global status. Stopping...',
              );
              _stopRecording();
            }
          }
        },
        onError: (errorNotification) {
          debugPrint(
            'STT_DEBUG [GLOBAL]: Error occurred -> ${errorNotification.errorMsg}',
          );
          if (mounted) {
            _stopRecording();
          }
        },
        finalTimeout: const Duration(seconds: 2),
      );
    } else {
      _speechEnabled = true;
    }

    debugPrint(
      'STT_DEBUG [$myHash]: Initialization complete. Enabled: $_speechEnabled',
    );
    if (mounted) {
      setState(() {});
    }
  }

  void _flashScrollbar() {
    setState(() => _scrollbarVisible = true);
    _scrollbarHideTimer?.cancel();
    _scrollbarHideTimer = Timer(const Duration(milliseconds: 900), () {
      if (mounted) setState(() => _scrollbarVisible = false);
    });
  }

  void _startRecording() async {
    final myHash = hashCode;
    debugPrint('STT_DEBUG [$myHash]: Attempting to start recording...');

    if (!_speechEnabled) {
      debugPrint('STT_DEBUG [$myHash]: Cannot start - Speech not enabled');
      return;
    }

    if (_isSpeaking) {
      debugPrint('STT_DEBUG [$myHash]: Ongoing TTS detected, stopping TTS...');
      await _flutterTts.stop();
      if (mounted) setState(() => _isSpeaking = false);
    }

    _textController.clear();
    _lastWords = '';
    _translatedText = '';
    _seconds = 0;

    debugPrint(
      'STT_DEBUG [$myHash]: Calling _speechToText.listen() with locale: ${_selectedSourceLanguage.bcpCode}',
    );

    await _speechToText.cancel();
    await Future.delayed(const Duration(milliseconds: 100));

    await _speechToText.listen(
      onResult: (result) {
        if (!mounted) {
          debugPrint('STT_DEBUG [$myHash]: Result ignored - unmounted.');
          return;
        }
        debugPrint(
          'STT_DEBUG [$myHash]: Result received. Final? -> ${result.finalResult}',
        );
        _onSpeechResult(result);

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
    debugPrint(
      'STT_DEBUG [$myHash]: _stopRecording() called. current _isRecording: $_isRecording',
    );
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

      if (_translator == null) {
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
    return '$minutes:$seconds';
  }

  void _handleCopy() {
    final text = _isTranslateMode ? _translatedText : _lastWords;
    if (text.isNotEmpty) {
      Clipboard.setData(ClipboardData(text: text));
    }
  }

  void _handleView() {
    if (_lastWords.isEmpty && _translatedText.isEmpty) return;

    final cs = Theme.of(context).colorScheme;
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
                  Text(
                    'Extracted Text',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: cs.primary,
                    ),
                  ),
                  IconButton(
                    onPressed: () => Get.back(),
                    icon: Icon(
                      Iconsax.close_circle,
                      color: cs.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
              if (_isTranslateMode) ...[
                Text(
                  'Original:',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: cs.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  _lastWords,
                  style: TextStyle(fontSize: 14, color: cs.onSurface),
                ),
                const SizedBox(height: 16),
                Text(
                  'Translated:',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: cs.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  _translatedText,
                  style: TextStyle(fontSize: 14, color: cs.onSurface),
                ),
              ] else ...[
                Text(
                  _lastWords,
                  style: TextStyle(fontSize: 14, color: cs.onSurface),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _handleSpeak({required bool useTarget}) async {
    final textToSpeak = useTarget && _isTranslateMode
        ? _translatedText
        : _lastWords;
    if (textToSpeak.isEmpty) return;

    if (_isSpeaking) {
      await _flutterTts.stop();
      setState(() => _isSpeaking = false);
    } else {
      final lang = useTarget && _isTranslateMode
          ? _selectedTargetLanguage
          : _selectedSourceLanguage;
      await _flutterTts.setLanguage(lang.bcpCode);
      await _flutterTts.speak(textToSpeak);
    }
  }

  void _swapLanguages() {
    if (!_isTranslateMode) return;
    setState(() {
      final t = _selectedSourceLanguage;
      _selectedSourceLanguage = _selectedTargetLanguage;
      _selectedTargetLanguage = t;
      _translator?.close();
      _translator = null;
      final lw = _lastWords;
      _lastWords = _translatedText;
      _translatedText = lw;
      if (_isTranslateMode) {
        _textController.text = _translatedText;
      }
    });
  }

  void _shareContent() {
    final buffer = StringBuffer();
    if (_lastWords.isNotEmpty) buffer.writeln(_lastWords);
    if (_isTranslateMode && _translatedText.isNotEmpty) {
      buffer.writeln(_translatedText);
    }
    if (buffer.isEmpty) return;
    Share.share(buffer.toString().trim());
  }

  void _onRecordTap() {
    if (!_speechEnabled) return;
    if (_isRecording) {
      _stopRecording();
    } else {
      _startRecording();
    }
  }

  /// Fixed height so [SttTranslateCardsStack] can use [Expanded] inside a scrollable page.
  double _translateStackHeight(BuildContext context) {
    final h = MediaQuery.sizeOf(context).height;
    return (h * 0.52).clamp(400.0, 620.0);
  }

  @override
  void dispose() {
    final myHash = hashCode;
    debugPrint(
      'STT_DEBUG [$myHash]: Disposing VoiceListeningPage. Force cancelling STT...',
    );
    _scrollbarHideTimer?.cancel();
    _scrollController.dispose();
    _timer?.cancel();
    _speechToText.stop();
    _speechToText.cancel();
    _flutterTts.stop();
    _textController.dispose();
    _translator?.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: cs.surface,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SttTranslateAppBar(
              onBack: () => Navigator.of(context).pop(),
              onShare: _shareContent,
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
              child: Listener(
                behavior: HitTestBehavior.deferToChild,
                onPointerDown: (_) => _flashScrollbar(),
                child: NotificationListener<ScrollNotification>(
                  onNotification: (n) {
                    if (n is ScrollUpdateNotification ||
                        n is ScrollStartNotification) {
                      _flashScrollbar();
                    }
                    return false;
                  },
                  child: _isTranslateMode
                      ? Scrollbar(
                          controller: _scrollController,
                          thumbVisibility: _scrollbarVisible,
                          thickness: 2,
                          radius: const Radius.circular(8),
                          child: SingleChildScrollView(
                            controller: _scrollController,
                            padding: const EdgeInsets.fromLTRB(
                              MySizes.defaultPagePadding,
                              4,
                              MySizes.defaultPagePadding,
                              MySizes.lg,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                SizedBox(
                                  height: _translateStackHeight(context),
                                  child: SttTranslateCardsStack(
                                    radius: _cardRadius,
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
                                    lastWords: _lastWords,
                                    translatedText: _translatedText,
                                    speechEnabled: _speechEnabled,
                                    isRecording: _isRecording,
                                    formattedTime: _formattedTime,
                                    onRecordTap: _onRecordTap,
                                    onSpeakSource: () =>
                                        _handleSpeak(useTarget: false),
                                    onSpeakTarget: () =>
                                        _handleSpeak(useTarget: true),
                                    onCopy: _handleCopy,
                                    onView: _handleView,
                                    onSwap: _swapLanguages,
                                    isSpeaking: _isSpeaking,
                                  ),
                                ),
                                const SizedBox(height: MySizes.md),
                                SttRecommendedSection(
                                  onPairTap: (from, to) {
                                    setState(() {
                                      _selectedSourceLanguage = from;
                                      _selectedTargetLanguage = to;
                                      _translator?.close();
                                      _translator = null;
                                      _lastWords = '';
                                      _translatedText = '';
                                      _pendingTranslationText = '';
                                      _textController.clear();
                                    });
                                  },
                                ),
                              ],
                            ),
                          ),
                        )
                      : Padding(
                          padding: const EdgeInsets.fromLTRB(
                            MySizes.defaultPagePadding,
                            4,
                            MySizes.defaultPagePadding,
                            MySizes.lg,
                          ),
                          child: SttSpeakFreelyPanel(
                            radius: _cardRadius,
                            sourceLanguage: _selectedSourceLanguage,
                            onSourceLanguageChanged: (val) {
                              setState(() {
                                _selectedSourceLanguage = val;
                                _translator?.close();
                                _translator = null;
                              });
                            },
                            textController: _textController,
                            speechEnabled: _speechEnabled,
                            isRecording: _isRecording,
                            formattedTime: _formattedTime,
                            isSpeaking: _isSpeaking,
                            onRecordTap: _onRecordTap,
                            onSpeakTap: () => _handleSpeak(useTarget: false),
                          ),
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
