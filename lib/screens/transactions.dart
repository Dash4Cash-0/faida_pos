
import 'package:faida_pos/l10n/app_localizations.dart';
import 'package:faida_pos/services/database_service.dart';
import 'package:faida_pos/widgets/shared/tab_config.dart';
import 'package:faida_pos/widgets/shared/tabs_widget.dart';
import 'package:faida_pos/widgets/transaction_widgets/calendar_widget.dart';
import 'package:faida_pos/widgets/transaction_widgets/today_widget.dart';
import 'package:faida_pos/widgets/transaction_widgets/week_widget.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/sale.dart';
import '../models/sale_item.dart';
import '../utils/transaction_utils/week_dates.dart';

class Transactions extends StatefulWidget {
  const Transactions({super.key});

  @override
  State<Transactions> createState() => _TransactionsState();
}


class _TransactionsState extends State<Transactions> {

  late final ValueNotifier<List<Sale>> _showSalesByDate
  = ValueNotifier<List<Sale>>([]);

  late final ValueNotifier<Set<DateTime>> _daysWithSales
  = ValueNotifier<Set<DateTime>>({});

  final ValueNotifier<Map<DateTime, int>> _salesCountByDate =
  ValueNotifier({});

  final dates = WeekDates().getWeekDates(DateTime.now());
  DateTime _focusedDay = DateTime.now();

  late final tabs = [
    () => TodayWidget(
      soldItems: _showSalesByDate,
      showDetailedSale: _showDetailedSale),
    () => WeekWidget(
        showSalesByDate: _salesCountByDate,
      loadWeekdaySales: _loadSalesForDate,),
    () => CalendarWidget(
        daysWithSales: _daysWithSales,
        onMonthChanged: _loadSalesForMonth,
        salesOnSelected: _showSalesByDate,
        onSelectedChanged:_loadSalesForDate,
        detailedSale: _showDetailedSale)
  ];

int _currentIndex = 0;

  @override
  void initState(){
    super.initState();
    _loadTodaySales();
    _loadCurrentMonthSales();
    _loadWeekSales(dates);
  }

  void _showDetailedSale(Sale sale) async{
    List<SaleItem> saleItems = [];
    final l10n = AppLocalizations.of(context)!;

    if(sale.id != null){
      saleItems = await DatabaseService.instance.getSaleItems(sale.id!);
    }

    final isQuickSale = saleItems.isEmpty;
    if(!mounted) return;
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(child:
            Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.white,
              title: Text(l10n.saleDetails),
              leading: IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: Icon(Icons.close)),
            ),backgroundColor: Colors.white,
              body: Padding(padding: EdgeInsets.all(16),
                child: Column(
                    children: [
                   Text('${l10n.total}: TZS ${sale.total}',
                     style: TextStyle(
                         fontWeight: FontWeight.bold,
                         fontSize: 20)),
                      SizedBox(height: 8),
                      Text('${l10n.date}: ${DateFormat('EEEE, d MMMM yyyy HH:mm').format(sale.createdAt)}'),
                      if(!isQuickSale) ...[
                        Text("${l10n.amountReceived}: TZS ${sale.amountReceived}"),
                        Text("${l10n.change}: TZS ${sale.change}")
                      ],
                      SizedBox(height: 16),
                      Divider(),
                      SizedBox(height: 8),
                      if(isQuickSale) ...[
                        Center(
                          child: Column(
                            children: [
                              Icon(Icons.flash_on, size: 48, color: Colors.orange),
                              SizedBox(height: 8),
                              Text(l10n.quickSale,
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold)),
                              SizedBox(height: 4),
                              Text(l10n.noItemDetails)
                            ],
                          ),
                        ),
                      ] else ... [
                        Text(l10n.itemsCap,
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold)),
                        SizedBox(height: 8),
                        Expanded(child: 
                        ListView.builder(itemCount: saleItems.length,
                            itemBuilder: (context, index) {
                          final item = saleItems[index];
                          return ListTile(
                            title: Text(item.name),
                            subtitle: Text("${l10n.quantity}: ${item.quantity} x TZS ${item.price}"),
                            trailing: Text(
                              "TZS ${item.subtotal}",style: TextStyle(
                              fontWeight: FontWeight.bold
                            ),
                            ),
                          );
                            }))
                      ]
                ])),
          )
          );
        });

  }

  Future<void> _loadTodaySales() async {
    final sales = await DatabaseService.instance.getSalesByDate(DateTime.now());
    _showSalesByDate.value = sales;
  }

  Future<void> _loadCurrentMonthSales() async {
    final now = DateTime.now();
    await _loadSalesForMonth(now);
  }

  Future<void>_loadSalesForDate(DateTime date) async {
    final sales = await DatabaseService.instance.getSalesByDate(date);
    _showSalesByDate.value = sales;
  }

  Future<void> _loadWeekSales(List<DateTime> dates) async{
    final Map<DateTime, int> counts = {};

    for(final date in dates){
      final sales = await DatabaseService.instance.getSalesByDate(date);
      counts[DateTime(date.year, date.month, date.day)] = sales.length;
    }
    _salesCountByDate.value = counts;
  }

  Future<void> _loadSalesForMonth(DateTime month) async {
    _focusedDay = month;

    final firstDay = DateTime(month.year, month.month, 1);
    final lastDay = DateTime(month.year, month.month + 1, 0, 23, 59, 59);
    final sales = await DatabaseService.instance.getSalesInDateRange(firstDay, lastDay);

    final uniqueDates = sales.map((sale) {
      final date = sale.createdAt;
      return DateTime(date.year,date.month,date.day);
    }).toSet();
    _daysWithSales.value = uniqueDates;
  }

  void _onTabChanged(int index) {
    setState(() {
      _currentIndex = index;
    });
    if (index == 2) {
      _loadSalesForMonth(_focusedDay);
    }
    if (index == 0){
      _loadTodaySales();
    }
  }


  @override
  void dispose() {
    _showSalesByDate.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
          child:Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
                  TabsWidget(
                  currentIndex: _currentIndex,
                  onSelectedTab: _onTabChanged,
                  tabs: [
                    TabConfig(l10n.today),
                    TabConfig(l10n.thisWeek),
                    TabConfig(l10n.calendar),
                  ]
                  ),
              Expanded(child: tabs[_currentIndex]()),
            ],
          )),
    );
  }
}

