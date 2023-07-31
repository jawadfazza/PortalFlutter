import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:flutter_i18n/flutter_i18n_delegate.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:shopping/GlobalTools/LanguageButtons.dart';
import 'package:shopping/Shop/Cart/ShoppingCartScreen.dart';
import 'package:http/http.dart' as http;
import 'package:shopping/Shop/Models/Product.dart';
import 'package:shopping/Shop/Product/Partial/ProductListItem.dart';
import 'package:shopping/Shop/Product/ProductDetailsScreen.dart';

class ProductListScreen extends StatefulWidget {
  final FlutterI18nDelegate flutterI18nDelegate;

  ProductListScreen(this.flutterI18nDelegate);
  @override
  _ProductListScreenState createState() => _ProductListScreenState(flutterI18nDelegate);
}

class _ProductListScreenState  extends State<ProductListScreen> {
  _ProductListScreenState(this.flutterI18nDelegate);

  final FlutterI18nDelegate flutterI18nDelegate;
  String languageCode ="";
  Locale _currentLocale = Locale("en");

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
    languageCode=_currentLocale.languageCode.toUpperCase();
    if (!isLoading) {
      setState(() {
        pageSize = 20;
        pageNumber = 1;
        isLoading = true;
      });
      try {
        var url = 'https://portalapps.azurewebsites.net/api/Products/LoadPartialData?pageSize=$pageSize&pageNumber=$pageNumber&Lan=$languageCode';
        if (searchQuery != "") {
          url =
          'https://portalapps.azurewebsites.net/api/Products/LoadPartialDataWithSearch?pageSize=$pageSize&pageNumber=$pageNumber&searchQuery=$searchQuery&Lan=$languageCode';
        }
        final response = await http.get(Uri.parse(url));

        if (response.statusCode == 200) {
          final jsonResponse = json.decode(response.body);
          final List<dynamic> jsonList = jsonResponse as List<dynamic>;
          final List<Product> newProducts = jsonList.map((json) => Product.fromJson(json)).toList();

          print(newProducts);
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
    languageCode=_currentLocale.languageCode.toUpperCase();
    if (!isLoading) {
      setState(() {
        isLoading = true;
      });

      await Future.delayed(Duration(seconds: 2));
      pageSize = 20;
      pageNumber+=1;
      try {
        var url = 'https://portalapps.azurewebsites.net/api/Products/LoadPartialData?pageSize=$pageSize&pageNumber=$pageNumber&Lan=$languageCode';
        if(searchQuery !=""){  url= 'https://portalapps.azurewebsites.net/api/Products/LoadPartialDataWithSearch?pageSize=$pageSize&pageNumber=$pageNumber&searchQuery=$searchQuery&Lan=$languageCode';}
        final response = await http.get(Uri.parse(url));

        if (response.statusCode == 200) {
          final jsonResponse = json.decode(response.body);
          final List<dynamic> jsonList = jsonResponse as List<dynamic>;
          final List<Product> newProducts = jsonList.map((json) => Product.fromJson(json)).toList();
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

  void _changeLanguage(Locale newLocale) {
    setState(() {
      _currentLocale = newLocale;
      FlutterI18n.refresh(context, newLocale);
    });
  }
  @override
  Widget build(BuildContext context) {
    if(languageCode==""){
      languageCode =ModalRoute.of(context)?.settings.arguments as String;
      _changeLanguage(Locale(languageCode));
    }
    return MaterialApp(
      localizationsDelegates: [
        widget.flutterI18nDelegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: [
        const Locale('en'),
        const Locale('ar'),
      ],
      locale:  _currentLocale,
      home : Scaffold(
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
                    return ProductListItem(product: product,
                      onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) =>  ProductDetailsScreen(product: product)));
                    },
                    );
                  }
                },
              ),
            ),

  ],
        ),
        bottomNavigationBar: LanguageButtons(
          currentLocale: _currentLocale,
          changeLanguage: _changeLanguage,
        ),),
    );
  }






}


