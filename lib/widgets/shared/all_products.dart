import 'package:faida_pos/l10n/app_localizations.dart';
import 'package:faida_pos/models/product.dart';
import 'package:faida_pos/services/database_service.dart';
import 'package:faida_pos/widgets/shared/search_widget.dart';
import 'package:flutter/material.dart';

import 'detailed_product.dart';

class AllProducts extends StatefulWidget {
  final Function(Product) onProductTap;
  final VoidCallback refreshOnAddedFavorite;

  const AllProducts({
    super.key,
    required this.onProductTap,
    required this.refreshOnAddedFavorite
  });

  @override
  State<AllProducts> createState() => _AllProductsState();
}

class _AllProductsState extends State<AllProducts> {
  late Future<List<Product>> _productsFuture;
  List<Product> _allProducts = [];
  String _searchText = "";
  late final l10n = AppLocalizations.of(context)!;


  @override
  void initState(){
    super.initState();
    _productsFuture = DatabaseService.instance.getAllProducts();
  }

  void _refresh(){
    setState(() {
      _productsFuture = DatabaseService.instance.getAllProducts();
    });
  }

  void _onSearch(String text) {
    setState(() {
      _searchText = text.toLowerCase();
    });
  }

  List<Product> _filteredProducts(){
    if(_searchText.isEmpty) return _allProducts;

    return _allProducts.where((p) {
      return p.name.toLowerCase().contains(_searchText) ||
      p.description.toLowerCase().contains(_searchText);
    }).toList();
  }

  void _showOutOfStockDialog(Product p) {
    showDialog(context:
    context, builder: (BuildContext context) {
      return AlertDialog(
        backgroundColor: Colors.red,
        title: Text(l10n.outOfStock),
        content: Text("${p.name} ${l10n.isOutOfStock}",
            style: TextStyle(fontSize: 16)),
        actions: [
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            style: ElevatedButton.styleFrom(
                foregroundColor: Colors.black,
                backgroundColor: Colors.white,
                side: BorderSide(
                    color: Colors.black,
                    width: 1, style:
                BorderStyle.solid)
            ),
            child: Text(l10n.ok),)
        ],
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          SearchWidget(onSearch: _onSearch),
          Expanded(child:
          FutureBuilder<List<Product>>(
                  future: _productsFuture,
                  builder: (context, snapshot) {
                if(snapshot.connectionState == ConnectionState.waiting){
                  return Center(child: CircularProgressIndicator());
                }
                if(snapshot.hasError){
                  return Center(child: Text("${l10n.error}: ${snapshot.error}"));
                }
                _allProducts = snapshot.data!;
                final products = _filteredProducts();

                if(products.isEmpty){
                  return Center(child: Text(l10n.noItems));
                }

                return ListView.builder(padding: EdgeInsets.all(8),
                    itemCount: products.length,
                    itemBuilder: (context, index) {
                  final p = products[index];


                  return ListTile(
                    onTap: () async {
                      if(p.inStock == 0){
                        null;
                        _showOutOfStockDialog(p);
                      } else {
                        widget.onProductTap(p);
                      }
                    },
                    onLongPress: () async {
                      Navigator.push(context,
                          MaterialPageRoute<void>(
                              builder: (context) =>
                                  DetailedProduct(
                                      refreshOnAddedFavorite: widget.refreshOnAddedFavorite,
                                      onItemAdd: widget.onProductTap,
                                      product: p,
                                      refreshList: _refresh,
                                      outOfStockAlert: _showOutOfStockDialog)));
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
