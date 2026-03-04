import 'package:faida_pos/controllers/notification_controller.dart';
import 'package:faida_pos/l10n/app_localizations.dart';
import 'package:flutter/material.dart';

class Notifications extends StatelessWidget {

  final NotificationController controller;

  const Notifications({
    super.key,
    required this.controller});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.notifications),
        titleTextStyle: TextStyle(color: Colors.black ,fontWeight: FontWeight.bold, fontSize: 28),
        backgroundColor: Colors.white,
      ),
      backgroundColor: Colors.white,
      body:
      Column(children: [


      ]),
    );
  }
}