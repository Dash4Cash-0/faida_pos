import 'package:faida_pos/l10n/app_localizations.dart';
import 'package:faida_pos/main.dart';
import 'package:faida_pos/widgets/menu_widgets/menu_button.dart';
import 'package:faida_pos/widgets/shared/add_product.dart';
import 'package:faida_pos/widgets/shared/all_products.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'app_initializer.dart';

class Menu extends StatelessWidget {
  const Menu({super.key});


  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.menu),
        titleTextStyle: TextStyle(color: Colors.black ,fontWeight: FontWeight.bold, fontSize: 28),
        backgroundColor: Colors.white,
      ),
      backgroundColor: Colors.white,
      body: Column(
        children: [
          MenuButton(label: l10n.itemsCap,
              onClicked: () {
            Navigator.push(
                context, MaterialPageRoute(builder: (_) => AddProduct()));
              }),
          MenuButton(label: "All Products", onClicked: () => showDialog(context: context, builder: (_) => AllProducts())),
          MenuButton(label: l10n.language, onClicked: () => showDialog(context: context, builder: (BuildContext context) =>
          Dialog(
            constraints: BoxConstraints(minWidth: 300, maxHeight: 220),
            backgroundColor: Colors.white,
            child: Column(
              children: [
                  SizedBox(height: 30),
                  MenuButton(label: l10n.english, onClicked: () {MyApp.of(context)?.setLocale(const Locale("en")); Navigator.pop(context);}),
                  MenuButton(label: l10n.swahili, onClicked: () {MyApp.of(context)?.setLocale(const Locale("sw")); Navigator.pop(context);}),
              ],
            ),
          ))),
          if (kDebugMode) ...[
            SizedBox(height: 20),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: OutlinedButton.icon(
                onPressed: () async {
                  final confirmed = await showDialog<bool>(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: Text('Reset App?'),
                      content: Text('This will clear all data and restart the app.'),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context, false),
                          child: Text('Cancel'),
                        ),
                        TextButton(
                          onPressed: () => Navigator.pop(context, true),
                          child: Text('Reset'),
                        ),
                      ],
                    ),
                  );

                  if (confirmed == true) {
                    final storage = FlutterSecureStorage();
                    await storage.deleteAll();

                    if (context.mounted) {
                      Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(builder: (_) => AppInitializer()),
                            (route) => false,
                      );
                    }
                  }
                },
                icon: Icon(Icons.refresh, color: Colors.red),
                label: Text('DEV: Reset App', style: TextStyle(color: Colors.red)),
                style: OutlinedButton.styleFrom(
                  side: BorderSide(color: Colors.red),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}