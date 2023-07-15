import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:shopping/Models/Product.dart';
import 'package:shopping/Screens/ShoppingCartScreen.dart';


class ProductDetailsScreen  extends StatelessWidget{


  final Product product;
  ProductDetailsScreen({required this.product});

  get http => null;
  @override
  Widget build(BuildContext context) {

    // TODO: implement build
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
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [Text(product.Name +" "+ product.RowKey.toString(), style: TextStyle(fontSize: 24,)),SizedBox(height: 16),
            Text(product.Description),SizedBox(height: 100),
            ElevatedButton(onPressed: (){

              showDialog(context: context, builder: (context) {
                return AlertDialog(
                  title: Text('Product cart conformation.'),
                  content:Text('Do you want to add the prodect to the cart?'),
                  actions: [
                    ElevatedButton(onPressed: () {
                      ShoppingCart.addProduct(product);
                      Navigator.pop(context);
                    }, child: Text('Yes')),
                    ElevatedButton(onPressed: () {
                      Navigator.pop(context);
                    }, child: Text('No'))
                  ],
                );
              },);
            },child: Text('Add to Cart')),

            ],

          ),
        )
    );
  }



}

