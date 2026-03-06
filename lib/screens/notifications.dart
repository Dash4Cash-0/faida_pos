import 'package:faida_pos/controllers/notification_controller.dart';
import 'package:faida_pos/l10n/app_localizations.dart';
import 'package:flutter/material.dart';

import '../controllers/product_controller.dart';

class Notifications extends StatelessWidget {

  final NotificationController controller;
  final ProductController productController;

  const Notifications({
    super.key,
    required this.controller,
    required this.productController});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.notifications),
        titleTextStyle: TextStyle(
            color: Colors.black ,
            fontWeight: FontWeight.bold,
            fontSize: 28),
        backgroundColor: Colors.white,
      ),
      backgroundColor: Colors.white,
      body: AnimatedBuilder(
          animation: controller,
          builder: (context, _){
            if(controller.notifications.isEmpty){
              return Center(child: Text("No notifications"));
            }
            return ListView.builder(
                itemCount: controller.notifications.length,
                itemBuilder: (context, index){
                  final n = controller.notifications[index];
                  final product = productController.products.firstWhere(
                      (p) => p.id == n.productId);
                  return ListTile(
                    title: Text(product.name),
                    subtitle: Text(n.isOutOfStock == true ? "Out of Stock" : "Low Stock"),
                    leading: Icon(
                      n.isOutOfStock == true ? Icons.remove_circle : Icons.warning,
                      color: n.isOutOfStock == true ? Colors.red : Colors.orange,
                    ),
                  );
                });
          })
    );
  }
}