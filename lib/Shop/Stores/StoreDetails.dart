import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shopping/GlobalTools/ProgressCustome.dart';
import 'package:shopping/Shop/Cart/CartList.dart';
import 'package:shopping/Shop/Cart/_CartShopIcon.dart';
import 'package:shopping/Shop/Models/Store.dart';

class StoreDetails extends StatefulWidget {
  final Store store;
  const StoreDetails({super.key, required this.store});

  @override
  _StoreDetailsState createState() => _StoreDetailsState();
}

class _StoreDetailsState extends State<StoreDetails> {

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
          title: const Text('Store Details'),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        body: SingleChildScrollView(
          child: Container(
            color: Colors.white,
            padding: const EdgeInsets.all(16),
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
                const SizedBox(height: 16),
                Text(
                  widget.store.name,
                  style: const TextStyle(fontSize: 24),
                ),
                const SizedBox(height: 16),
                Text(
                  widget.store.description,
                  style: const TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 16),
                const Divider(color: Colors.grey),
                const SizedBox(height: 16),
                Text(
                  'Price: \$${widget.store.rating.toStringAsFixed(2)}',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'Brand: ${widget.store.closingHours}',
                  style: const TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 16),
                Text(
                  'Weight: ${widget.store.contactNumber} kg',
                  style: const TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 16),
                Text(
                  'Dimensions: ${widget.store.email}',
                  style: const TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 16),
                const Divider(color: Colors.grey),
                const SizedBox(height: 16),
                const Text(
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
