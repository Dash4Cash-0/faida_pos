import 'package:faida_pos/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../models/sale.dart';
class CalendarWidget extends StatefulWidget {
  final ValueNotifier <Set<DateTime>> daysWithSales;
  final ValueNotifier<List<Sale>> salesOnSelected;
  final Function(DateTime) onMonthChanged;
  final Function(DateTime) onSelectedChanged;

  const CalendarWidget({
    super.key,
    required this.daysWithSales,
    required this.onMonthChanged,
    required this.salesOnSelected,
    required this.onSelectedChanged });


  @override
  State<CalendarWidget> createState() => _CalendarWidget();
}
class _CalendarWidget extends State<CalendarWidget> {

  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    DateTime firstDate = DateTime.utc(DateTime.now().year - 30);
    DateTime lastDate = DateTime.utc(DateTime.now().year + 30);
    final locale = Localizations.localeOf(context).languageCode;
    
    return ValueListenableBuilder<Set<DateTime>>
      (valueListenable:
    widget.daysWithSales,
        builder: (context, salesDays, _) {
          return Column(
            children: [
              TableCalendar(
                  calendarStyle: CalendarStyle(
                    selectedTextStyle: TextStyle(
                      color: Colors.black
                    ),
                    selectedDecoration: BoxDecoration(
                      color: Colors.green,
                      shape: BoxShape.circle,
                    ),
                    todayTextStyle: TextStyle(
                      color: Colors.black
                    ),
                    todayDecoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.black,
                        width: 1.5
                      )
                    )
                  ),
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
                          widget.onSelectedChanged(selectedDay);
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
                    widget.onMonthChanged(focusedDay);
              }, calendarBuilders: CalendarBuilders(
                markerBuilder: (context,day,events){
                  final normalizedDay = DateTime(day.year, day.month, day.day);
                  final hasSales = salesDays.any((saleDay) =>
                  isSameDay(saleDay, normalizedDay));

                  if(hasSales){
                    return Positioned(
                        bottom: 1,
                        child: Container(
                          width: 6,
                          height: 6,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.green
                          ),
                        )
                    );
                  }
                  return null;
                }
              )
              ),
              Expanded(
                  child: Padding(padding: EdgeInsets.all(9),
                      child:
                      ValueListenableBuilder(
                          valueListenable: widget.salesOnSelected,
                          builder: (context, sales, _) {
                        if (sales.isEmpty) {
                          return Text(l10n.noSalesToday);
                        }
                        return ListView.separated(
                            itemCount: sales.length,
                            separatorBuilder: (_, _) => Divider(),
                            itemBuilder: (context, index) {
                              final sale = sales[index];
                              return Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Icon(color: Colors.green, Icons.sell),
                                  Expanded(child:
                                  TextButton(
                                      onPressed: () {},
                                      child: Text(
                                          "TZS ${sale.total}",
                                          style: const TextStyle(
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold)
                                      )
                                  )
                                  ),
                                  Text(
                                    DateFormat.Hm(locale)
                                        .format(sale.createdAt),
                                  ),
                                ],
                              );
                            }
                        );
                      }
                      )
                  )
              ),
            ],
          );
        }
        );
  }
}
