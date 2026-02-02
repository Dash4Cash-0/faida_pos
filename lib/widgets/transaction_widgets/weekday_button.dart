import 'package:flutter/material.dart';

class WeekdayButton extends StatelessWidget {

  final String label;
  final VoidCallback onClicked;

  const WeekdayButton({super.key,
    required this.label,
    required this.onClicked});

  @override
  Widget build(BuildContext context) {
    return Container(
        color: Colors.white,
        child: Column(
          children: [
            Divider(height: 10, thickness: 2, indent: 0,endIndent: 0),
            SizedBox(width: double.infinity,
                child:
                TextButton(
                    onPressed: onClicked, style: TextButton.styleFrom(
                    foregroundColor: Colors.black,
                    backgroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(vertical: 16)
                ),
                    child: Text(label, style: TextStyle(fontSize: 18),))),
            Divider(height: 10, thickness: 2, indent: 0,endIndent: 0),
          ],
        )
    );
  }
}
