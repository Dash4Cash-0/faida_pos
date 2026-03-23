
import 'package:path_provider/path_provider.dart';
import 'package:record/record.dart';

class VoiceRecordingService {

  final record = AudioRecorder();
  bool isRecording = false;

  Future<void>startRecording() async {
    final dir = await getTemporaryDirectory();
    final path = "${dir.path}/voice_command.wav";
    if (await record.hasPermission()){
      await record.start(
          const RecordConfig(),
          path: path);
    }
    isRecording = true;
  }

  Future<String?>stopRecording() async {
   final path = record.stop();
   isRecording = false;
   return path;
  }
}
