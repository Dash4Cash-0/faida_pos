import 'dart:io';

import 'package:faida_pos/widgets/shared/add_product.dart';
import 'package:flutter/material.dart';
import 'package:faida_pos/models/product.dart';

class FavoritesGrid extends StatelessWidget {

  final List<Product> products;
  final bool isLoading;
  final Function(Product) onProductTap;
  final VoidCallback onProductAdded;

  const FavoritesGrid({
    super.key,
    required this.products,
    required this.isLoading,
    required this.onProductTap,
    required this.onProductAdded});

  @override
  Widget build(BuildContext context) {

    if(isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    return GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            childAspectRatio: 1.8,
            crossAxisSpacing: 4,
            mainAxisSpacing: 4),
      itemCount: products.length < 24 ? products.length + 1 : products.length,
      itemBuilder: (context, index) {
          if(index < products.length) {
            return _buildProductTile(products[index]);
          }
          return _buildAddButton(context);
      },
    );
  }


  Widget _buildProductTile(Product product) {
    return GestureDetector(
      onTap: () => onProductTap(product),
      child: Container(
        margin: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: Colors.grey.shade300,
          border: Border.all(color: Colors.black),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (product.image != null)
              Expanded(
                child: Image.file(
                  File(product.image!),
                  fit: BoxFit.cover,
                ),
              )
            else
              const Expanded(
                child: Icon(Icons.shopping_bag, size: 40),
              ),
            Padding(
              padding: const EdgeInsets.all(4.0),
              child: Text(
                product.name,
                style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }


  Widget _buildAddButton(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        final result = await Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => AddProduct(addAsFavorite: true,)),
        );
        if (result == true) {
          onProductAdded();
        }
      },
      child: Container(
        alignment: Alignment.center,
        margin: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: Colors.grey.shade300,
          border: Border.all(color: Colors.black),
          borderRadius: BorderRadius.circular(8),
        ),
        child: const Text("+", style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold)),
      ),
    );
  }
}
