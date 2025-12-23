import 'package:flutter/material.dart';

import '../l10n/app_localizations.dart';

class Reports extends StatelessWidget {
  const Reports({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.reports),
        titleTextStyle: TextStyle(color: Colors.black ,fontWeight: FontWeight.bold, fontSize: 28),
        backgroundColor: Colors.white,
      ),
      backgroundColor: Colors.white,
    );
  }
}