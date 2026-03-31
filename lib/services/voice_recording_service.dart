
import 'package:faida_pos/services/database_service.dart';
import 'package:path_provider/path_provider.dart';
import 'package:record/record.dart';
import 'package:http/http.dart' as http;

class VoiceRecordingService {

  final record = AudioRecorder();

  Future<void>startRecording() async {
    final dir = await getTemporaryDirectory();
    final path = "${dir.path}/voice_command.wav";
    if (await record.hasPermission()){
      await record.start(
          const RecordConfig(encoder: AudioEncoder.wav),
          path: path);
    }
  }

  Future<String?>stopRecording() async {
   final path = await record.stop();
   if(path == null) return null;

   final uri = Uri.parse("http://192.168.0.35:8000/transcribe");
   final request = http.MultipartRequest('POST', uri);
   request.files.add(await http.MultipartFile.fromPath("file", path));

   final response = await request.send();
   final body = await response.stream.bytesToString();
   return body;
  }

  void checkForQuickSale(String transcription) {
    final lower = transcription.toLowerCase();
    print("Transcription: $lower");
    final isSaleCommand =
        lower.contains('sell')
        || lower.contains('sale')
        || lower.contains("quicksale");

    if(!isSaleCommand) return;

    final numbers = RegExp(r'\d+').allMatches(lower)
        .map((m) => double.parse(m.group(0)!));

    if(numbers.isEmpty) return;
    final amount = numbers.first;
    print("Transcription: $amount");
    DatabaseService.instance.processQuickSale(amountReceived: amount);

  }
}

