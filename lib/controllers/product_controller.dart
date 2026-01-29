import 'package:faida_pos/models/sale_item.dart';
import 'package:faida_pos/services/database_service.dart';
import 'package:flutter/cupertino.dart';

import '../models/product.dart';

class ProductController extends ChangeNotifier {
  List<Product> products = [];

  Future<void> load() async {

    products = await DatabaseService.instance.getAllProducts();
    notifyListeners();

  }

  void commitSale(List<SaleItem> items) {
    for(final item in items){
      var p = products.firstWhere((p) => p.id == item.productId);
      p.inStock -= item.quantity;
    }
    notifyListeners();
  }
}