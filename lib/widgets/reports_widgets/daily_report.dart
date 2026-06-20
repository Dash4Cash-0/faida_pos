import 'package:faida_pos/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DailyReport extends StatefulWidget {
  const DailyReport({super.key});

  @override
  State<DailyReport> createState() => _DailyReportState();
}

class _DailyReportState extends State<DailyReport> {
  final TextEditingController expensesController = TextEditingController();
  final List<String> expenseCategories = [
    "Rent",
    "Electricity",
    "Water",
    "Internet",
    "Phone / Airtime",
    "Security / Guard",
    "Insurance",
    "Salaries / Wages",
    "Transport Allowance",
    "Equipment Repair",
    "Cleaning Supplies",
    "Packaging / Bags",
    "Marketing / Advertising",
    "Bank / Mobile Money Fees",
    "Licenses / Permits",
    "Taxes",
    "Other",
  ];

  void addExpenses(double fontSize, double titleSize) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    showDialog(context: context,
        builder: (_) => StatefulBuilder(
          builder: (context, setDialogState) => Dialog(
            backgroundColor: Colors.white,
            child: Padding(padding: EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text("Add Expense", style:
                  TextStyle(fontWeight: FontWeight.bold,
                      fontSize: titleSize)),
                  SizedBox(height: 30),
                  DropdownMenu<String>(
                    controller: expensesController,
                    enableFilter: true,
                    width: screenWidth - 80,
                    menuHeight: screenHeight * 0.35,
                    onSelected: (value) => setDialogState(() {}),
                    dropdownMenuEntries: expenseCategories
                        .map((e) => DropdownMenuEntry(value: e, label: e))
                        .toList(),
                  ),
                  if (expensesController.text == "Other") ...[
                    SizedBox(height: 16),
                    TextField(decoration: InputDecoration(border: OutlineInputBorder())),
                  ],
                  SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ));
  }

  @override
  void dispose(){
    expensesController.dispose();
    super.dispose();

  }

  @override
  Widget build(BuildContext context) {
    int sales = 10000;
    int expenses = 4000;
    int transactions = 3;
    int itemsSold = 23;
    int avgSale = 4355;
    int netProfit = sales - expenses;
    final formatted = DateFormat('EEEE d/M').format(DateTime.now());
    final l10n = AppLocalizations.of(context)!;
    final screenWidth = MediaQuery.of(context).size.width;
    final fontSize = screenWidth * 0.045;
    final titleSize = screenWidth * 0.06;
    return Scaffold(
      backgroundColor: Colors.white,
      body:
          SingleChildScrollView(
            child:
                SafeArea(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(height: 10),
                    Text(formatted, style: TextStyle(fontWeight: FontWeight.bold, fontSize: titleSize)),
                    SizedBox(height: 30),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("${l10n.sales}:",style: TextStyle(fontWeight: FontWeight.bold, fontSize: fontSize)),
                        Text("TZS $sales" ,style: TextStyle(fontWeight: FontWeight.bold, fontSize: fontSize))
                      ]
                    ),
                  SizedBox(height: 30),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("${l10n.expenses}:" ,style: TextStyle(fontWeight: FontWeight.bold, fontSize: fontSize)),
                      Text("TZS $expenses" ,style: TextStyle(fontWeight: FontWeight.bold, fontSize: fontSize))
                    ]
                  ),
                    SizedBox(height: 30),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(netProfit >= 0 ? "${l10n.netProf}:" : "${l10n.netLoss}:" ,style: TextStyle(fontWeight: FontWeight.bold, fontSize: fontSize)),
                          Text("TZS ${netProfit.abs()}" ,style:
                          TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: fontSize, color: netProfit >= 0 ? Colors.green : Colors.red))
                        ]
                    ),
                    SizedBox(height: 10),
                    Divider(),
                    SizedBox(height: 10),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("${l10n.transactions}:" ,style: TextStyle(fontWeight: FontWeight.bold, fontSize: fontSize)),
                          Text("$transactions" ,style: TextStyle(fontWeight: FontWeight.bold, fontSize: fontSize))
                        ]
                    ),
                    SizedBox(height: 30),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("${l10n.productsSold}:" ,style: TextStyle(fontWeight: FontWeight.bold, fontSize: fontSize)),
                          Text("$itemsSold" ,style: TextStyle(fontWeight: FontWeight.bold, fontSize: fontSize))
                        ]
                    ),
                    SizedBox(height: 30),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("${l10n.avgSale}:" ,style: TextStyle(fontWeight: FontWeight.bold, fontSize: fontSize)),
                          Text("TZS $avgSale" ,style: TextStyle(fontWeight: FontWeight.bold, fontSize: fontSize))
                        ]
                    ),
                    Divider(),
                    SizedBox(height: 30),
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () => addExpenses(fontSize, titleSize),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              foregroundColor: Colors.black,
                              side: BorderSide(color: Colors.black, width: 1),
                              textStyle: TextStyle(fontSize: fontSize, fontWeight: FontWeight.bold),
                            ),
                            child: Text(l10n.addExpense, textAlign: TextAlign.center),
                          ),
                        ),
                        SizedBox(width: 12),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {},
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              foregroundColor: Colors.black,
                              side: BorderSide(color: Colors.black, width: 1),
                              textStyle: TextStyle(fontSize: fontSize, fontWeight: FontWeight.bold),
                            ),
                            child: Text(l10n.showExpenses, textAlign: TextAlign.center),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
                ),
          )
    );
  }
}
