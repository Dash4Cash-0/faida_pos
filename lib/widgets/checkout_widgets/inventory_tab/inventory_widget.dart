import 'package:faida_pos/widgets/shared/all_products.dart';
import 'package:flutter/material.dart';

import '../../../models/product.dart';

class InventoryWidget extends StatelessWidget {
  final Function(Product) onProductTap;

  const InventoryWidget({super.key, required this.onProductTap});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [

        Expanded(child: AllProducts(onProductTap: onProductTap))
      ],
    );
  }
}
