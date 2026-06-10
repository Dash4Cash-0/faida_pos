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
                        Text("Sales:",style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                        Text("TZS $sales" ,style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18))
                      ]
                    ),
                  SizedBox(height: 30),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Expenses:" ,style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                      Text("TZS $expenses" ,style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18))
                    ]
                  ),
                    SizedBox(height: 30),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(netProfit >= 0 ? "Net Profit:" : "Net Loss" ,style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
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
                          Text("Transactions:" ,style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                          Text("$transactions" ,style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18))
                        ]
                    ),
                    SizedBox(height: 30),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Products sold" ,style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                          Text("$itemsSold" ,style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18))
                        ]
                    ),
                    SizedBox(height: 30),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Average Sale:" ,style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
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
