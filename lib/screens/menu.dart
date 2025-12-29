import 'package:faida_pos/l10n/app_localizations.dart';
import 'package:faida_pos/main.dart';
import 'package:faida_pos/widgets/menu_widgets/menu_button.dart';
import 'package:faida_pos/widgets/shared/add_product.dart';
import 'package:faida_pos/widgets/shared/all_products.dart';
import 'package:flutter/material.dart';

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
            constraints: BoxConstraints(minWidth: 300, maxHeight: 190),
            backgroundColor: Colors.white,
            child: Column(
              children: [
                  SizedBox(height: 30),
                  MenuButton(label: "English", onClicked: () {MyApp.of(context)?.setLocale(const Locale("en")); Navigator.pop(context);}),
                  MenuButton(label: "Swahili", onClicked: () {MyApp.of(context)?.setLocale(const Locale("sw")); Navigator.pop(context);}),
              ],
            ),
          ))),
        ],
      ),
    );
  }
}