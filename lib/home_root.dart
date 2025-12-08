import 'package:faida_pos/screens/checkout.dart';
import 'package:faida_pos/screens/menu.dart';
import 'package:faida_pos/screens/notifications.dart';
import 'package:faida_pos/screens/reports.dart';
import 'package:faida_pos/screens/transactions.dart';
import 'package:faida_pos/widgets/shared/navbar_bottom.dart';
import 'package:flutter/material.dart';

class HomeRoot extends StatefulWidget {
  const HomeRoot({super.key});

  @override
  State<HomeRoot> createState() => _HomeRootState();
}

class _HomeRootState extends State<HomeRoot> {
  int _currentIndex = 0;

  final _screens = [
    Checkout(),
    Transactions(),
    Reports(),
    Notifications(),
    Menu(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: NavbarBottom(
          currentIndex: _currentIndex,
          onTabSelected: (index) {
            setState(() => _currentIndex = index);
          }),
    );
  }
}
