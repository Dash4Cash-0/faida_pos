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

  String _translateCategory(String key, AppLocalizations l10n) {
    switch (key) {
      case "Rent": return l10n.catRent;
      case "Electricity": return l10n.catElectricity;
      case "Water": return l10n.catWater;
      case "Internet": return l10n.catInternet;
      case "Phone / Airtime": return l10n.catPhoneAirtime;
      case "Security / Guard": return l10n.catSecurity;
      case "Insurance": return l10n.catInsurance;
      case "Salaries / Wages": return l10n.catSalaries;
      case "Transport Allowance": return l10n.catTransport;
      case "Equipment Repair": return l10n.catEquipmentRepair;
      case "Cleaning Supplies": return l10n.catCleaningSupplies;
      case "Packaging / Bags": return l10n.catPackaging;
      case "Marketing / Advertising": return l10n.catMarketing;
      case "Bank / Mobile Money Fees": return l10n.catBankFees;
      case "Licenses / Permits": return l10n.catLicenses;
      case "Taxes": return l10n.catTaxes;
      case "Other": return l10n.catOther;
      default: return key;
    }
  }
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
                  Text(l10n.addExpense, style:
                  TextStyle(fontWeight: FontWeight.bold,
                      fontSize: titleSize)),
                  SizedBox(height: 30),
                  DropdownMenu<String>(
                    controller: expensesController,
                    menuStyle: MenuStyle(
                        backgroundColor: WidgetStatePropertyAll(Colors.white),
                        side: WidgetStatePropertyAll(BorderSide(color: Colors.black, width: 1, style: BorderStyle.solid))),
                    enableFilter: true,
                    label: Text(l10n.category),
                    width: screenWidth - 80,
                    menuHeight: screenHeight * 0.35,
                    onSelected: (value) => setDialogState(() {}),
                    dropdownMenuEntries: expenseCategories
                        .map((e) => DropdownMenuEntry(value: e, label: _translateCategory(e, l10n)))
                        .toList(),
                  ),
                  if (expensesController.text == "Other" || expensesController.text == "Nyingine") ...[
                    SizedBox(height: 16),
                    TextFormField(
                      controller: otherExpense,
                        maxLength: 30,
                        decoration: InputDecoration(
                            label: Text(l10n.whatKindExpense),
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
                          label: Text(l10n.cost),
                          border: OutlineInputBorder())),
                  SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(child:
                      ElevatedButton(
                        onPressed: () {
                            saveExpense(int.parse(expenseCost.text), expensesController.text, expenseDesc.text, l10n);
                            Navigator.pop(context);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: Colors.black,
                          side: BorderSide(color: Colors.black, width: 1),
                          textStyle: TextStyle(fontSize: fontSize, fontWeight: FontWeight.bold),
                        ), child: Text(l10n.save, textAlign: TextAlign.center))),
                      SizedBox(width: 10),
                      Expanded(child:
                      ElevatedButton(
                          onPressed: () => Navigator.pop(context),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: Colors.black,
                            side: BorderSide(color: Colors.black, width: 1),
                            textStyle: TextStyle(fontSize: fontSize, fontWeight: FontWeight.bold),
                          ), child: Text(l10n.cancel, textAlign: TextAlign.center)))
                    ],
                  )
                ],
              ),
            ),
          ),
        )));
  }

  void saveExpense(int cost, String category, String desc, AppLocalizations l10n) async{
    if (desc.isEmpty){
      desc = "No description";
    }
    final created = DateTime.now();
    final expense = Expense(expCost: cost, expCategory: category, expDesc: desc, createdAt: created);
    try{
      await DatabaseService.instance.insertExpense(expense);
      if (mounted) context.read<ReportsController>().load(_selectedDate);
    }catch(e){
      if(!mounted) return;
      showDialog(
          context: context,
          builder: (_) => AlertDialog(
            backgroundColor: Colors.red,
            title: Text(l10n.error),
            content: Text(l10n.wentWrong,
                style: TextStyle(fontSize: 16)),
            actions: [
              ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.black,
                    backgroundColor: Colors.white,
                    side: BorderSide(
                        color: Colors.black,
                        width: 1, style:
                    BorderStyle.solid)
                ),
                child: Text(l10n.ok),)
            ],
          ));
    }
  }

  void showExpenses(double fontSize, double titleSize) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      builder: (ctx) => Consumer<ReportsController>(
        builder: (context, reports, child) {
          final l10n = AppLocalizations.of(context)!;
          return Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(l10n.expenses, style: TextStyle(fontWeight: FontWeight.bold, fontSize: titleSize)),
              const SizedBox(height: 12),
              if (reports.expensesList.isEmpty)
                Text(l10n.noExpensesDay, style: TextStyle(fontSize: fontSize))
              else
                Expanded(
                  child: ListView.separated(
                    itemCount: reports.expensesList.length,
                    separatorBuilder: (context, index) => const Divider(),
                    itemBuilder: (_, i) {
                      final e = reports.expensesList[i];
                      return ListTile(
                        contentPadding: EdgeInsets.zero,
                        title: Text(_translateCategory(e.expCategory, l10n), style: TextStyle(fontWeight: FontWeight.bold, fontSize: fontSize)),
                        trailing: Text("TZS ${e.expCost}", style: TextStyle(fontSize: fontSize)),
                        onTap: () {
                          showExpenseDetails(_translateCategory(e.expCategory, l10n), e.expDesc ?? '', e.expCost, fontSize, titleSize, l10n);
                        },
                        onLongPress: () {
                          showDialog(
                            context: context,
                            builder: (_) => AlertDialog(
                              backgroundColor: Colors.red,
                              title: Text(l10n.deleteExpense),
                              content: Text(l10n.deleteExpenseConfirm,
                                  style: TextStyle(fontSize: fontSize)),
                              actions: [
                                Row(
                                  children: [
                                    Expanded(child:
                                      ElevatedButton(
                                        onPressed: () async {
                                          Navigator.pop(context);
                                          await DatabaseService.instance.deleteExpense(e.id!);
                                          if (mounted) this.context.read<ReportsController>().load(_selectedDate);
                                        },
                                        style: ElevatedButton.styleFrom(
                                          foregroundColor: Colors.black,
                                          backgroundColor: Colors.white,
                                          side: BorderSide(color: Colors.black, width: 1, style: BorderStyle.solid),
                                        ),
                                        child: Text(l10n.yes))),
                                    SizedBox(width: 10),
                                    Expanded(child:
                                      ElevatedButton(
                                        onPressed: () => Navigator.pop(context),
                                        style: ElevatedButton.styleFrom(
                                          foregroundColor: Colors.black,
                                          backgroundColor: Colors.white,
                                          side: BorderSide(color: Colors.black, width: 1, style: BorderStyle.solid),
                                        ),
                                        child: Text(l10n.no))),
                                  ],
                                )
                              ],
                            ));
                        },
                      );
                    },
                  ),
                ),
            ],
          ),
        );
        },
      ),
    );
  }

  void showExpenseDetails(String expenseCategory, String expenseDescription,
      int expenseCost, double fontSize, double titleSize, AppLocalizations l10n) {
    showDialog(context: context,
        builder: (_) => Dialog(
          backgroundColor: Colors.white,
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(expenseCategory, style: TextStyle(fontWeight: FontWeight.bold, fontSize: titleSize)),
                SizedBox(height: 16),
                if (expenseDescription.isNotEmpty)
                  Text(expenseDescription, style: TextStyle(fontSize: fontSize, color: Colors.grey)),
                SizedBox(height: 16),
                Text("TZS $expenseCost", style: TextStyle(fontSize: fontSize, fontWeight: FontWeight.bold)),
                SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.black,
                      backgroundColor: Colors.white,
                      side: BorderSide(color: Colors.black, width: 1, style: BorderStyle.solid),
                      textStyle: TextStyle(fontSize: fontSize, fontWeight: FontWeight.bold),
                    ),
                    child: Text(l10n.ok)),
                )
              ],
            ),
          )
        ));
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
                            onPressed: () => showExpenses(fontSize, titleSize),
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
