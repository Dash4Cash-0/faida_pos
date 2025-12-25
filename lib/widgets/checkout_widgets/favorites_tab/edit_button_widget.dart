import 'package:faida_pos/l10n/app_localizations.dart';
import 'package:flutter/material.dart';

class EditButtonWidget extends StatelessWidget {
  const EditButtonWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return ElevatedButton(
        style: ElevatedButton.styleFrom(
            backgroundColor: Colors.white,
            side: BorderSide(color: Colors.black, style: BorderStyle.solid),
            padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12)
        ),
        onPressed: () => Navigator.pop(context),
        child: Text(l10n.edit, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),));
  }
}
