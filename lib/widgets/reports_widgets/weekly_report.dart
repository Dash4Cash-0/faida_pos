import 'package:faida_pos/controllers/reports_controller.dart';
import 'package:faida_pos/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class WeeklyReport extends StatefulWidget {
  const WeeklyReport({super.key});

  @override
  State<WeeklyReport> createState() => _WeeklyReportState();
}

class _WeeklyReportState extends State<WeeklyReport> {
  late DateTime _weekStart;

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _weekStart = now.subtract(Duration(days: now.weekday - 1));
    _weekStart = DateTime(_weekStart.year, _weekStart.month, _weekStart.day);
    WidgetsBinding.instance.addPostFrameCallback((_) => _load());
  }

  DateTime get _weekEnd => _weekStart.add(const Duration(days: 7));

  bool get _isCurrentWeek {
    final now = DateTime.now();
    final currentWeekStart = now.subtract(Duration(days: now.weekday - 1));
    return DateUtils.isSameDay(_weekStart, DateTime(currentWeekStart.year, currentWeekStart.month, currentWeekStart.day));
  }

  void _load() {
    context.read<ReportsController>().loadRange(_weekStart, _weekEnd);
  }

  void _previousWeek() {
    setState(() => _weekStart = _weekStart.subtract(const Duration(days: 7)));
    _load();
  }

  void _nextWeek() {
    setState(() => _weekStart = _weekStart.add(const Duration(days: 7)));
    _load();
  }

  int get _weekNumber {
    final dayOfYear = int.parse(DateFormat('D').format(_weekStart));
    return ((dayOfYear - _weekStart.weekday + 10) / 7).floor();
  }

  String get _formattedRange {
    final weekEnd = _weekStart.add(const Duration(days: 6));
    final fmt = DateFormat('d/M');
    return 'W$_weekNumber  ${fmt.format(_weekStart)} - ${fmt.format(weekEnd)}';
  }

  @override
  Widget build(BuildContext context) {
    final reports = context.watch<ReportsController>();
    final l10n = AppLocalizations.of(context)!;
    final screenWidth = MediaQuery.of(context).size.width;
    final fontSize = screenWidth * 0.045;
    final titleSize = screenWidth * 0.06;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  IconButton(onPressed: _previousWeek, icon: const Icon(Icons.arrow_back_ios)),
                  Text(_formattedRange, style: TextStyle(fontWeight: FontWeight.bold, fontSize: titleSize)),
                  IconButton(onPressed: _isCurrentWeek ? null : _nextWeek, icon: const Icon(Icons.arrow_forward_ios)),
                ],
              ),
              const SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("${l10n.sales}:", style: TextStyle(fontWeight: FontWeight.bold, fontSize: fontSize)),
                  Text("TZS ${reports.sales}", style: TextStyle(fontWeight: FontWeight.bold, fontSize: fontSize)),
                ],
              ),
              const SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("${l10n.expenses}:", style: TextStyle(fontWeight: FontWeight.bold, fontSize: fontSize)),
                  Text("TZS ${reports.expenses}", style: TextStyle(fontWeight: FontWeight.bold, fontSize: fontSize)),
                ],
              ),
              const SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(reports.netProfit >= 0 ? "${l10n.netProf}:" : "${l10n.netLoss}:", style: TextStyle(fontWeight: FontWeight.bold, fontSize: fontSize)),
                  Text("TZS ${reports.netProfit.abs()}", style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: fontSize,
                    color: reports.netProfit >= 0 ? Colors.green : Colors.red,
                  )),
                ],
              ),
              const SizedBox(height: 10),
              const Divider(),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("${l10n.transactions}:", style: TextStyle(fontWeight: FontWeight.bold, fontSize: fontSize)),
                  Text("${reports.transactions}", style: TextStyle(fontWeight: FontWeight.bold, fontSize: fontSize)),
                ],
              ),
              const SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("${l10n.productsSold}:", style: TextStyle(fontWeight: FontWeight.bold, fontSize: fontSize)),
                  Text("${reports.itemsSold}", style: TextStyle(fontWeight: FontWeight.bold, fontSize: fontSize)),
                ],
              ),
              const SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("${l10n.avgSale}:", style: TextStyle(fontWeight: FontWeight.bold, fontSize: fontSize)),
                  Text("TZS ${reports.avgSale}", style: TextStyle(fontWeight: FontWeight.bold, fontSize: fontSize)),
                ],
              ),
              const Divider(),
            ],
          ),
        ),
      ),
    );
  }
}
