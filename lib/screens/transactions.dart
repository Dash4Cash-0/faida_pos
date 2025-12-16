import 'package:faida_pos/widgets/shared/tab_config.dart';
import 'package:faida_pos/widgets/shared/tabs_widget.dart';
import 'package:faida_pos/widgets/transaction_widgets/calendar_widget.dart';
import 'package:faida_pos/widgets/transaction_widgets/today_widget.dart';
import 'package:faida_pos/widgets/transaction_widgets/week_widget.dart';
import 'package:flutter/material.dart';

class Transactions extends StatefulWidget {
  const Transactions({super.key});

  @override
  State<Transactions> createState() => _TransactionsState();
}

final tabs = [
  () => TodayWidget(),
  () => WeekWidget(),
  () => CalendarWidget()
];

int _currentIndex = 0;

class _TransactionsState extends State<Transactions> {
  @override
  Widget build(BuildContext context) {
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
                      _currentIndex == index;
                    });
                  },
                  tabs: const[
                    TabConfig("Today"),
                    TabConfig("This Week"),
                    TabConfig("Calendar"),
                  ]
                  ),
              Expanded(child: tabs[_currentIndex]()),
            ],
          )),
    );
  }
}

