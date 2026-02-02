import 'package:flutter/material.dart';
import 'package:transmirror/core/widgets/main/voice/voice_initial_view.dart';
import 'package:transmirror/core/widgets/main/voice/voice_recording_view.dart';
import 'package:transmirror/core/widgets/layout_app_bar.dart';
import 'package:transmirror/core/utils/constants/colors.dart';
import 'dart:async';

class VoiceListeningPage extends StatefulWidget {
  const VoiceListeningPage({super.key});

  @override
  State<VoiceListeningPage> createState() => _VoiceListeningPageState();
}

class _VoiceListeningPageState extends State<VoiceListeningPage> {
  bool _isRecording = false;
  Timer? _timer;
  int _seconds = 0;

  void _startRecording() {
    setState(() {
      _isRecording = true;
      _seconds = 0;
    });
    _startTimer();
  }

  void _stopRecording() {
    setState(() {
      _isRecording = false;
    });
    _stopTimer();
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
    final hours = twoDigits(duration.inHours);
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return "$hours:$minutes:$seconds";
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors.white,
      body: SafeArea(
        child: Column(
          children: [
            const LayoutPagesAppBar(title: 'Speech to Text', showTrailing: false),
            Expanded(
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                child: _isRecording
                    ? VoiceRecordingView(
                        formattedTime: _formattedTime,
                        onStop: _stopRecording,
                        onPause: () {}, // Implement pause logic
                        onReset: () {
                          setState(() {
                            _seconds = 0;
                          });
                        },
                        animate: true,
                      )
                    : VoiceInitialView(
                        onRecord: _startRecording,
                        animate: true,
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
