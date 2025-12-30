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
    return Dialog.fullscreen(
      backgroundColor: Colors.white,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(height: 16),
          Row(children: [
            CloseButton(),
            Text("All Products", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
          ]),
          Divider(),
          Expanded(
              child: FutureBuilder<List<Product>>(
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
                      final deleted = await showDialog<bool>(context: context,
                          builder: (_) => DeleteProduct(productId: p.id));

                      if(!mounted) return;

                      if(deleted == true) {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Product Deleted"), duration: Duration(seconds: 2),));
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
          )
        ],
      ),
    );
  }
}
