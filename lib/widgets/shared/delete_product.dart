import 'package:faida_pos/services/database_service.dart';
import 'package:flutter/material.dart';

class DeleteProduct extends StatelessWidget {
  final int? productId;

  const DeleteProduct({
    super.key,
    required this.productId});

  Future<void>_deleteProduct() async {
    await DatabaseService.instance.deleteProduct(productId!);
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
              await _deleteProduct();
              Navigator.pop(context, true);
              } , child: Text("Yes")),
              ElevatedButton(onPressed: () => Navigator.pop(context, false), child: Text("No"))
            ],
          )
        ],
      ),
      )
    );
  }
}
