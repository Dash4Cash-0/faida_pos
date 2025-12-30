import 'package:faida_pos/services/database_service.dart';
import 'package:flutter/material.dart';
import '../../models/product.dart';

class DeleteProduct extends StatelessWidget {
  final int? productId;

  const DeleteProduct({
    super.key,
    required this.productId});

  Future<Product?>_deleteProduct() async {
    final product = await DatabaseService.instance.getProductById(productId!);

    if(product != null) {
      await DatabaseService.instance.deleteProduct(productId!);
      return product;
    }

    return null;
}

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.red,
      child: Padding(padding: EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text("Delete product?", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      side: BorderSide(color: Colors.black, width: 1, style: BorderStyle.solid)
                  ),
                  onPressed: () async {
              final deletedProduct = await _deleteProduct();
              if(context.mounted){
                Navigator.pop(context, deletedProduct);
              }
              } , child: Text("Yes")),
              ElevatedButton(onPressed: () => Navigator.pop(context, null),
                  child: Text("No"))
            ],
          )
        ],
      ),
      )
    );
  }
}
