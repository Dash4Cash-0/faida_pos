import 'package:faida_pos/l10n/app_localizations.dart';
import 'package:faida_pos/main.dart';
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
          ElevatedButton(onPressed: () => showDialog(context: context, builder: (BuildContext context) =>
          Dialog(
            backgroundColor: Colors.white,
            child: Column(
              children: [
                  ElevatedButton(onPressed: () {MyApp.of(context)?.setLocale(const Locale("en"));}, child: Text("English")),
                  ElevatedButton(onPressed: () {MyApp.of(context)?.setLocale(const Locale("sw"));}, child: Text("Swahili")),
              ],
            ),
          )), child: Text(l10n.language)),


        ],
      ),
    );
  }
}