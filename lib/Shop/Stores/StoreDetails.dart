import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shopping/GlobalTools/ProgressCustome.dart';
import 'package:shopping/Shop/Cart/CartList.dart';
import 'package:shopping/Shop/Cart/_CartShopIcon.dart';
import 'package:shopping/Shop/Models/Store.dart';

class StoreDetails extends StatefulWidget {
  final Store store;
  StoreDetails({required this.store});

  @override
  _StoreDetailsState createState() => _StoreDetailsState();
}

class _StoreDetailsState extends State<StoreDetails> {
  int _quantity = 1;

  var languageCode = "";


  @override
  Widget build(BuildContext context) {
    if (languageCode == "") {
      languageCode = ModalRoute
          .of(context)
          ?.settings
          .arguments as String;
    }
    // Determine the text direction based on the current locale
    TextDirection textDirection = languageCode == 'ar'
        ? TextDirection.rtl
        : TextDirection.ltr;

    return Directionality(
      textDirection: textDirection,
      child: Scaffold(
        appBar: AppBar(
          actions: [
            CartShopIcon()
          ],
          title: Text('Store Details'),
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
                  widget.store.imageURL,
                  width: 200,
                  height: 200,
                  fit: BoxFit.fill,
                  errorBuilder: (context, error, stackTrace) {
                    // Show a placeholder image if the store image fails to load
                    return Image.asset(
                      'assets/placeholder_image.png',
                      width: 200,
                      height: 200,
                    );
                  },
                ),
                SizedBox(height: 16),
                Text(
                  widget.store.name,
                  style: TextStyle(fontSize: 24),
                ),
                SizedBox(height: 16),
                Text(
                  widget.store.description,
                  style: TextStyle(fontSize: 16),
                ),
                SizedBox(height: 16),
                Divider(color: Colors.grey),
                SizedBox(height: 16),
                Text(
                  'Price: \$${widget.store.rating.toStringAsFixed(2)}',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
                  ),
                ),
                SizedBox(height: 16),
                Text(
                  'Brand: ${widget.store.closingHours}',
                  style: TextStyle(fontSize: 16),
                ),
                SizedBox(height: 16),
                Text(
                  'Weight: ${widget.store.contactNumber} kg',
                  style: TextStyle(fontSize: 16),
                ),
                SizedBox(height: 16),
                Text(
                  'Dimensions: ${widget.store.email}',
                  style: TextStyle(fontSize: 16),
                ),
                SizedBox(height: 16),
                Divider(color: Colors.grey),
                SizedBox(height: 16),
                Text(
                  'Store Specifications:',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                )

              ],
            ),
          ),
        ),

      ),
    );
  }
}
