import 'package:faida_pos/l10n/app_localizations.dart';
import 'package:faida_pos/models/sale.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
class TodayWidget extends StatelessWidget {
  final ValueNotifier <List<Sale>> soldItems;
  final Function(Sale) showDetailedSale;


  const TodayWidget({
    super.key,
    required this.soldItems,
    required this.showDetailedSale});

  @override
  Widget build(BuildContext context)  {
    final l10n = AppLocalizations.of(context)!;
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
                                  onPressed: () => showDetailedSale(sale),
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
              )),
          ],
      )),
    );
  }
}
