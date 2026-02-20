import 'package:faida_pos/l10n/app_localizations.dart';
import 'package:faida_pos/utils/transaction_utils/week_dates.dart';
import 'package:faida_pos/widgets/transaction_widgets/weekday_button.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../models/sale.dart';

class WeekWidget extends StatelessWidget {
  final ValueNotifier<Map<DateTime, int>> showSalesByDate;
  final ValueNotifier<List<Sale>> salesOnSelected;
  final Function(DateTime) loadWeekdaySales;
  final Function(Sale) detailedSale;


  const WeekWidget({
    super.key,
    required this.showSalesByDate,
    required this.loadWeekdaySales,
    required this.detailedSale,
    required this.salesOnSelected});


  void onClickedDay(BuildContext context, String buttonDate, DateTime date) {
    final l10n = AppLocalizations.of(context)!;
    final locale = Localizations.localeOf(context).languageCode;
    loadWeekdaySales(date);
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
            Divider(),
            Expanded(
                child: Padding(padding: EdgeInsets.all(9),
                    child:
                    ValueListenableBuilder(
                        valueListenable: salesOnSelected,
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
                                        onPressed: () => detailedSale(sale),
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
                    style: Theme.of(context).textTheme.headlineSmall,)),
                  Text("${l10n.weekSales}: "
                      "${showSalesByDate.value.values.fold(0, (sum, count) => sum + count )}",
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
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
                                    onClickedDay(context, buttonDate, normalized));
                          })
                      )
                  )
                ],
              );
            }
              ));
            }
  }
