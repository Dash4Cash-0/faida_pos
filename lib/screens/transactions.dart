
import 'package:faida_pos/l10n/app_localizations.dart';
import 'package:faida_pos/services/database_service.dart';
import 'package:faida_pos/widgets/shared/tab_config.dart';
import 'package:faida_pos/widgets/shared/tabs_widget.dart';
import 'package:faida_pos/widgets/transaction_widgets/calendar_widget.dart';
import 'package:faida_pos/widgets/transaction_widgets/today_widget.dart';
import 'package:faida_pos/widgets/transaction_widgets/week_widget.dart';
import 'package:flutter/material.dart';

import '../models/sale.dart';

class Transactions extends StatefulWidget {
  const Transactions({super.key});

  @override
  State<Transactions> createState() => _TransactionsState();
}


class _TransactionsState extends State<Transactions> {

  late Future<List<Sale>> _salesFuture;
  late final ValueNotifier<List<Sale>> _salesToday
  = ValueNotifier<List<Sale>>([]);

  late final tabs = [
    () => TodayWidget(soldItems: _salesToday),
    () => WeekWidget(),
    () => CalendarWidget()
  ];

int _currentIndex = 0;

  @override
  void initState(){
    super.initState();
    _salesFuture = DatabaseService.instance.getTodaySales();
    _loadTodaySales();
  }

  Future<void> _loadTodaySales() async {
    final sales = await DatabaseService.instance.getTodaySales();
    _salesToday.value = sales;
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
                  onSelectedTab: (index) {
                    setState(() {
                      _currentIndex = index;
                    });
                  },
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

