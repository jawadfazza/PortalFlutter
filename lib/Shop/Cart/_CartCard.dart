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
    NumberFormat currencyFormat = NumberFormat.currency(
      symbol: '\$',
      decimalDigits: 2,
    );

    return Card(
      elevation: 3.0,
      margin: EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
      child: Padding(
        padding: EdgeInsets.all(5.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 70,
              height: 70,
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
                  Text(
                    product.name,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0),
                    overflow: TextOverflow.ellipsis,
                  ),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '${currencyFormat.format(product.price)}',
                        style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
                      ),
                      Row(
                        children: [
                          IconButton(
                            icon: Icon(Icons.remove),
                            onPressed: () {
                              decreaseQuantity(product.rowKey);
                            },
                          ),
                          Text(
                            '${product.cartQuantity}',
                            style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold, color: Colors.green),
                          ),
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
                ],
              ),
            ),
            IconButton(
              icon: Icon(Icons.delete, size: 24.0),
              onPressed: () {
                removeProduct(product);
              },
            ),
          ],
        ),
      ),
    );
  }
}

