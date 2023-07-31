import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shopping/Shop/Models/Product.dart';

class ShoppingCart extends StatefulWidget {
  static List<Product> _items = [];

  static void addProduct(Product product,int quantity) {
    _items.add(product);
  }

  static void removeProduct(Product product) {
    _items.remove(product);
  }

  static List<Product> getItems() {
    return _items;
  }

  static void clearCart() {
    _items.clear();
  }

  @override
  _ShoppingCartState createState() => _ShoppingCartState();

}



class _ShoppingCartState  extends State<ShoppingCart>{
  void removeProduct(Product product) {
    setState(() {
      ShoppingCart.removeProduct(product);
    });
  }
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    final carttiems=ShoppingCart.getItems();
    return Scaffold(
      appBar: AppBar(
        title: Text('Shopping Cart'),
        actions: [
          IconButton(onPressed: () {
            showDialog(context: context, builder: (context) {
              return AlertDialog(
                title: Text('confirm Message'),
                content: Text('Clear The Cart List?'),
                actions: [
                  ElevatedButton(onPressed: () {
                    ShoppingCart.clearCart();
                    Navigator.pop(context);
                  }, child: Text('Yes')),
                  ElevatedButton(onPressed: () {
                    Navigator.pop(context);
                  }, child: Text('No'))
                ],
              );
            });
          }, icon: Icon(Icons.delete))
        ]

      ),

      body: ListView.builder(itemBuilder: (context, index) {
      final product=carttiems[index];
      return ListTile(
        title: Text(product.name),
        subtitle: Text(product.description),
        trailing: IconButton (
          icon: Icon(Icons.delete),
          onPressed: () {
            removeProduct(product);
          },
        ),

      );
      },
      itemCount: carttiems.length)
    );
  }

}