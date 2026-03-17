import 'package:faida_pos/controllers/notification_controller.dart';
import 'package:faida_pos/models/sale_item.dart';
import 'package:faida_pos/services/database_service.dart';
import 'package:flutter/foundation.dart';

import '../models/product.dart';

class ProductController extends ChangeNotifier {
  List<Product> products = [];
  final NotificationController notificationController;

  ProductController({required this.notificationController});

  Future<void> load() async {

    products = await DatabaseService.instance.getAllProducts();

    for (final product in products) {
      final hasActive = notificationController.notifications
          .any((n) => n.productId == product.id && n.isResolved == false);

      if (!hasActive) {
        if (product.inStock == 0) {
          await DatabaseService.instance.outOfStockNotification(product: product);
        } else if (product.inStock <= 10) {
          await DatabaseService.instance.lowStockNotification(product: product);
        }
      }
    }
    await notificationController.load();
    notifyListeners();

  }

  //FIX NOTIFICATIONS ADDING AGAIN AFTER A SALE HAS BEEN DONE!

  Future<void> commitSale(List<SaleItem> items) async {
    for(final item in items){
      if(item.productId == null) continue;
      try{
        final p = products.firstWhere((p) => p.id == item.productId);
        final updatedProduct = p.copyWith(inStock: p.inStock - item.quantity);
        await updateProduct(updatedProduct);
      }catch(e){
        if (kDebugMode) {
          print("Product ${item.productId} not found");
        }
      }
    }
    await load();
  }

  Future<void> updateProduct(Product updated) async {
    await DatabaseService.instance.updateProduct(updated);


    final hasActive = notificationController.notifications
        .any((n) => n.productId == updated.id && n.isResolved == false);

    if(hasActive &&
        notificationController.notifications.any((n) => n.isLowStock ==
            true && updated.inStock == 0)){
      try{
        await DatabaseService.instance.resolveNotificationsForProduct(updated.id!);

      }catch(e){
        e.toString();
      }
    }

    if (!hasActive) {
      if (updated.inStock == 0) {
        await DatabaseService.instance.outOfStockNotification(product: updated);
      }
      else if (updated.inStock <= 10) {
        await DatabaseService.instance.lowStockNotification(product: updated);
      }
    }

    await notificationController.load();

    final index = products.indexWhere((p) => p.id == updated.id);
    if (index != -1) {
      products[index] = updated;
      notifyListeners();
    }
  }

  Product? getById(int id) {
    try {
      return products.firstWhere((p) => p.id == id);
    } catch (_) {
      return null;
    }
  }
}