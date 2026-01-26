import 'dart:io';
import 'package:faida_pos/l10n/app_localizations.dart';
import 'package:faida_pos/services/database_service.dart';
import 'package:flutter/material.dart';
import '../../models/product.dart';
import 'delete_product.dart';

class DetailedProduct extends StatefulWidget {
  final Product product;
  final VoidCallback refreshList;
  final Function(Product) onItemAdd;
  final VoidCallback refreshOnAddedFavorite;

  const DetailedProduct({
    super.key, 
    required this.product,
    required this.refreshList,
    required this.onItemAdd,
    required this.refreshOnAddedFavorite,});

  @override
  State<DetailedProduct> createState() => _DetailedProductState();
}

class _DetailedProductState extends State<DetailedProduct> {
  late TextEditingController currentStockController;
  late TextEditingController nameController;
  late TextEditingController descController;
  late TextEditingController priceController;
  late double costPerUnit;
  late bool isFavorite;
  bool isEditing = false;


  @override
  void initState(){
    super.initState();
    currentStockController = TextEditingController(text: widget.product.inStock.toString());
    nameController = TextEditingController(text: widget.product.name);
    descController = TextEditingController(text: widget.product.description);
    priceController = TextEditingController(text: widget.product.price.toString());
    isFavorite = widget.product.isFavorite;

  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(l10n.itemDetails, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24)),
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
              maxLength: 30,
              minLines: 1,
              maxLines: 2,
              enabled: isEditing,
              decoration: InputDecoration(
                labelText: l10n.itemName,
                border: OutlineInputBorder()
              ),
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          SizedBox(height: 16),
          TextFormField(
              controller: descController,
              maxLength: 70,
              minLines: 1,
              maxLines: null,
              keyboardType: TextInputType.multiline,
              enabled: isEditing,
              decoration: InputDecoration(
                  labelText: l10n.description,
                  border: OutlineInputBorder()
              ),
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          SizedBox(height: 16),
          TextFormField(
              controller: priceController,
              keyboardType: TextInputType.numberWithOptions(decimal: true),
              enabled: isEditing,
              decoration: InputDecoration(
                  labelText: l10n.price,
                  border: OutlineInputBorder()
              ),
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          SizedBox(height: 16),
          TextFormField(
              controller: currentStockController,
              keyboardType: TextInputType.numberWithOptions(decimal: true),
              enabled: isEditing,
              decoration: InputDecoration(
                  labelText: l10n.currentStock,
                  border: OutlineInputBorder()
              ),
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          SizedBox(height: 16),
          CheckboxListTile(
             title: Text(l10n.addToFav),
              enabled: isEditing,
              value: isFavorite, onChanged: (value) {
                setState(() {
                  isFavorite = value ?? false;
                });
          }),
          if(widget.product.image != null)
            Expanded(
                child: Image.file(
                  File(widget.product.image!),
                  fit: BoxFit.cover)
            ) else
              Expanded(child: Text(l10n.noImage)),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ElevatedButton(
                  onPressed: () => widget.onItemAdd(widget.product)
                  ,style: ElevatedButton.styleFrom(
                foregroundColor: Colors.black,
                  backgroundColor: Colors.white,
                  side: BorderSide(
                      color: Colors.black,
                      width: 1,
                      style: BorderStyle.solid)),
                  child: Text(l10n.addItem)
              ),

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

                },
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.black,
                    backgroundColor: Colors.white,
                    side: BorderSide(
                        color: Colors.black,
                        width: 1,
                        style: BorderStyle.solid)),
                child: Text(l10n.deleteItem),),
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
            isFavorite: isFavorite));
    widget.refreshOnAddedFavorite();
  }
}

