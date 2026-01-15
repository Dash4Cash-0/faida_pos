import 'dart:io';
import 'package:faida_pos/l10n/app_localizations.dart';
import 'package:faida_pos/models/product.dart';
import 'package:faida_pos/services/database_service.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../services/image_service.dart';

class AddProduct extends StatefulWidget {
  final bool addAsFavorite;

  const AddProduct({
    super.key,
    this.addAsFavorite = false});

  @override
  State<AddProduct> createState() => _AddProductState();
}

class _AddProductState extends State<AddProduct> {
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _priceController = TextEditingController();
  final _inStockController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isFavorite = false;
  File? _imageFile;

  @override
  void initState() {
    super.initState();
    _isFavorite = widget.addAsFavorite;
  }

  Future<void> _saveProduct() async {
    String? imagePath;
    if(_imageFile != null) {
      imagePath = await ImageService.instance.saveProductImage(_imageFile!, 'temp_id');
    }
    late final product = Product(
        name: _nameController.text,
        description: _descriptionController.text,
        price: double.parse(_priceController.text),
        inStock: double.parse(_inStockController.text),
        image: imagePath,
        isFavorite: _isFavorite);

    await DatabaseService.instance.insertProduct(product);
    if(!mounted) return;
    Navigator.pop(context, true);
  }


  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(title: Text(l10n.addItem), backgroundColor: Colors.white,),
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
        child: Column(
          children: [
            TextFormField(
              controller: _nameController,
              decoration: InputDecoration(labelText: l10n.itemName),
              validator: (value) {
                if (value == null || value.trim().isEmpty){
                  return l10n.enterItemName;
                }
                return null;
              },
            ),
            TextField(
              controller: _descriptionController,
              decoration: InputDecoration(labelText: l10n.description,),
            ),
            TextFormField(
              controller: _priceController,
              decoration: InputDecoration(labelText: l10n.price),
              keyboardType: TextInputType.number,
              validator: (value) {
                if(value == null || value.trim().isEmpty){
                  return l10n.enterPrice;
                }
                return null;
              },
            ),
            TextFormField(
              controller: _inStockController,
              decoration: InputDecoration(labelText: l10n.amount),
              keyboardType: TextInputType.number,
              validator: (value) {
                if(value == null || value.trim().isEmpty){
                  return l10n.enterAmount;
                }
                return null;
              },
            ),

            CheckboxListTile(
              title: Text(l10n.addToFav),
              value: _isFavorite,
              onChanged: (value) {
                setState(() => _isFavorite = value ?? false);
              },
            ),


            Row(crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                  side: BorderSide(color: Colors.black, width: 1, style: BorderStyle.solid),
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.black,
                  textStyle: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold)
              ),
              onPressed: () async {
                final picker = ImagePicker();
                final photo = await picker.pickImage(source: ImageSource.camera);
                if (photo != null) {
                  setState(() => _imageFile = File(photo.path));
                }
              },
              child: Text(l10n.takePhoto),
            ),

            ElevatedButton(
              style: ElevatedButton.styleFrom(
                side: BorderSide(color: Colors.black, width: 1, style: BorderStyle.solid),
                backgroundColor: Colors.white,
                foregroundColor: Colors.black,
                textStyle: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,)
              ),
              onPressed: () {
               if(_formKey.currentState!.validate()){
                _saveProduct();
               }
              },
              child: Text(l10n.saveItem),
            ),
            SizedBox(height: 10),

            ]),
            if (_imageFile != null)
              Image.file(_imageFile!, height: 300),
          ],
        ),
      ),
      )
    );
  }
}
