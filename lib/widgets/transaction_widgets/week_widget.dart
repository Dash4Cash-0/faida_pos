import 'package:flutter/material.dart';

class WeekWidget extends StatelessWidget {
  const WeekWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final getWeek = DateTime.now().day;
    return SafeArea(child: Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(height: 20),
        Center(child:
        Text("Week: "))
      ],
    ));
  }
}
