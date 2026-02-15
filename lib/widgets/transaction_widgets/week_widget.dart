import 'package:faida_pos/l10n/app_localizations.dart';
import 'package:faida_pos/utils/transaction_utils/week_dates.dart';
import 'package:faida_pos/widgets/transaction_widgets/weekday_button.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class WeekWidget extends StatelessWidget {
  final ValueNotifier<Map<DateTime, int>> showSalesByDate;
  final Function(DateTime) loadWeekdaySales;


  const WeekWidget({
    super.key,
    required this.showSalesByDate,
    required this.loadWeekdaySales});


  void onClickedDay(BuildContext context, String buttonDate) {
    showDialog(context: context, builder: (_) => Dialog.fullscreen(
      backgroundColor: Colors.white,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          leading: CloseButton(),
          title: Text(buttonDate, style: TextStyle(fontWeight: FontWeight.bold)),
          centerTitle: true,
          backgroundColor: Colors.white,
          elevation: 0,
        ),
        body: Column(
          children: [

          ],
        ),
      ),
    ));
}

  @override
  Widget build(BuildContext context) {
    final currentWeek = WeekDates().weekNumber(DateTime.now());
    final locale = Localizations.localeOf(context).languageCode;
    final l10n = AppLocalizations.of(context)!;
    return SafeArea(
        child:ValueListenableBuilder<Map<DateTime,int>>(
            valueListenable: showSalesByDate,
            builder: (context,counts,_) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: 20),
                  Center(child:
                  Text("${l10n.week}: $currentWeek",
                    style: Theme
                        .of(context)
                        .textTheme
                        .headlineSmall,)),
                  Text("${l10n.weekSales}: 10", style:
                  TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  SizedBox(height: 20),
                  Expanded(
                      child: ListView(
                          children: List.generate(7, (index) {
                            final date = WeekDates().getWeekDates(DateTime.now())[index];
                            final day = DateFormat("EEEE", locale).format(date);
                            final buttonDate = "$day ${date.day}/${date.month}";
                            final normalized = DateTime(date.year, date.month, date.day);
                            final count = counts[normalized] ?? 0;
                            return WeekdayButton(
                                dateLabel: buttonDate,
                                saleTotal: count, onClicked: () =>
                                    onClickedDay(context, buttonDate));
                          })
                      )
                  )
                ],
              );
            }
              ));
            }
  }
