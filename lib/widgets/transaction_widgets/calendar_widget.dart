import 'package:flutter/material.dart';
class CalendarWidget extends StatelessWidget {
  const CalendarWidget({super.key});

  @override
  Widget build(BuildContext context) {
    int firstDate = DateTime.now().year - 70;
    int lastDate = DateTime.now().year + 10;
    return Column(
      children: [
        CalendarDatePicker(initialDate: DateTime.now(), firstDate: DateTime(firstDate), lastDate: DateTime(lastDate), onDateChanged: (DateTime date){})
      ],
    );
  }
}
