import 'package:flutter/material.dart';
import 'package:shopping/Shop/Cart/_CartCard.dart';
import 'package:shopping/Shop/Models/Product.dart';
import '../../GlobalTools/AlertMessage.dart';
import 'package:collection/collection.dart';


class ShoppingCart extends StatefulWidget {
  static List<Product> _items = [];
  static ValueNotifier<int> cartItemCount = ValueNotifier<int>(_items.length);
  static Map<String, List<Product>> groupedCartItems = {};

  static void _groupCartItems() {
    groupedCartItems = groupBy(ShoppingCart.getItems(), (Product product) => product.storeDescription);
  }
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
    _groupCartItems();
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


  @override
  void initState() {
    super.initState();
    ShoppingCart._groupCartItems();
  }
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
    });
  }

  void increaseQuantity(String rowKey) {
    setState(() {
      ShoppingCart._increaseQuantity(rowKey);
    });
  }

  void decreaseQuantity(String rowKey) {
    setState(() {
      ShoppingCart._decreaseQuantity(rowKey);
    });
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
            buttonText: 'Clear Cart',
            confirmationText: 'Are you sure you want to clear the cart?',
            confirmFunction: confirmFunction,
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: ShoppingCart.groupedCartItems.length,
        itemBuilder: (context, index) {
          final storeDescription = ShoppingCart.groupedCartItems.keys.elementAt(index);
          final productsInStore = ShoppingCart.groupedCartItems[storeDescription]!;
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.all(10.0),
                child: Text(
                  storeDescription,
                  style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold, color: Colors.black),
                ),
              ),
              ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: productsInStore.length,
                itemBuilder: (context, index) {
                  final product = productsInStore[index];
                  return Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
                    child: CartCard(
                      product: product,
                      removeProduct: removeProduct,
                      decreaseQuantity: decreaseQuantity,
                      increaseQuantity: increaseQuantity,
                    ),
                  );
                },
              ),
            ],
          );
        },
      ),
    );
  }

}
