import 'package:faida_pos/controllers/notification_controller.dart';
import 'package:faida_pos/l10n/app_localizations.dart';
import 'package:faida_pos/services/database_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../controllers/product_controller.dart';

class Notifications extends StatelessWidget {

  Future<void> _deleteNotification(BuildContext context, int n) async{
    await DatabaseService.instance.deleteNotification(n);
    if(context.mounted){
      Provider.of<NotificationController>(context, listen: false).load();
    }
  }


  const Notifications({
    super.key});

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
      body: Column(children: [
        Expanded(child:
        Consumer<NotificationController>(builder:
            (context, notificationController,_){
            final allNotifications = notificationController.notifications;

            if(allNotifications.isEmpty){
              return Center(child: Text(l10n.noNotification));
            }
            return ListView.builder(
                itemCount: allNotifications.length,
                itemBuilder: (context, index){
                  final n = allNotifications[index];
                  final product =
                  Provider.of<ProductController>
                    (context, listen: false).products.firstWhere(
                      (p) => p.id == n.productId);
                  return ListTile(
                    title: Text(product.name),
                    subtitle: Text(n.isOutOfStock == true ? l10n.outOfStock : l10n.lowStockNotification),
                    leading: Icon(
                      n.isOutOfStock == true ? Icons.remove_circle : Icons.warning,
                      color: n.isOutOfStock == true ? Colors.red : Colors.orange,
                    ),
                    trailing: ElevatedButton.icon(onPressed: (){
                      _deleteNotification(context, n.id);
                    },
                        label: Icon(Icons.delete)),
                  );
                });
        }
        )
        ),
        ElevatedButton(style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          side: BorderSide(color: Colors.black, width: 1, style: BorderStyle.solid)
        ), onPressed:() {
          Provider.of<NotificationController>(context, listen:false).clear();
            },
            child: Text(l10n.clearNotifications))
      ],
          )
    );
}
}