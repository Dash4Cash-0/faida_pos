import 'dart:async';

import 'package:faida_pos/services/voice_recording_service.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:porcupine_flutter/porcupine.dart';
import 'package:porcupine_flutter/porcupine_error.dart';
import 'package:porcupine_flutter/porcupine_manager.dart';


class WakeUpService {

  PorcupineManager? _porcupineManager;
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

  }
}