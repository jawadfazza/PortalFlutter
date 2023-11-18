import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shopping/Shop/Models/Product.dart';

class CartCard extends StatelessWidget {
  final Product product;
  final Function removeProduct;
  final Function increaseQuantity;
  final Function decreaseQuantity;

  CartCard({
    required this.product,
    required this.removeProduct,
    required this.increaseQuantity,
    required this.decreaseQuantity,
  });

  @override
  Widget build(BuildContext context) {
    // NumberFormat instance for currency formatting
    NumberFormat currencyFormat = NumberFormat.currency(
      symbol: '\$', // Currency symbol
      decimalDigits: 2, // Number of decimal places
    );

    return Card(
      elevation: 3.0,
      margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: NetworkImage(product.imageURL),
                fit: BoxFit.cover,
              ),
              borderRadius: BorderRadius.circular(8.0),
            ),
          ),
          SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Displaying product name with maximum 2 lines and ellipsis if overflow
                    Expanded(
                      child: Text(
                        product.name,
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16.0),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    IconButton(
                      alignment: Alignment.topCenter,
                      icon: Icon(Icons.delete, size: 24.0),
                      onPressed: () {
                        removeProduct(product);
                      },
                    ),
                  ],
                ),
                SizedBox(height: 4),
                Row(
                  children: [
                    // Displaying product price with currency formatting
                    Text(
                      '${currencyFormat.format(product.price)}',
                      style: TextStyle(fontSize: 14.0, color: Colors.blue),
                    ),
                    Spacer(),
                    // Buttons to increase or decrease quantity
                    IconButton(
                      icon: Icon(Icons.remove),
                      onPressed: () {
                        decreaseQuantity(product.rowKey);
                      },
                    ),
                    SizedBox(width: 4),
                    // Displaying the quantity of the product in the cart
                    Text(
                      'Qty: ${product.cartQuantity}',
                      style: TextStyle(fontSize: 12.0, color: Colors.green),
                    ),
                    SizedBox(width: 4),
                    IconButton(
                      icon: Icon(Icons.add),
                      onPressed: () {
                        increaseQuantity(product.rowKey);
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
