import 'package:faida_pos/controllers/reports_controller.dart';
import 'package:faida_pos/l10n/app_localizations.dart';
import 'package:faida_pos/models/expense_model.dart';
import 'package:faida_pos/services/database_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class DailyReport extends StatefulWidget {
  const DailyReport({super.key});

  @override
  State<DailyReport> createState() => _DailyReportState();
}

class _DailyReportState extends State<DailyReport> {
  final TextEditingController expensesController = TextEditingController();
  final TextEditingController otherExpense = TextEditingController();
  final TextEditingController expenseDesc = TextEditingController();
  final TextEditingController expenseCost = TextEditingController();
  DateTime _selectedDate = DateTime.now();

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
  @override
  void initState(){
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ReportsController>().load(_selectedDate);
    });
  }

  void addExpenses(double fontSize, double titleSize, AppLocalizations l10n) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    showDialog(context: context,
        builder: (_) => StatefulBuilder(
          builder: (context, setDialogState) => Dialog(
            backgroundColor: Colors.white,
            child: Padding(padding: EdgeInsets.all(20),
              child: SingleChildScrollView(child:
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text("Add Expense", style:
                  TextStyle(fontWeight: FontWeight.bold,
                      fontSize: titleSize)),
                  SizedBox(height: 30),
                  DropdownMenu<String>(
                    controller: expensesController,
                    menuStyle: MenuStyle(
                        backgroundColor: WidgetStatePropertyAll(Colors.white),
                        side: WidgetStatePropertyAll(BorderSide(color: Colors.black, width: 1, style: BorderStyle.solid))),
                    enableFilter: true,
                    label: Text("Category"),
                    width: screenWidth - 80,
                    menuHeight: screenHeight * 0.35,
                    onSelected: (value) => setDialogState(() {}),
                    dropdownMenuEntries: expenseCategories
                        .map((e) => DropdownMenuEntry(value: e, label: e))
                        .toList(),
                  ),
                  if (expensesController.text == "Other") ...[
                    SizedBox(height: 16),
                    TextFormField(
                      controller: otherExpense,
                        maxLength: 30,
                        decoration: InputDecoration(
                            label: Text("What kind of expense?"),
                            border: OutlineInputBorder())),
                  ],
                SizedBox(height: 16),
                  TextFormField(
                    controller: expenseDesc,
                    maxLength: 100,
                    decoration: InputDecoration(
                      label: Text(l10n.description),
                      border: OutlineInputBorder())),
                  SizedBox(height: 16),
                  TextFormField(
                      controller: expenseCost,
                      inputFormatters: [
                        LengthLimitingTextInputFormatter(30)
                      ],
                      decoration: InputDecoration(
                          label: Text("Cost"),
                          border: OutlineInputBorder())),
                  SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(child:
                      ElevatedButton(
                        onPressed: () {
                            saveExpense(int.parse(expenseCost.text), expensesController.text, expenseDesc.text);
                            Navigator.pop(context);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: Colors.black,
                          side: BorderSide(color: Colors.black, width: 1),
                          textStyle: TextStyle(fontSize: fontSize, fontWeight: FontWeight.bold),
                        ), child: Text("Save", textAlign: TextAlign.center))),
                      SizedBox(width: 10),
                      Expanded(child:
                      ElevatedButton(
                          onPressed: () => Navigator.pop(context),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: Colors.black,
                            side: BorderSide(color: Colors.black, width: 1),
                            textStyle: TextStyle(fontSize: fontSize, fontWeight: FontWeight.bold),
                          ), child: Text("Cancel", textAlign: TextAlign.center)))
                    ],
                  )
                ],
              ),
            ),
          ),
        )));
  }

  void saveExpense(int cost, String category, String desc) async{
    if (desc.isEmpty){
      desc = "No description";
    }
    final created = DateTime.now();
    final expense = Expense(expCost: cost, expCategory: category, expDesc: desc, createdAt: created);
    try{
      await DatabaseService.instance.insertExpense(expense);
      if (mounted) context.read<ReportsController>().load();
    }catch(e){
      print("Something went wrong");
    }
  }

  void nextDay() {
    setState(() => _selectedDate = _selectedDate.add(Duration(days: 1)));
    context.read<ReportsController>().load(_selectedDate);
  }

  void previousDay() {
    setState(() => _selectedDate = _selectedDate.subtract(Duration(days: 1)));
    context.read<ReportsController>().load(_selectedDate);
  }

  @override
  void dispose(){
    expensesController.dispose();
    otherExpense.dispose();
    expenseDesc.dispose();
    expenseCost.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final reports = context.watch<ReportsController>();
    final sales = reports.sales;
    final expenses = reports.expenses;
    final itemsSold = reports.itemsSold;
    final avgSale = reports.avgSale;
    final netProfit = reports.netProfit;
    final transactions = reports.transactions;
    final formatted = DateFormat('EEEE d/M').format(_selectedDate);
    final isToday = DateUtils.isSameDay(_selectedDate, DateTime.now());
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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        IconButton(onPressed: previousDay, icon: Icon(Icons.arrow_back_ios)),
                        Text(formatted, style: TextStyle(fontWeight: FontWeight.bold, fontSize: titleSize)),
                        IconButton(onPressed: isToday ? null : nextDay, icon: Icon(Icons.arrow_forward_ios)),
                      ],
                    ),
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
                            onPressed: () => addExpenses(fontSize, titleSize, l10n),
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
