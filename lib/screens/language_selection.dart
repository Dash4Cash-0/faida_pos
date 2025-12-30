import 'package:faida_pos/main.dart';
import 'package:faida_pos/security/pin_setup.dart';
import 'package:faida_pos/services/app_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';


class LanguageSelection extends StatelessWidget {

  LanguageSelection({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Padding(
              padding: EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Select Language / Chagua Lugha",
                style: TextStyle(fontSize: 24,
                    fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center),
                SizedBox(height: 60),
                _buildLanguageButton(
                  context,
                  "English",
                  "en",
                  Icons.language
                ),
                SizedBox(height: 20),
                _buildLanguageButton(
                    context,
                    "Kiswahili",
                    "sw",
                    Icons.language
                ),
              ],
            )
          )
      ),
    );
  }

  Widget _buildLanguageButton(
      BuildContext context,
      String label,
      String langCode,
      IconData icon) {
    return ElevatedButton(onPressed: () async {
      await AppStorage.write('app_language', langCode);
      if(!context.mounted) return;
      MyApp.of(context)?.setLocale(Locale(langCode));
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => PinSetup())
      );
    }, style: ElevatedButton.styleFrom(
      padding: EdgeInsets.symmetric(vertical: 20, horizontal: 40),
      minimumSize: Size(double.infinity, 60)
    ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 28),
            SizedBox(width: 12),
            Text(label, style: TextStyle(fontSize: 20))
          ],
        ));
  }
}
