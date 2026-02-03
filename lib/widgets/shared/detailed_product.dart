import 'dart:io';
import 'package:faida_pos/controllers/product_controller.dart';
import 'package:faida_pos/l10n/app_localizations.dart';
import 'package:faida_pos/services/database_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/product.dart';
import 'delete_product.dart';

class DetailedProduct extends StatefulWidget {
  final int productId;
  final Function(Product) onItemAdd;
  //final VoidCallback refreshOnAddedFavorite;

  const DetailedProduct({
    super.key, 
    required this.productId,
    required this.onItemAdd,});

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
  late Product _product;
  bool _initialized = false;


  @override
  void initState() {
    super.initState();
  }


  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (_initialized) return;

    final product =
    context.read<ProductController>().getById(widget.productId);

    if (product == null) return;

    _product = product;

    currentStockController =
        TextEditingController(text: _product.inStock.toString());
    nameController = TextEditingController(text: _product.name);
    descController = TextEditingController(text: _product.description);
    priceController =
        TextEditingController(text: _product.price.toString());
    isFavorite = _product.isFavorite;

    _initialized = true;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final product =
    context.watch<ProductController>().getById(widget.productId);

    if (product == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }
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
          if(product.image != null)
            Expanded(
                child: Image.file(
                  File(product.image!),
                  fit: BoxFit.cover)
            ) else
              Expanded(child: Text(l10n.noImage)),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ElevatedButton(
                  onPressed: () => widget.onItemAdd(product)
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
                    builder: (_) => DeleteProduct(productId: product.id));

                if(!context.mounted) return;

                if(deletedProduct != null) {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content:
                      Text("${deletedProduct.name} ${l10n.deleted}"),
                        action: SnackBarAction(label: l10n.undo,
                            onPressed: () async {
                              await DatabaseService.instance.insertProduct(deletedProduct);
                            }),
                        duration: Duration(seconds: 5)));
                }
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
    final updated =
        Product(id: widget.productId,
            name: nameController.text,
            description: descController.text,
            price: double.parse(priceController.text),
            inStock: double.parse(currentStockController.text),
            image: _product.image,
            isFavorite: isFavorite);
    //widget.refreshOnAddedFavorite();
    await context.read<ProductController>().updateProduct(updated);

  }
}

