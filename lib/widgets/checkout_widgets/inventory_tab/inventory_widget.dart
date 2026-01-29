import 'package:faida_pos/widgets/shared/all_products.dart';
import 'package:flutter/material.dart';

import '../../../controllers/product_controller.dart';
import '../../../models/product.dart';

class InventoryWidget extends StatelessWidget {
  final Function(Product) onProductTap;
  final VoidCallback refreshOnAddedFavorite;
  final ProductController productController;

  const InventoryWidget({super.key,
    required this.onProductTap,
    required this.refreshOnAddedFavorite,
    required this.productController});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [

        Expanded(child:
        AllProducts(productController: productController,
            refreshOnAddedFavorite: refreshOnAddedFavorite,
            onProductTap: onProductTap))
      ],
    );
  }
}
