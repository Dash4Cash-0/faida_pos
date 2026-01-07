import 'package:faida_pos/l10n/app_localizations.dart';
import 'package:faida_pos/models/product.dart';
import 'package:faida_pos/services/database_service.dart';
import 'package:faida_pos/widgets/shared/delete_product.dart';
import 'package:faida_pos/widgets/shared/search_widget.dart';
import 'package:flutter/material.dart';

class AllProducts extends StatefulWidget {
  const AllProducts({
    super.key,
  });

  @override
  State<AllProducts> createState() => _AllProductsState();
}


class _AllProductsState extends State<AllProducts> {
  late Future<List<Product>> _productsFuture;
  List<Product> _allProducts = [];
  String _searchText = "";


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

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
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
                  return Center(child: Text(l10n.noProducts));
                }

                return ListView.builder(padding: EdgeInsets.all(8),
                    itemCount: products.length,
                    itemBuilder: (context, index) {
                  final p = products[index];

                  return ListTile(
                    onTap: () async {

                    },
                    onLongPress: () async {
                      final Product? deletedProduct = await showDialog<Product>(context: context,
                          builder: (_) => DeleteProduct(productId: p.id));

                      if(!context.mounted) return;

                      if(deletedProduct != null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content:
                            Text("${deletedProduct.name} ${l10n.deleted}"),
                              action: SnackBarAction(label: l10n.undo,
                                  onPressed: () async {
                                await DatabaseService.instance.insertProduct(deletedProduct);
                                _refresh();
                                  }),
                              duration: Duration(seconds: 5),));
                      }
                      _refresh();
                    },
                    title: Text(p.name),
                    subtitle: Text(p.description.length > 20 ? "${p.description.substring(0,20)}..." : p.description),
                    trailing: Text("${p.price} TZS\n"
                    "In stock: ${p.inStock}"),
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
