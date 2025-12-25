import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;

class ImageService {
  ImageService._();
  static final ImageService instance = ImageService._();

  Future<String> saveProductImage(File imageFile, String productId) async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final productImagesDir = Directory('${directory.path}/product_images');
      if (!await productImagesDir.exists()) {
        await productImagesDir.create(recursive: true);
      }

      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final extension = path.extension(imageFile.path);
      final fileName = '${productId}_$timestamp$extension';
      final savedPath = '${productImagesDir.path}/$fileName';

      await imageFile.copy(savedPath);

      return savedPath; // This is what you store in SQLite
    } catch (e) {
      throw Exception('Failed to save image: $e');
    }
  }

  File? loadProductImage(String? imagePath) {
    if (imagePath == null || imagePath.isEmpty) return null;

    final file = File(imagePath);
    return file.existsSync() ? file : null;
  }

  Future<void> deleteProductImage(String? imagePath) async {
    if (imagePath == null || imagePath.isEmpty) return;

    try {
      final file = File(imagePath);
      if (await file.exists()) {
        await file.delete();
      }
    } catch (e) {
      print('Failed to delete image: $e');
    }
  }

  Future<String?> updateProductImage(String? oldImagePath, File? newImageFile, String productId) async {
    if (oldImagePath != null) {
      await deleteProductImage(oldImagePath);
    }

    if (newImageFile != null) {
      return await saveProductImage(newImageFile, productId);
    }
    return null;
  }
}