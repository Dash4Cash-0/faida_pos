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
        image: imagePath,
        isFavorite: _isFavorite);

    await DatabaseService.instance.insertProduct(product);
    Navigator.pop(context, true);
  }



  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(title: Text(l10n.addProduct)),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _nameController,
              decoration: InputDecoration(labelText: l10n.productName),
            ),
            TextField(
              controller: _descriptionController,
              decoration: InputDecoration(labelText: l10n.description),
            ),
            TextField(
              controller: _priceController,
              decoration: InputDecoration(labelText: l10n.price),
              keyboardType: TextInputType.number,
            ),

            CheckboxListTile(
              title: Text(l10n.addToFav),
              value: _isFavorite,
              onChanged: (value) {
                setState(() => _isFavorite = value ?? false);
              },
            ),

            ElevatedButton(
              onPressed: () async {
                final picker = ImagePicker();
                final photo = await picker.pickImage(source: ImageSource.camera);
                if (photo != null) {
                  setState(() => _imageFile = File(photo.path));
                }
              },
              child: Text(l10n.takePhoto),
            ),

            if (_imageFile != null)
              Image.file(_imageFile!, height: 100),

            const Spacer(),

            ElevatedButton(
              onPressed: _saveProduct,
              child: Text(l10n.saveProduct),
            ),
          ],
        ),
      ),
    );
  }
}
