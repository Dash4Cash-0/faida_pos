import 'package:faida_pos/controllers/product_controller.dart';
import 'package:flutter/material.dart';
import '../models/product.dart';
import '../models/sale_item.dart';

class CheckoutController {

  CheckoutController({required this.productController});

  final ValueNotifier <List<SaleItem>> currentSaleList = ValueNotifier<List<SaleItem>>([]);
  final storedValueNotifier = ValueNotifier<double>(0);
  final controller = TextEditingController();
  final ProductController productController;

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