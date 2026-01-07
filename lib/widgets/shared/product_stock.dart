import 'package:faida_pos/services/database_service.dart';
import 'package:flutter/material.dart';
import '../../models/product.dart';

class ProductStock extends StatelessWidget {
  final int? productId;

  const ProductStock({super.key, required this.productId});


  Future <Product?> _removeFromStock() async {
    final product = await DatabaseService.instance.getProductById(productId!);


  }

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
