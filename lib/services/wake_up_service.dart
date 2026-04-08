import 'dart:async';

import 'package:faida_pos/services/voice_recording_service.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:porcupine_flutter/porcupine.dart';
import 'package:porcupine_flutter/porcupine_error.dart';
import 'package:porcupine_flutter/porcupine_manager.dart';
import 'package:speech_to_text/speech_to_text.dart';


class WakeUpService {

  final SpeechToText _speech = SpeechToText();
  late VoiceRecordingService recording;

  Function(bool)? onRecordingStateChanged;

  bool _isListening = false;
  bool _isSpeechActive = false;
  bool _isProcessingCommand = false;

  Future<void> initialize() async {
  await _speech.initialize();
  }

  void startListening() {
  if (_isListening) return;
  _isListening = true;
  _startListeningLoop();
  }

  void stopListening() {
  _isListening = false;
  _speech.stop();
  }

  bool _isWakeWord(String text) {
  final t = text.toLowerCase();
  return t.contains("hey google") ||
  t.contains("ok google") ||
  t.contains("hey goo") ||
  t.contains("hey googel");
  }

  Future<void> _startListeningLoop() async {
  if (!_isListening || _isSpeechActive || _isProcessingCommand) return;

  _isSpeechActive = true;

  await _speech.listen(
  onResult: (result) async {
  if (_isProcessingCommand) return;
  final text = result.recognizedWords.toLowerCase();
  if (!result.finalResult) return;
  if (_isWakeWord(text)) {
  _isProcessingCommand = true;
  await _handleCommand();
  }
  },
  listenFor: const Duration(seconds: 10),
  pauseFor: const Duration(seconds: 2),
  );

  _speech.statusListener = (status) async {
  if (status == "done") {
  _isSpeechActive = false;
  if (_isListening && !_isProcessingCommand) {
  await Future.delayed(const Duration(milliseconds: 300));
  _startListeningLoop();
  }
  }
  };
  }

  Future<void> _handleCommand() async {
    try {
      await _speech.stop();
      _isSpeechActive = false;
      await Future.delayed(const Duration(milliseconds: 200));
      onRecordingStateChanged?.call(true);
      await recording.startRecording();
      await Future.delayed(const Duration(seconds: 4));
      final result = await recording.stopRecording();
      onRecordingStateChanged?.call(false);
      recording.onVoiceResult?.call(result);
    } catch (e) {
    } finally {
      _isProcessingCommand = false;

      if (_isListening) {
        await Future.delayed(const Duration(milliseconds: 500));
        _startListeningLoop();
      }
    }
  }


    /*PorcupineManager? _porcupineManager;
  late VoiceRecordingService recording;
  final accessKey = dotenv.env['PORCUPINE_ACCESS_KEY'];

  void createPorcupineManager() async {
    try {
      _porcupineManager = await PorcupineManager.fromBuiltInKeywords(
          "$accessKey",
          [BuiltInKeyword.HEY_GOOGLE], _wakeWordCallback);
    } on PorcupineException catch (err) {
      if (kDebugMode) {
        print(err);
      }
    }
  }
  void _wakeWordCallback(int keywordIndex){
    if(keywordIndex == 0){
      recording.startRecording();
    }
  }

  void _listenForSilence() async {
    DateTime? silenceStart;

    Timer.periodic(Duration(milliseconds: 200), (timer) async {
      final amplitude = await recording.record.getAmplitude();
      if (amplitude.current < -30){
        silenceStart ??=DateTime.now();
        if(DateTime.now().difference(silenceStart!).inSeconds >= 2){
          timer.cancel();
          silenceStart = null;
          recording.stopRecording();
        }
      }else{
        silenceStart = null;
      }
    });

  }*/
  }