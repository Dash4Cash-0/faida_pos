import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
class CalendarWidget extends StatefulWidget {
  const CalendarWidget({super.key});


  @override
  State<CalendarWidget> createState() => _CalendarWidget();
}
class _CalendarWidget extends State<CalendarWidget> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  @override
  Widget build(BuildContext context) {
    DateTime firstDate = DateTime.utc(DateTime
        .now()
        .year - 30);
    DateTime lastDate = DateTime.utc(DateTime
        .now()
        .year + 30);
    final locale = Localizations
        .localeOf(context)
        .languageCode;
    return Column(
      children: [
        TableCalendar(
            locale: locale,
            focusedDay: _focusedDay,
            firstDay: firstDate,
            lastDay: lastDate,
            selectedDayPredicate: (day) {
              return isSameDay(_selectedDay, day);
            },
            onDaySelected: (selectedDay, focusedDay) {
              if(!isSameDay(_selectedDay, selectedDay)){
                  setState(() {
                    _selectedDay = selectedDay;
                    _focusedDay = focusedDay;
                  });
              }
            },
            calendarFormat: _calendarFormat,
            onFormatChanged: (format) {
              if(_calendarFormat != format){
                  setState(() {
                    _calendarFormat = format;
                  });
              }
            }, onPageChanged: (focusedDay){
              _focusedDay = focusedDay;
        },)
      ],
    );
  }
}
