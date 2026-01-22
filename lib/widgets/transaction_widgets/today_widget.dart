import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
class TodayWidget extends StatelessWidget {
  const TodayWidget({super.key});



  @override
  Widget build(BuildContext context) {
    final locale = Localizations.localeOf(context).languageCode;
    DateTime now = DateTime.now();
    String dateFormat = DateFormat('EEEE, d MMMM yyyy', locale).format(now);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 20),
            Center(
              child: Text(dateFormat,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headlineSmall)
            )

          ],
      )),
    );
  }
}
