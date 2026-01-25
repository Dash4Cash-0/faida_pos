import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class WeekWidget extends StatelessWidget {
  const WeekWidget({super.key});


  int weekNumber(DateTime date) {
    final firstDayOfYear = DateTime(date.year, 1, 1);
    final daysSinceStart = date.difference(firstDayOfYear).inDays;
    return ((daysSinceStart + firstDayOfYear.weekday) / 7).ceil();
  }


  @override
  Widget build(BuildContext context) {
    final currentWeek = weekNumber(DateTime.now());
    DateTime currentDay = DateTime.now();
    String dateFormat = DateFormat('EEEE').format(currentDay);
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
