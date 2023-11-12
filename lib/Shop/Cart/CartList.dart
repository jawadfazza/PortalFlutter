import 'package:flutter/material.dart';
import 'package:shopping/Shop/Cart/_CartCard.dart';
import 'package:shopping/Shop/Models/Product.dart';
import '../../GlobalTools/AlertMessage.dart';

class ShoppingCart extends StatefulWidget {
  static List<Product> _items = [];
  static ValueNotifier<int> cartItemCount = ValueNotifier<int>(_items.length);

  static void addProduct(Product product) {
    Product? productFound;
    try {
      productFound = _items.firstWhere((element) => element.rowKey == product.rowKey);
    } catch (e) {
      // Handle the case when no matching element is found
    }
    if (productFound != null) {
      productFound.cartQuantity += product.cartQuantity;
    } else {
      _items.add(product);
    }
    cartItemCount.value = _items.length;
  }

  static void removeProduct(Product product) {
    _items.remove(product);
    cartItemCount.value = _items.length;
  }

  static List<Product> getItems() {
    return _items;
  }

  static void clearCart() {
    _items.clear();
    cartItemCount.value = _items.length;
  }

  static void _increaseQuantity(String rowKey) {
    Product proFound;
    try {
      proFound = _items.firstWhere((element) => element.rowKey == rowKey);
      if (proFound.productQuantity > proFound.cartQuantity) {
        proFound.cartQuantity++;
      }
    } catch (e) {
      // Handle the case when no matching element is found
    }

  }

  static void _decreaseQuantity(String rowKey) {
    Product proFound;
    try {
      proFound = _items.firstWhere((element) => element.rowKey == rowKey);
      if (proFound.cartQuantity > 1) {
        proFound.cartQuantity--;
      }
    } catch (e) {
      // Handle the case when no matching element is found
    }
  }

  @override
  _ShoppingCartState createState() => _ShoppingCartState();
}

class _ShoppingCartState extends State<ShoppingCart> {

  double calculateTotalCost(List<Product> cartItems) {
    double totalCost = 0;
    for (var item in cartItems) {
      totalCost += item.cartQuantity * item.price;
    }
    return totalCost;
  }

  int calculateTotalQuantity(List<Product> cartItems) {
    int totalQuantity = 0;
    for (var item in cartItems) {
      totalQuantity += item.cartQuantity;
    }
    return totalQuantity;
  }

  void removeProduct(Product product) {
    setState(() {
      ShoppingCart.removeProduct(product);
    });
  }
  void confirmFunction() {
    setState(() {
      ShoppingCart.clearCart();
    }); // Just call clearCart directly
  }

  void increaseQuantity(String rowKey){
    setState(() {
      ShoppingCart._increaseQuantity(rowKey);
    });;
  }
  void decreaseQuantity(String rowKey){
    setState(() {
      ShoppingCart._decreaseQuantity(rowKey);
    });;
  }

  @override
  Widget build(BuildContext context) {
    final cartItems = ShoppingCart.getItems();
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Shopping Cart',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          AlertMessage(
            buttonText: 'Sure you want to clear the cart?',
            confirmationText: 'Confirm Message',
            confirmFunction: confirmFunction,
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: cartItems.length,
              itemBuilder: (context, index) {
                final product = cartItems[index];
                return CartCard(
                  product: product,
                  removeProduct: removeProduct,
                  decreaseQuantity: decreaseQuantity,
                  increaseQuantity: increaseQuantity,
                );
              },
            ),
          ),
          Container(
            padding: EdgeInsets.all(16.0),
            color: Colors.grey[200],
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  'Cart Summary',
                  style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Total Quantity:',
                      style: TextStyle(fontSize: 16.0, color: Colors.grey[600]),
                    ),
                    Text(
                      '${calculateTotalQuantity(cartItems)}',
                      style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                SizedBox(height: 4.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Total Cost:',
                      style: TextStyle(fontSize: 16.0, color: Colors.grey[600]),
                    ),
                    Text(
                      '\$${calculateTotalCost(cartItems).toStringAsFixed(2)}',
                      style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                SizedBox(height: 16.0),
                ElevatedButton(
                  onPressed: () {
                    // Add the logic to complete the payment here
                  },
                  child: Text('Complete Payment'),
                ),
              ],
            ),
          )
        ],
      ),

    );
  }

}
