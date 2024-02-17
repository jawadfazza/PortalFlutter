import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:http/http.dart' as http;
import 'package:shopping/GlobalTools/AppConfig.dart';
import 'package:shopping/Shop/Models/Product.dart';

import '../../../GlobalTools/LocalizationManager.dart';

class ProductInfo extends StatefulWidget {
  final Product product;

  ProductInfo({
    required this.product
  });

  @override
  _ProductInfoState createState() => _ProductInfoState();
}

class _ProductInfoState extends State<ProductInfo> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  Locale currentLocale = LocalizationManager().getCurrentLocale();


  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _quantityController = TextEditingController();
  final TextEditingController _brandController = TextEditingController();
  final TextEditingController _weightController = TextEditingController();
  final TextEditingController _dimensionsController = TextEditingController();
  final TextEditingController _reviewsController = TextEditingController();
  final TextEditingController _specificationsController = TextEditingController();
  bool _availability = false;
  String _selectedGroup = '';
  String _selectedSubGroup = '';

  @override
  void initState() {
    super.initState();
    fetchDataProduct();
  }

  // Method to submit form data
  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      // Perform your custom product update logic here
      var url = '${AppConfig.baseUrl}/api/products/Update';

      final body = jsonEncode({
        'Name': _nameController.text,
        'Description': _descriptionController.text,
        'GroupRowKey': _selectedGroup,
        'SubGroupRowKey': _selectedSubGroup,
        'ImageURL': 'URL to uploaded image', // Replace with image URL or upload logic
        'Price': int.parse(_priceController.text),
        'ProductQuantity': int.parse(_quantityController.text),
        'ProductAvailability': _availability,
        'ProductReviews': _reviewsController.text,
        'ProductSpecifications': _specificationsController.text,
        'ProductBrand': _brandController.text,
        'ProductWeight': double.parse(_weightController.text),
        'ProductDimensions': _dimensionsController.text,
        'Lan': currentLocale.languageCode
      });

      try {
        final response = await http.post(
          Uri.parse(url),
          headers: <String, String>{'Content-Type': 'application/json'},
          body: body,
        );

        if (response.statusCode == 200) {
          // Handle success
          print('Product updated successfully');
        } else {
          // Handle error
          print('Failed to update product. Status code: ${response.statusCode}');
        }
      } catch (e) {
        // Handle exceptions
        print('Exception during product update: $e');
      }
    }
  }

  Future<void> fetchDataProduct() async {
    //languageCode = _currentLocale.languageCode.toUpperCase();
    try {
        setState(() {

          // Update the below lines based on your API response and _ProductProfileState fields
          _nameController.text = widget.product.name ?? '';
          _descriptionController.text = widget.product.description?? '';
          _priceController.text = widget.product.price.toString() ?? '';
          _quantityController.text = widget.product.productQuantity.toString() ?? '';
          _brandController.text = widget.product.productBrand ?? '';
          _weightController.text = widget.product.productWeight.toString() ?? '';
          _dimensionsController.text = widget.product.productDimensions ?? '';
          _reviewsController.text = widget.product.productReviews ?? '';
          _specificationsController.text = widget.product.productSpecifications ?? '';
          _availability = widget.product.productAvailability ?? false;
          _selectedGroup = widget.product.groupRowKey ?? '';
          _selectedSubGroup = widget.product.subGroupRowKey ?? '';
          // Set other fields' values similarly
        });

    } catch (error) {
      print(error);
    }
  }

  void _showMessage(String message, Color messageColor) {
    final snackBar = SnackBar(
      content: Text(message),
      backgroundColor: messageColor,
    );
    ScaffoldMessenger.of(_scaffoldKey.currentContext!).showSnackBar(snackBar);
  }
  void _changeLanguage(Locale newLocale) {
    setState(() {
      FlutterI18n.refresh(context, newLocale);
    });
  }


  @override
  Widget build(BuildContext context) {
    TextDirection textDirection = currentLocale.languageCode.toLowerCase() == 'ar' ? TextDirection.rtl : TextDirection.ltr;


    return Directionality(
      textDirection: textDirection,
      child: Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          title:  Text(FlutterI18n.translate(context, "ProductInfo")),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                TextFormField(
                  controller: _nameController,
                  decoration:  InputDecoration(labelText: FlutterI18n.translate(context, "Name")),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the product name';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: _descriptionController,
                  decoration:  InputDecoration(labelText: FlutterI18n.translate(context, "Description")),
                  // Validator and other properties
                ),
                // Dropdown for GroupRowKey
                // Cascading dropdown for SubGroupRowKey
                // Upload image widget
                const SizedBox(height: 10),
                TextFormField(
                  controller: _priceController,
                  decoration:  InputDecoration(labelText: FlutterI18n.translate(context, "Price")),
                  keyboardType: TextInputType.number,
                  // Validator and other properties
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: _quantityController,
                  decoration:  InputDecoration(labelText: FlutterI18n.translate(context, "Quantity")),
                  keyboardType: TextInputType.number,
                  // Validator and other properties
                ),
                const SizedBox(height: 10),
                CheckboxListTile(
                  title:  Text(FlutterI18n.translate(context, "ProductAvailability")),
                  value: _availability,
                  onChanged: (newValue) {
                    setState(() {
                      _availability = newValue!;
                    });
                  },
                ),

                const SizedBox(height: 10),
                TextFormField(
                  controller: _specificationsController,
                  maxLines: 3,
                  decoration:  InputDecoration(labelText: FlutterI18n.translate(context, "ProductSpecifications")),
                  // Validator and other properties
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: _brandController,
                  decoration:  InputDecoration(labelText: FlutterI18n.translate(context, "ProductBrand")),
                  // Validator and other properties
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: _weightController,
                  decoration:  InputDecoration(labelText: FlutterI18n.translate(context, "ProductWeight")),
                  keyboardType: TextInputType.number,
                  // Validator and other properties
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: _dimensionsController,
                  decoration:  InputDecoration(labelText: FlutterI18n.translate(context, "ProductDimensions")),
                  // Validator and other properties
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: _submitForm,
                  child:  Text(FlutterI18n.translate(context, 'SaveChanges')),

                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
