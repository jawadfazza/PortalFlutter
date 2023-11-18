import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shopping/Shop/Cart/CartList.dart';

class CartShopIcon extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return  IconButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ShoppingCart()),
        );
      },
      icon: Stack(
        children: [
          Icon(Icons.shopping_cart_rounded),
          Positioned(
            top: 0,
            right: 0,
            child: ValueListenableBuilder<int>(
              valueListenable: ShoppingCart.cartItemCount,
              builder: (context, count, child) {
                return Container(
                  padding: EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.red, // You can change the color
                  ),
                  child: Text(
                    '$count',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );

  }

}