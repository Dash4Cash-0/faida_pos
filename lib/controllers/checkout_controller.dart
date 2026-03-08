import 'package:flutter/material.dart';
import '../models/product.dart';
import '../models/sale_item.dart';

class CheckoutController {


  final ValueNotifier <List<SaleItem>> currentSaleList = ValueNotifier<List<SaleItem>>([]);
  final storedValueNotifier = ValueNotifier<double>(0);
  final controller = TextEditingController();

  String input = "";
  String partValues = "";
  int currentIndex = 0;
  String currentSale = "";
  List<Product> favoriteProducts = [];
  bool isLoadingProducts = true;


  void dispose() {
    storedValueNotifier.dispose();
    currentSaleList.dispose();
    controller.dispose();
  }
}