import 'package:faida_pos/utils/transaction_utils/week_dates.dart';
import 'package:flutter/material.dart';

class WeekWidget extends StatelessWidget {
  const WeekWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final currentWeek = WeekDates().weekNumber(DateTime.now());
    return SafeArea(child: Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(height: 20),
        Center(child:
        Text("Week: $currentWeek",
          style: Theme.of(context).textTheme.headlineSmall,))
      ],
    ));
  }
}
