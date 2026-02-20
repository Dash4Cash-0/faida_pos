import 'package:faida_pos/l10n/app_localizations.dart';
import 'package:flutter/material.dart';

class WeekdayButton extends StatelessWidget {

  final String dateLabel;
  final int saleTotal;
  final VoidCallback onClicked;

  const WeekdayButton({super.key,
    required this.dateLabel,
    required this.saleTotal,
    required this.onClicked});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Container(
        color: Colors.white,
        child: Column(
          children: [
            Divider(height: 10, thickness: 2, indent: 0,endIndent: 0),
              Row(children:[
                Icon(Icons.calendar_today),
                    Expanded(child:
                    TextButton(
                        onPressed: onClicked, style: TextButton.styleFrom(
                        foregroundColor: Colors.black,
                        backgroundColor: Colors.white,
                        padding: EdgeInsets.all(14)
                    ),
                        child: Text(dateLabel, style: TextStyle(fontSize: 18)))),
                    Text("${l10n.sales}: $saleTotal",
                        style: TextStyle(
                          decoration: TextDecoration.underline,
                            color: saleTotal > 0 ? Colors.green : Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 18)),

            ]),
            Divider(height: 10, thickness: 2, indent: 0,endIndent: 0),
          ],
        )
    );
  }
}
