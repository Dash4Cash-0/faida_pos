import 'package:faida_pos/controllers/checkout_controller.dart';
import 'package:faida_pos/controllers/notification_controller.dart';
import 'package:faida_pos/controllers/product_controller.dart';
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
  late final CheckoutController _controller;
  late final ProductController productController;
  late final NotificationController notificationController;

  @override
  void initState(){
    super.initState();
    productController = ProductController();
    productController.load();
    _controller = CheckoutController(productController: productController);
    notificationController = NotificationController();
    notificationController.load();
  }

  late final _screens = [
    Checkout(controller: _controller,),
    Transactions(),
    Reports(),
    Notifications(
      controller: notificationController,
      productController: productController),
    Menu(),
  ];

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
  

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
