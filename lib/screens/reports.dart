import 'package:faida_pos/widgets/reports_widgets/daily_report.dart';
import 'package:faida_pos/widgets/reports_widgets/monthly_report.dart';
import 'package:faida_pos/widgets/reports_widgets/weekly_report.dart';
import 'package:faida_pos/widgets/reports_widgets/yearly_report.dart';
import 'package:faida_pos/widgets/shared/tab_config.dart';
import 'package:faida_pos/widgets/shared/tabs_widget.dart';
import 'package:flutter/material.dart';

import '../l10n/app_localizations.dart';

class Reports extends StatefulWidget {
  const Reports({super.key});

  @override
  State<Reports> createState() => _ReportsState();
}

class _ReportsState extends State<Reports> {

  late final tabs = [
    () => DailyReport(),
    () => WeeklyReport(),
    () => MonthlyReport(),
    () => YearlyReport(),
  ];

  int _currentIndex = 0;

  void _onTabChanged(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TabsWidget(
                  currentIndex: _currentIndex,
                  onSelectedTab: _onTabChanged,
                  tabs: [
                    TabConfig(l10n.daily),
                    TabConfig(l10n.weekly),
                    TabConfig(l10n.monthly),
                    TabConfig(l10n.yearly)]),
              Expanded(child: tabs[_currentIndex]())
            ],
          )),
    );
  }
}