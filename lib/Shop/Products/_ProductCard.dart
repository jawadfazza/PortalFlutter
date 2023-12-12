import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shopping/Shop/Stores/_ProductInfo.dart';
import '../Models/Product.dart';
import 'ImageGalleryPopup.dart';

class ProductCard extends StatelessWidget {
  final Product product;
  final VoidCallback onTap;
  final VoidCallback addToCart;
  final bool showProgressIndicator;
  final String rowKey;
  final Function(String) increaseQuantity;
  final Function(String) decreaseQuantity;
  final int layoutNumber;

  ProductCard({
    required this.product,
    required this.onTap,
    required this.addToCart,
    required this.showProgressIndicator,
    required this.rowKey,
    required this.increaseQuantity,
    required this.decreaseQuantity,
    required this.layoutNumber,
  });

  @override
  Widget build(BuildContext context) {
    NumberFormat currencyFormat = NumberFormat.currency(
      symbol: '\$',  // Currency symbol
      decimalDigits: 2,  // Number of decimal places
    );
    return GestureDetector(
      onTap: onTap,
      child:layoutNumber==1?Card(
        elevation: 3,
        margin: const EdgeInsets.all(5),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              height: 150, // Set the desired height for the image container
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                image: DecorationImage(
                  image: NetworkImage(product.imageURL),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          product.name,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed: addToCart,
                        icon: showProgressIndicator && product.rowKey == rowKey
                            ? const CircularProgressIndicator()
                            : const Icon(Icons.add_shopping_cart),
                        color: Colors.green,
                      ),
                      IconButton(
                        onPressed: addToCart,
                         icon: const Icon(Icons.image_search_rounded),
                        color: Colors.green,
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    product.description,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Price: ${currencyFormat.format(product.price)}',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                          color: Colors.blue,
                        ),
                      ),
                      Row(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.remove_circle_outline),
                            onPressed: () {
                              decreaseQuantity(product.rowKey);
                            },
                          ),
                          Text(
                            '${product.cartQuantity}',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.add_circle_outline),
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
          ],
        ),
      )
      :Card(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: 100,
              height: 150,
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(10),
                  bottomLeft: Radius.circular(10),
                ),
                image: DecorationImage(
                  image: NetworkImage(product.imageURL), // Assuming product has a property 'imageUrl'
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    product.name,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    product.description,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '\$${product.price.toStringAsFixed(2)}',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Colors.blue,
                        ),
                      ),
                      Row(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.remove),
                            onPressed: () {
                              decreaseQuantity(product.rowKey);
                            },
                          ),

                          Text(
                            '${product.cartQuantity}',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.add),
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
            const SizedBox(width: 12),
            Column(
              children: [
                IconButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return Dialog(
                          // Adjust the dialog size and other properties as needed
                          child: ProductInfo(product: product),
                        );
                      },
                    );
                  },
                  icon: const Icon(Icons.edit),
                  color: Colors.green,
                ),
                IconButton(
                  onPressed: addToCart,
                  icon: showProgressIndicator && product.rowKey == rowKey
                      ? const CircularProgressIndicator()
                      : const Icon(Icons.add_shopping_cart),
                  color: Colors.green,
                ),
                IconButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return ImageGalleryPopup(images: [product.imageURL,
                          product.imageURL,
                          product.imageURL,
                          product.imageURL,
                          product.imageURL,
                          product.imageURL,
                        ]);
                      },
                    );
                  },
                  icon: const Icon(Icons.image_search_rounded),
                  color: Colors.green,
                ),
              ],
            ),

          ],
        ),
      ),
    );
  }
}





