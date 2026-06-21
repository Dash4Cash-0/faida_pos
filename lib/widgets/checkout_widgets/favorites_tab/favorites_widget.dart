import 'package:faida_pos/models/product.dart';
import 'package:faida_pos/widgets/checkout_widgets/favorites_tab/favorites_grid.dart';
import 'package:flutter/material.dart';

class FavoritesWidget extends StatelessWidget {
  final List<Product> products;
  final bool isLoading;
  final Function(Product) onProductTap;
  final VoidCallback onProductAdded;


  const FavoritesWidget({
    super.key,
    required this.products,
    required this.isLoading,
    required this.onProductTap,
    required this.onProductAdded});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 12),
      Expanded(
          child: FavoritesGrid(
              products: products,
              isLoading: isLoading,
              onProductTap: onProductTap,
              onProductAdded: onProductAdded)
      ),
        SizedBox(height: 12)
    ],
    );
  }
}
