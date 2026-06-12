import 'package:faida_pos/l10n/app_localizations.dart';
import 'package:flutter/material.dart';

class DailyReport extends StatelessWidget {
  const DailyReport({super.key});

  @override
  Widget build(BuildContext context) {
    int sales = 10000;
    int expenses = 4000;
    int transactions = 3;
    int itemsSold = 23;
    int avgSale = 4355;
    int netProfit = sales - expenses;
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: Colors.white,
      body:
          SingleChildScrollView(
            child:
                SafeArea(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(height: 30),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("${l10n.sales}:",style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                        Text("TZS $sales" ,style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18))
                      ]
                    ),
                  SizedBox(height: 30),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("${l10n.expenses}:" ,style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                      Text("TZS $expenses" ,style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18))
                    ]
                  ),
                    SizedBox(height: 30),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(netProfit >= 0 ? "${l10n.netProf}:" : "${l10n.netLoss}:" ,style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                          Text("TZS ${netProfit.abs()}" ,style:
                          TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18, color: netProfit >= 0 ? Colors.green : Colors.red))
                        ]
                    ),
                    SizedBox(height: 10),
                    Divider(),
                    SizedBox(height: 10),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("${l10n.transactions}:" ,style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                          Text("$transactions" ,style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18))
                        ]
                    ),
                    SizedBox(height: 30),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("${l10n.productsSold}:" ,style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                          Text("$itemsSold" ,style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18))
                        ]
                    ),
                    SizedBox(height: 30),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("${l10n.avgSale}:" ,style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                          Text("TZS $avgSale" ,style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18))
                        ]
                    )
                  ],
                ),
                ),
          )
    );
  }
}
