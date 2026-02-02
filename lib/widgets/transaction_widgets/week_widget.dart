import 'package:faida_pos/utils/transaction_utils/week_dates.dart';
import 'package:faida_pos/widgets/menu_widgets/menu_button.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class WeekWidget extends StatelessWidget {
  const WeekWidget({super.key});


  void onClickedDay() {

}

  @override
  Widget build(BuildContext context) {
    final currentWeek = WeekDates().weekNumber(DateTime.now());
    final locale = Localizations.localeOf(context).languageCode;
    return SafeArea(child: Column(

      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(height: 20),
        Center(child:
        Text("Week: $currentWeek",
          style: Theme.of(context).textTheme.headlineSmall,)),
        SizedBox(height: 20),
        Expanded(child:ListView
          (children: List.generate(7, (index) {
          final date = WeekDates().getWeekDates(DateTime.now())[index];
          final day = DateFormat("EEEE", locale).format(date);

          return MenuButton(label: "$day ${date.day}/${date.month}\tTotal: 5"
              , onClicked: () => onClickedDay());
        })
        )
    ),
        SizedBox(height: 18),
        Text("Sales this week: 10", style:
        TextStyle(fontSize: 18, fontWeight: FontWeight.bold))

      ],
    ));
  }
}
