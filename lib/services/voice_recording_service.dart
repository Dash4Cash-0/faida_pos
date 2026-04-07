
import 'package:faida_pos/controllers/product_controller.dart';
import 'package:faida_pos/models/product.dart';
import 'package:faida_pos/services/database_service.dart';
import 'package:path_provider/path_provider.dart';
import 'package:record/record.dart';
import 'package:http/http.dart' as http;



class VoiceRecordingService {

  final record = AudioRecorder();
  final ProductController productController;
  late Function(Product, double) onAddProduct;

  VoiceRecordingService({required this.productController});



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

  void triggerQuickSale(String? transcription) {
    final lower = transcription?.toLowerCase();

    final numbers = RegExp(r'\d+').allMatches(lower!)
        .map((m) => double.parse(m.group(0)!));

    if(numbers.isEmpty) return;
    final amount = numbers.first;
    DatabaseService.instance.processQuickSale(amountReceived: amount);
  }

  void addProductsByVoice(String? transcription) {
    print("Products: ${productController.products.map((p) => p.name)}");
    print("Transcript: $transcription");
    final lower = transcription?.toLowerCase();
    final product = productController.products.cast<Product?>()
        .firstWhere((p) => lower!.contains(p!.name.toLowerCase()),
      orElse: () => null,);

    final quantityMatch = RegExp(r'\d+').firstMatch(lower!);
    final quantity = quantityMatch != null
        ? double.parse(quantityMatch.group(0)!) : 1.0;
    if(product != null){
      onAddProduct(product,quantity);
    }else{
      return;
    }
  }
}

