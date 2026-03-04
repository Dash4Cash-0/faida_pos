import 'package:faida_pos/models/notifications_model.dart';
import 'package:faida_pos/services/database_service.dart';
import 'package:flutter/cupertino.dart';

import '../models/product.dart';

class NotificationController extends ChangeNotifier {
  final List<NotificationsModel> notifications = [];

  Future<void> load() async {
    final loaded = await DatabaseService.instance.getNotifications();
    notifications
    ..clear()
    ..addAll(loaded);
    notifyListeners();
  }

  Future<void> addOutOfStock(Product product) async {
    await DatabaseService.instance.outOfStockNotification(product: product);
    await load();
  }

  Future<void> addLowStock(Product product) async {
    await DatabaseService.instance.lowStockNotification(product: product);
    await load();
  }

  void clear(){
    notifications.clear();
    notifyListeners();
  }
}