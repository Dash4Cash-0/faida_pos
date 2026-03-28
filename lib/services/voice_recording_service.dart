
import 'package:path_provider/path_provider.dart';
import 'package:record/record.dart';
import 'package:http/http.dart' as http;

class VoiceRecordingService {

  final record = AudioRecorder();
  bool isRecording = false;

  Future<void>startRecording() async {
    final dir = await getTemporaryDirectory();
    final path = "${dir.path}/voice_command.wav";
    if (await record.hasPermission()){
      await record.start(
          const RecordConfig(encoder: AudioEncoder.wav),
          path: path);
    }
    isRecording = true;
  }

  Future<void>stopRecording() async {
   final path = await record.stop();
   if(path == null) return;

   final uri = Uri.parse("http://192.168.0.35:8000/transcribe");
   final request = http.MultipartRequest('POST', uri);
   request.files.add(await http.MultipartFile.fromPath("file", path));

   final response = await request.send();
   final body = await response.stream.bytesToString();
   print("Transcription: $body");

   isRecording = false;
  }
}
