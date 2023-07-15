import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shopping/ScreenDetails/ProductDetailsScreen.dart';
import 'package:shopping/Screens/ShoppingCartScreen.dart';

import '../Models/Product.dart';
import 'package:http/http.dart' as http;

class ProductListScreen extends StatefulWidget {
  @override
  _ProductListScreenState createState() => _ProductListScreenState();
}

class _ProductListScreenState  extends State<ProductListScreen> {
  List<Product> products = [];
  List<Product> filteredProducts = [];
  ScrollController _scrollController = ScrollController();
  int pageSize = 20;
  int pageNumber=1;

  bool isLoading = false;
  bool isResultFound = false;
  String searchQuery = '';


  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(_scrollListener);
    fetchData();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> fetchData() async {
    if (!isLoading) {
      setState(() {
        pageSize = 20;
        pageNumber = 1;
        isLoading = true;
      });
      try {
        var url = 'https://portalapps.azurewebsites.net/api/Products/LoadPartialData?pageSize=$pageSize&pageNumber=$pageNumber';
        if (searchQuery != "") {
          url =
          'https://portalapps.azurewebsites.net/api/Products/LoadPartialDataWithSearch?pageSize=$pageSize&pageNumber=$pageNumber&searchQuery=$searchQuery';
        }
        final response = await http.get(Uri.parse(url));

        if (response.statusCode == 200) {
          final jsonResponse = json.decode(response.body);
          final List<dynamic> jsonList = jsonResponse as List<dynamic>;

          final List<Product> newProducts = jsonList.map((item) {
            return Product(
              RowKey: item['RowKey'] as String,
              Name: item['name'] as String,
              Description: item['description'] as String,
            );
          }).toList();

          setState(() {
            products.addAll(newProducts);
            isLoading = false;
          });
        } else {
          throw Exception('Failed to load data');
        }
      } catch (error) {
        throw Exception('Error: $error');
      }
    }
  }

  void _scrollListener() {
    if (!_scrollController.position.atEdge &&
        _scrollController.position.pixels >=
            _scrollController.position.maxScrollExtent - 500) {
      loadMoreData();
    }
  }

  Future<void> loadMoreData() async {
    if (!isLoading) {
      setState(() {
        isLoading = true;
      });

      await Future.delayed(Duration(seconds: 2));
      pageSize = 20;
      pageNumber+=1;
      try {
        var url = 'https://portalapps.azurewebsites.net/api/Products/LoadPartialData?pageSize=$pageSize&pageNumber=$pageNumber';
        if(searchQuery !=""){  url= 'https://portalapps.azurewebsites.net/api/Products/LoadPartialDataWithSearch?pageSize=$pageSize&pageNumber=$pageNumber&searchQuery=$searchQuery';}
        final response = await http.get(Uri.parse(url));

        if (response.statusCode == 200) {
          final jsonResponse = json.decode(response.body);
          final List<dynamic> jsonList = jsonResponse as List<dynamic>;

          final List<Product> newProducts = jsonList.map((item) {
            return Product(
              RowKey: item['RowKey'] as String,
              Name: item['name'] as String,
              Description: item['description'] as String,
            );
          }).toList();

          setState(() {
            products.addAll(newProducts);
            isLoading = false;

          });
        } else {
          throw Exception('Failed to load data');
        }
      } catch (error) {
        throw Exception('Error: $error');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Product List'),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ShoppingCart()),
              );
            },
            icon: Icon(Icons.shopping_cart_rounded),
          ),
          IconButton(
            onPressed: () {
              setState(() {
                products.clear();

                fetchData();
              });
            },
            icon: Icon(Icons.refresh),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              onSubmitted: (value) {
                setState(() {
                  searchQuery = value;
                  pageSize = 20;
                  pageNumber+=1;
                  products.clear();
                  fetchData();
                });
              },
              decoration: InputDecoration(
                hintText: 'Search',
                prefixIcon: Icon(Icons.search),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              itemCount: products.length + 1,
              itemBuilder: (context, index) {
                if (index == products.length) {
                  if (isLoading) {
                    return Center(
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                        strokeWidth: 5.0,
                      ),
                    );

                  }
                  if (products.isEmpty) {
                    return Center(
                      child: Text(
                        'No results found',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Colors.red,
                        ),
                      ),
                    );

                  }
                  return SizedBox();
                } else {
                  final product = products[index];
                  return ListTile(
                    title: Text(product.Name),
                    subtitle: Text(product.Description),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ProductDetailsScreen(product: product),
                        ),
                      );
                    },
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }






}


