import 'package:flutter/material.dart';
import '../../models/product.dart';

class DetailedProduct extends StatefulWidget {
  final Product product;

  const DetailedProduct({
    super.key, 
    required this.product});

  @override
  State<DetailedProduct> createState() => _DetailedProductState();
}

class _DetailedProductState extends State<DetailedProduct> {
  late double currentStock;
  late TextEditingController nameController;
  late TextEditingController descController;
  late double price;
  late double costPerUnit;
  bool isLoading = false;


  @override
  void initState(){
    super.initState();
    currentStock = widget.product.inStock;
    nameController = TextEditingController(text: widget.product.name);
    descController = TextEditingController(text: widget.product.description);
    price = widget.product.price;

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          TextFormField(controller: nameController,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          SizedBox(height: 18),

          
        ],
      )),
    );
  }
}

