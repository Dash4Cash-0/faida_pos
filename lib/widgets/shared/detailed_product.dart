import 'package:faida_pos/l10n/app_localizations.dart';
import 'package:faida_pos/services/database_service.dart';
import 'package:flutter/material.dart';
import '../../models/product.dart';
import 'delete_product.dart';

class DetailedProduct extends StatefulWidget {
  final Product product;
  final VoidCallback refreshList;

  const DetailedProduct({
    super.key, 
    required this.product,
    required this.refreshList});

  @override
  State<DetailedProduct> createState() => _DetailedProductState();
}

class _DetailedProductState extends State<DetailedProduct> {
  late TextEditingController currentStockController;
  late TextEditingController nameController;
  late TextEditingController descController;
  late TextEditingController priceController;
  late double costPerUnit;
  bool isEditing = false;


  @override
  void initState(){
    super.initState();
    currentStockController = TextEditingController(text: widget.product.inStock.toString());
    nameController = TextEditingController(text: widget.product.name);
    descController = TextEditingController(text: widget.product.description);
    priceController = TextEditingController(text: widget.product.price.toString());

  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(l10n.productDetails, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24)),
        actions: [
          IconButton(onPressed: () {
            _saveChanges();
            setState(() {
              isEditing = !isEditing;
            });
          },
              icon: Icon(isEditing ? Icons.check : Icons.edit))
        ],
      ),
      backgroundColor: Colors.white,
      body:  SafeArea(
        child:Padding(
            padding: EdgeInsets.all(16),
          child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          TextFormField(
              controller: nameController,
              maxLength: 50,
              enabled: isEditing,
              decoration: InputDecoration(
                labelText: "Product Name",
                border: OutlineInputBorder()
              ),
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          SizedBox(height: 16),
          TextFormField(
              controller: descController,
              maxLength: 300,
              enabled: isEditing,
              decoration: InputDecoration(
                  labelText: "Product Description",
                  border: OutlineInputBorder()
              ),
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          SizedBox(height: 16),
          TextFormField(
              controller: priceController,
              keyboardType: TextInputType.numberWithOptions(decimal: true),
              enabled: isEditing,
              decoration: InputDecoration(
                  labelText: "Product Price",
                  border: OutlineInputBorder()
              ),
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          SizedBox(height: 16),
          TextFormField(
              controller: currentStockController,
              keyboardType: TextInputType.numberWithOptions(decimal: true),
              enabled: isEditing,
              decoration: InputDecoration(
                  labelText: "Current Stock",
                  border: OutlineInputBorder()
              ),
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          SizedBox(height: 16),
          Row(
            children: [
              ElevatedButton(onPressed: () {

              }, child: Text("Add Product")),

              ElevatedButton(onPressed: () async {

                final Product? deletedProduct = await showDialog<Product>(context: context,
                    builder: (_) => DeleteProduct(productId: widget.product.id));

                if(!context.mounted) return;

                if(deletedProduct != null) {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content:
                      Text("${deletedProduct.name} ${l10n.deleted}"),
                        action: SnackBarAction(label: l10n.undo,
                            onPressed: () async {
                              await DatabaseService.instance.insertProduct(deletedProduct);
                              widget.refreshList();
                            }),
                        duration: Duration(seconds: 5)));
                }
                widget.refreshList();

                }, child: Text("Delete Product")),
            ],
          )

        ],
      )),
    )
    );
  }

  Future<void> _saveChanges() async {
    await DatabaseService.instance.updateProduct(
        Product(id: widget.product.id,
            name: nameController.text,
            description: descController.text,
            price: double.parse(priceController.text),
            inStock: double.parse(currentStockController.text),
            image: widget.product.image,
            isFavorite: widget.product.isFavorite));
    
  }
}

