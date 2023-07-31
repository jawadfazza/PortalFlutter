import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shopping/Shop/Cart/ShoppingCartScreen.dart';
import 'package:shopping/Shop/Models/Product.dart';

class ProductDetailsScreen extends StatefulWidget {
  final Product product;
  ProductDetailsScreen({required this.product});

  @override
  _ProductDetailsScreenState createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  int _quantity = 1;

  void _increaseQuantity(int maxQuantity) {
    setState(() {
      if (maxQuantity > _quantity) {
        _quantity++;
      }
    });
  }

  void _decreaseQuantity() {
    setState(() {
      if (_quantity > 1) {
        _quantity--;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Product Details'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          color: Colors.white,
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Image.network(
                widget.product.imageURL,
                width: 200,
                height: 200,
                fit: BoxFit.fill,
                errorBuilder: (context, error, stackTrace) {
                  // Show a placeholder image if the product image fails to load
                  return Image.asset('assets/placeholder_image.png', width: 200, height: 200);
                },
              ),
              SizedBox(height: 16),
              Text(
                widget.product.name,
                style: TextStyle(fontSize: 24),
              ),
              SizedBox(height: 16),
              Text(
                widget.product.description,
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 16),
              Divider(color: Colors.grey),
              SizedBox(height: 16),
              Text(
                'Price: \$${widget.product.price.toStringAsFixed(2)}',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                ),
              ),
              SizedBox(height: 16),
              Text(
                'Brand: ${widget.product.productBrand}',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 16),
              Text(
                'Weight: ${widget.product.productWeight} kg',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 16),
              Text(
                'Dimensions: ${widget.product.productDimensions}',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 16),
              Divider(color: Colors.grey),
              SizedBox(height: 16),
              Text(
                'Product Specifications:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              ListTile(
                title: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: widget.product.productSpecifications
                      .split(',')
                      .map((specification) => Text(
                    specification.trim(),
                    style: TextStyle(fontSize: 16),
                  ))
                      .toList(),
                ),
              ),
              SizedBox(height: 16),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: Text('Confirmation Message'),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      'Add the product to the cart?',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton.icon(
                          onPressed: () {
                            ShoppingCart.addProduct(widget.product, _quantity);
                            Navigator.pop(context);
                          },
                          icon: Icon(Icons.check),
                          label: Text('Yes'),
                        ),
                        ElevatedButton.icon(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          icon: Icon(Icons.close),
                          label: Text('No'),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          );
        },
        icon: Icon(Icons.add_shopping_cart),
        label: Text('Add to Cart'),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      persistentFooterButtons: [
        Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              FloatingActionButton(
                onPressed: _decreaseQuantity,
                child: Icon(Icons.remove),
                backgroundColor: Colors.grey[400],
              ),
              SizedBox(width: 16),
              Text(
                'Quantity: $_quantity',
                style: TextStyle(fontSize: 18),
              ),
              SizedBox(width: 16),
              FloatingActionButton(
                onPressed: () => _increaseQuantity(widget.product.productQuantity),
                child: Icon(Icons.add),
                backgroundColor: Colors.grey[400],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
