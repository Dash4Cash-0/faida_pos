import 'package:faida_pos/models/sale.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
class TodayWidget extends StatelessWidget {
  final ValueNotifier <List<Sale>> soldItems;


  const TodayWidget({
    super.key, required
    this.soldItems});

  @override
  Widget build(BuildContext context)  {
    final locale = Localizations.localeOf(context).languageCode;
    DateTime now = DateTime.now();
    String dateFormat = DateFormat('EEEE, d MMMM yyyy', locale).format(now);

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 20),
            Center(
              child: Text(dateFormat,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headlineSmall)
            ),
            Expanded(
              child: Padding(padding: EdgeInsets.all(9),
              child:
                  ValueListenableBuilder(
                      valueListenable: soldItems, builder: (context, sales, _) {
                if (sales.isEmpty) {
                  return Text("No sales today");
                }
                return Expanded(child: ListView.separated(
                    itemCount: sales.length,
                    separatorBuilder: (_, __) => Divider(),
                    itemBuilder: (context, index) {
                      final sale = sales[index];
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              "TZS ${sale.total}",
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                          Text(
                            DateFormat.Hm(locale)
                                .format(sale.createdAt),
                          ),
                        ],
                      );
                    }
                    )
                );
              }
                  )
              )),
          ],
      )),
    );
  }
}
