import 'package:faida_pos/widgets/shared/all_products.dart';
import 'package:flutter/material.dart';

import '../../../models/product.dart';

class InventoryWidget extends StatelessWidget {
  final Function(Product) onProductTap;
  final VoidCallback refreshOnAddedFavorite;

  const InventoryWidget({super.key,
    required this.onProductTap,
    required this.refreshOnAddedFavorite});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [

        Expanded(child:
        AllProducts(
            refreshOnAddedFavorite: refreshOnAddedFavorite,
            onProductTap: onProductTap))
      ],
    );
  }
}
