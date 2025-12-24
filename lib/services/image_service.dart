import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;

class ImageService {
  // Private constructor for singleton pattern
  ImageService._();
  static final ImageService instance = ImageService._();

  // Save image and return the path to store in database
  Future<String> saveProductImage(File imageFile, String productId) async {
    try {
      // Get the app's documents directory (private to your app)
      final directory = await getApplicationDocumentsDirectory();

      // Create a subfolder for product images
      final productImagesDir = Directory('${directory.path}/product_images');
      if (!await productImagesDir.exists()) {
        await productImagesDir.create(recursive: true);
      }

      // Create a unique filename using productId and timestamp
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final extension = path.extension(imageFile.path);
      final fileName = '${productId}_$timestamp$extension';
      final savedPath = '${productImagesDir.path}/$fileName';

      // Copy the image to the app's directory
      await imageFile.copy(savedPath);

      return savedPath; // This is what you store in SQLite
    } catch (e) {
      throw Exception('Failed to save image: $e');
    }
  }

  // Load image from path stored in database
  File? loadProductImage(String? imagePath) {
    if (imagePath == null || imagePath.isEmpty) return null;

    final file = File(imagePath);
    return file.existsSync() ? file : null;
  }

  // Delete image when product is deleted
  Future<void> deleteProductImage(String? imagePath) async {
    if (imagePath == null || imagePath.isEmpty) return;

    try {
      final file = File(imagePath);
      if (await file.exists()) {
        await file.delete();
      }
    } catch (e) {
      // Log error but don't throw - deletion is not critical
      print('Failed to delete image: $e');
    }
  }

  // Optional: Update image (delete old, save new)
  Future<String?> updateProductImage(String? oldImagePath, File? newImageFile, String productId) async {
    // Delete old image if it exists
    if (oldImagePath != null) {
      await deleteProductImage(oldImagePath);
    }

    // Save new image if provided
    if (newImageFile != null) {
      return await saveProductImage(newImageFile, productId);
    }

    return null;
  }
}