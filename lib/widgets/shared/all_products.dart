import 'package:faida_pos/controllers/product_controller.dart';
import 'package:faida_pos/l10n/app_localizations.dart';
import 'package:faida_pos/models/product.dart';
import 'package:faida_pos/widgets/shared/search_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'detailed_product.dart';

class AllProducts extends StatefulWidget {
  final Function(Product) onProductTap;
  final VoidCallback refreshOnAddedFavorite;
  final ProductController productController;

  const AllProducts({
    super.key,
    required this.onProductTap,
    required this.refreshOnAddedFavorite,
    required this.productController
  });

  @override
  State<AllProducts> createState() => _AllProductsState();
}

class _AllProductsState extends State<AllProducts> {
  String _searchText = "";
  late final l10n = AppLocalizations.of(context)!;



  @override
  void initState(){
    super.initState();
  }

  void _onSearch(String text) {
    setState(() {
      _searchText = text.toLowerCase();
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          SearchWidget(onSearch: _onSearch),
          Expanded(child:
          Consumer<ProductController>(
                  builder: (context, productController, _) {
                    final allProducts = productController.products;

                    if (productController.isLoading) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    final products = _searchText.isEmpty
                        ? allProducts
                        : allProducts.where((p) {
                      return p.name.toLowerCase().contains(_searchText) ||
                          p.description.toLowerCase().contains(_searchText);
                    }).toList();

                    if (products.isEmpty) {
                      return Center(child: Text(l10n.noItems));
                    }

                return ListView.builder(padding: EdgeInsets.all(8),
                    itemCount: products.length,
                    itemBuilder: (context, index) {
                  final p = products[index];

                  return ListTile(
                    tileColor: p.inStock == 0 ? Colors.red : Colors.white,
                    onTap: () async {
                        await widget.onProductTap(p);
                    },
                    onLongPress: () {
                      if(p.id == null) return;
                      Navigator.push(context,
                          MaterialPageRoute<void>(
                              builder: (context) =>
                                  DetailedProduct(
                                      onItemAdd: widget.onProductTap,
                                      productId: p.id!,
                                      )));
                    },

                    title: Text(p.name),
                    subtitle: Text(p.description.length > 20 ? "${p.description.substring(0,20)}..." : p.description),
                    trailing: Text("${p.price} TZS\n"
                    "${l10n.inStock}: ${p.inStock}"),
                  );
                    }
                    );
              }
            )
          )
        ],
      )
    );
  }
}
