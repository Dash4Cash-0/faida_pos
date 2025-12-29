import 'package:faida_pos/models/product.dart';
import 'package:faida_pos/services/database_service.dart';
import 'package:flutter/material.dart';

class AllProducts extends StatelessWidget {
  const AllProducts({
    super.key,
  });

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
                  future: DatabaseService.instance.getAllProducts(),
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
