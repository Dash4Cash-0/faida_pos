import 'package:faida_pos/models/notifications_model.dart';
import 'package:faida_pos/services/database_service.dart';
import 'package:flutter/cupertino.dart';

//import '../models/product.dart';

class NotificationController extends ChangeNotifier {
  final List<NotificationsModel> notifications = [];

  Future<void> load() async {
    final loaded = await DatabaseService.instance.getNotifications();
    notifications
    ..clear()
    ..addAll(loaded);
    notifyListeners();
  }

  void clear(){
    notifications.clear();
    notifyListeners();
  }
}