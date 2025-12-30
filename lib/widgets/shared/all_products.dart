import 'package:faida_pos/models/product.dart';
import 'package:faida_pos/services/database_service.dart';
import 'package:faida_pos/widgets/shared/delete_product.dart';
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text("All Products"),
      ),
      backgroundColor: Colors.white,
      body:
          FutureBuilder<List<Product>>(
                  future: _productsFuture,
                  builder: (context, snapshot) {
                if(snapshot.connectionState == ConnectionState.waiting){
                  return Center(child: CircularProgressIndicator());
                }
                if(snapshot.hasError){
                  return Center(child: Text("Error: ${snapshot.error}"));
                }
                final products = snapshot.data!;
                if(products.isEmpty){
                  return Center(child: Text("There are no products"));
                }

                return ListView.builder(padding: EdgeInsets.all(8),
                    itemCount: products.length,
                    itemBuilder: (context, index) {
                  final p = products[index];

                  return ListTile(
                    onLongPress: () async {
                      final Product? deletedProduct = await showDialog<Product>(context: context,
                          builder: (_) => DeleteProduct(productId: p.id));

                      if(!mounted) return;

                      if(deletedProduct != null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content:
                            Text("${deletedProduct.name} deleted"),
                              action: SnackBarAction(label: "Undo",
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
                    trailing: Text("${p.price} TZS") ,
                  );
                    }
                    );
              }
            )
    );
  }
}
