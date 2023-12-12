import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shopping/Account/LoginPage.dart';
import 'package:shopping/Account/Profile.dart';
import 'package:shopping/GlobalTools/ImageUploadWidget.dart';
import 'package:shopping/Shop/Cart/CartList.dart';
import 'package:http/http.dart' as http;
import 'package:shopping/Shop/Models/Group.dart';
import 'package:shopping/Shop/Models/Product.dart';
import 'package:shopping/Shop/Models/Store.dart';
import 'package:shopping/Shop/Models/SubGroup.dart';
import 'package:shopping/Shop/Products/_ProductCard.dart';
import 'package:shopping/Shop/Products/ProductDetails.dart';
import 'package:shopping/Shop/Stores/StoreList.dart';
import '../../GlobalTools/AppConfig.dart';
import '../../GlobalTools/ErrorScreen.dart';
import '../../GlobalTools/LocalizationManager.dart';
import '../../main.dart';
import '../Groups/FilterOption.dart';
import '../../GlobalTools/ListNoResultFound.dart';
import '../../GlobalTools/ProgressCustome.dart';
import '../Cart/_CartShopIcon.dart';
import '../../GlobalTools/bottomNavigationBar.dart';

class StoreProductList extends StatefulWidget {
  final Store store;
  const StoreProductList({
    required this.store,
  });

  @override
  // ignore: library_private_types_in_public_api
  _StoreProductListState createState() =>
      _StoreProductListState();
}

class _StoreProductListState extends State<StoreProductList> {
  String storeRowKey='';

  Locale currentLocale = LocalizationManager().getCurrentLocale();
  int pageSize = 20;
  int pageNumber = 1;
  int layoutNumber = 2;


  bool isLoading = false;
  bool isPageLoading = false;
  bool isResultFound = false;
  bool hasError = false;
  bool _showScrollButton = false; // Add this variable
  bool _isAddingToCart = false;

  String searchQuery = '';
  String errorMessage = '';
  late String _productRowKey = '';
  String? accountRowKey = '';
  String selectedGroup = '-'; // No default selected group // Default selected group filter
  String selectedSubGroup = '-'; // No default selected group // Default selected group filter


  static List<Product> products = [];
  List<Product> filteredProducts = [];
  //static List<Group> groupOptions = []; // List of grouping options
  static List<SubGroup> subGroupOptions = [];

  static List<SubGroup> filteredSubGroupOptions = [];

  final TextEditingController _searchController = TextEditingController();
  ScrollController _scrollController = ScrollController();



  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    if (currentLocale.languageCode.toLowerCase() == 'ar') {
      _changeLanguage(const Locale('ar'));
    } else {
      _changeLanguage(const Locale('en'));
    }
  }

  @override
  void initState() {
    super.initState();
    setState(() {
      isPageLoading = true;
    });

    handleAuthenticationAction();
    _scrollController = ScrollController();
    _scrollController.addListener(_scrollListener);


    filteredSubGroupOptions.add(SubGroup(
      partitionKey: '',
      rowKey: '',
      seq: 1,
      name: '-',
      languageID: currentLocale.languageCode,
      imageURL: '',
      active: true,
      groupRowKey: '',
    ));
    subGroupOptions.add(SubGroup(
      partitionKey: '',
      rowKey: '',
      seq: 1,
      name: '-',
      languageID: currentLocale.languageCode,
      imageURL: '',
      active: true,
      groupRowKey: '',
    ));
    fetchDataSubGroups();
    fetchData().then((_) {
      // Set isPageLoading to false after fetchData completes
      setState(() {
        isPageLoading = false;
      });
    });
  }


  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> fetchData() async {
    if (!isLoading) {
      setState(() {
        pageSize = 20;
        pageNumber = 1;
        isLoading = true;

        hasError = false;
        errorMessage = '';
      });
      try {
        products.clear();

        var subGroupRowKey = subGroupOptions
            .firstWhere((element) => element.name == selectedSubGroup)
            .rowKey;
        var url =
            'https://portalapps.azurewebsites.net/api/Products/LoadPartialData?pageSize=$pageSize&pageNumber=$pageNumber&Lan=${currentLocale
            .languageCode.toUpperCase()}&groupOptions=${widget.store.groupRowKey}&subGroupOptions=$subGroupRowKey';
        if (searchQuery != "") {
          url =
          '${AppConfig.baseUrl}/api/Products/LoadPartialDataWithSearch?pageSize=$pageSize&pageNumber=$pageNumber&searchQuery=$searchQuery&Lan=${currentLocale
              .languageCode.toUpperCase()}&groupOptions=${widget.store.groupRowKey}&subGroupOptions=$subGroupRowKey';
        }
        final response = await http.get(Uri.parse(url));

        if (response.statusCode == 200) {
          final jsonResponse = json.decode(response.body);
          final List<dynamic> jsonList = jsonResponse as List<dynamic>;
          final List<Product> newProducts =
          jsonList.map((json) => Product.fromJson(json)).toList();
          setState(() {
            products.addAll(newProducts);
            isLoading = false;
          });
        } else {
          setState(() {
            hasError = true;
            errorMessage = 'Failed to load data';
            isLoading = false;
          });
        }
      } catch (error) {
        setState(() {
          hasError = true;
          errorMessage = 'Error: $error';
          isLoading = false;
        });
      }
    }
  }

  Future<void> loadMoreData() async {
    if (!isLoading) {
      setState(() {
        isLoading = true;
        hasError = false;
        errorMessage = '';
        pageSize = 20;
        pageNumber += 1;
      });

      await Future.delayed(const Duration(seconds: 2));

      try {
        var subGroupRowKey = subGroupOptions
            .firstWhere((element) => element.name == selectedSubGroup)
            .rowKey;
        var url =
            '${AppConfig.baseUrl}/api/Products/LoadPartialData?pageSize=$pageSize&pageNumber=$pageNumber&Lan=${currentLocale
            .languageCode.toUpperCase()}&groupOptions=${widget.store.groupRowKey}&subGroupOptions=$subGroupRowKey';
        if (searchQuery != "") {
          url =
          '${AppConfig.baseUrl}/api/Products/LoadPartialDataWithSearch?pageSize=$pageSize&pageNumber=$pageNumber&searchQuery=$searchQuery&Lan=${currentLocale
              .languageCode.toUpperCase()}&groupOptions=${widget.store.groupRowKey}&subGroupOptions=$subGroupRowKey';
        }
        final response = await http.get(Uri.parse(url));

        if (response.statusCode == 200) {
          final jsonResponse = json.decode(response.body);
          final List<dynamic> jsonList = jsonResponse as List<dynamic>;
          final List<Product> newProducts =
          jsonList.map((json) => Product.fromJson(json)).toList();
          setState(() {
            products.addAll(newProducts);
            isLoading = false;
          });
        } else {
          setState(() {
            hasError = true;
            errorMessage = 'Failed to load data';
            isLoading = false;
          });
        }
      } catch (error) {
        setState(() {
          hasError = true;
          errorMessage = 'Error: $error';
          isLoading = false;
        });
      }
    }
  }

  void _scrollListener() {
    if (!_scrollController.position.atEdge &&
        _scrollController.position.pixels >=
            _scrollController.position.maxScrollExtent - 500) {
      loadMoreData();
    }
    // Update the visibility of the scroll button
    setState(() {
      _showScrollButton = _scrollController.position.pixels >= 200;
    });
  }

  void _changeLanguage(Locale newLocale) {
    setState(() {
      FlutterI18n.refresh(context, newLocale);
      LocalizationManager().setCurrentLocale(newLocale);
      fetchDataSubGroups();
      fetchData();
    });
  }

  // This function will be called when the product is added to the cart
  void addToCart(Product product) {
    setState(() {
      _isAddingToCart = true; // Set the flag to indicate adding to cart
      _productRowKey = product.rowKey;
    });

    // Simulate a delay to show the progress indicator
    Future.delayed(const Duration(seconds: 2), () {
      setState(() {
        var cartItem = ShoppingCart.getItems().where((element) =>
        element.rowKey == _productRowKey);
        if (cartItem.isEmpty) {
          ShoppingCart.addProduct(product);
          _isAddingToCart = false; // Reset the flag after adding to cart
          // Show a snackbar message
          _showMessage(
            "${product.name} added to the cart",
            Colors.lightGreen,
          );
        } else {
          _isAddingToCart = false;
          _showMessage(
            "${product.name} already on the cart",
            Colors.orangeAccent,
          );
        }
      });
    });
  }

  void _showMessage(String message, Color messageColor) {
    final snackBar = SnackBar(
      content: Text(message),
      backgroundColor: messageColor,
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  void _increaseQuantity(String rowKey) {
    setState(() {
      Product proFound;
      try {
        proFound = products.firstWhere((element) => element.rowKey == rowKey);
        if (proFound.productQuantity > proFound.cartQuantity) {
          proFound.cartQuantity++;
        }
      } catch (e) {
        // Handle the case when no matching element is found
      }
    });
  }

  void _decreaseQuantity(String rowKey) {
    setState(() {
      Product proFound;
      try {
        proFound = products.firstWhere((element) => element.rowKey == rowKey);
        if (proFound.cartQuantity > 1) {
          proFound.cartQuantity--;
        }
      } catch (e) {
        // Handle the case when no matching element is found
      }
    });
  }

  Future<void> fetchDataSubGroups() async {
    try {
      var url = '${AppConfig.baseUrl}/api/SubGroups/LoadAllData?Lan=${currentLocale.languageCode.toUpperCase()}';
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        final List<dynamic> jsonList = jsonResponse as List<dynamic>;
        final List<SubGroup> newSubGroups =
        jsonList.map((json) => SubGroup.fromJson(json)).toList();
        newSubGroups.sort((a, b) => a.name.compareTo(b.name));

        //print(newSubGroups.);
        setState(() {
          subGroupOptions.clear();
          subGroupOptions.add(SubGroup(partitionKey: '',
              rowKey: '',
              seq: 1,
              name: '-',
              languageID: Localizations
                  .localeOf(context)
                  .languageCode,
              imageURL: '',
              active: true,
              groupRowKey: ''));
          subGroupOptions.addAll(newSubGroups.where((element) => element.groupRowKey==widget.store.groupRowKey).toList());

          filteredSubGroupOptions.clear();
          filteredSubGroupOptions.add(SubGroup(partitionKey: '',
              rowKey: '',
              seq: 1,
              name: '-',
              languageID: Localizations
                  .localeOf(context)
                  .languageCode,
              imageURL: '',
              active: true,
              groupRowKey: ''));
          filteredSubGroupOptions.addAll(newSubGroups.where((element) => element.groupRowKey==widget.store.groupRowKey).toList());
        });
      }
    } catch (error) {
      print(error);
    }
  }

  Widget _buildSubGroups() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
      child: Row(
        children: filteredSubGroupOptions.map((SubGroup value) {
          return GestureDetector(
            onTap: () {
              setState(() {
                selectedSubGroup = value.name;
                applySubGroupFilter(value.name);
              });
            },
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 5),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: selectedSubGroup == value.name
                    ? Colors.blue
                    : Colors.grey[300],
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: selectedSubGroup == value.name
                      ? Colors.blue
                      : Colors.grey[300]!,
                  width: 1.5,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 3,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Text(
                value.name,
                style: TextStyle(
                  color: selectedSubGroup == value.name
                      ? Colors.white
                      : Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  void applyGroupFilter(String group, String rowKey) {
    setState(() {
      selectedGroup = group;
      selectedSubGroup = '-';
      filteredSubGroupOptions = group == '-' ? subGroupOptions :
      subGroupOptions.where((element) => element.groupRowKey == rowKey)
          .toList();
      fetchData();
    });
  }

  void applySubGroupFilter(String subGroup) {
    setState(() {
      selectedSubGroup = subGroup;
      fetchData();
    });
  }

  // Add this method to your _ProductListState class
  Widget _buildListItem(BuildContext context, int index) {
    if (index == products.length) {
      if (isLoading) {
        return (pageNumber == 1) ? ProgressCustom(
          strokeWidth: 4.0, // Custom stroke width
          size: 600.0, // Custom size
        ) : ProgressCustom();
      }
      if (searchQuery != "" && products.isEmpty) {
        return ListNoResultFound(onClear: _clearSearch,);
      }
      return const SizedBox();
    }
    else {
      final product = products[index];

      return ProductCard(
        product: product,
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ProductDetails(product: product),
            ),
          );
        },
        addToCart: () => addToCart(product),
        showProgressIndicator: _isAddingToCart,
        rowKey: _productRowKey,
        increaseQuantity: _increaseQuantity,
        decreaseQuantity: _decreaseQuantity,
        layoutNumber: layoutNumber,
      );
    }
  }

  void _clearSearch() {
    setState(() {
      _searchController.clear();
      searchQuery = ''; // Clear the searchQuery variable
      // Add other necessary operations related to clearing the search here
      pageSize = 20;
      pageNumber += 1;
      products.clear();
      fetchData();
    });
  }

  bool isAuthenticated = false; // Assuming this flag manages user authentication status

  // Function to handle the action when the user is not authenticated
  Future<void> handleAuthenticationAction() async {
    // ignore: use_build_context_synchronously

    // Implement the action needed when the user is not authenticated
    // For example, show a login dialog or navigate to the authentication screen
    // You can replace this with your actual authentication logic
    // For demonstration purposes, let's show a simple dialog

    SharedPreferences prefs = await SharedPreferences.getInstance();
    accountRowKey = prefs.getString('RowKey');

    if (accountRowKey == null) {
      // Retrieve other user information using appropriate keys
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Authentication Required'),
            content: const Text('Please log in to perform this action.'),
            actions: [
              TextButton(
                onPressed: () {
                  // Implement the logic to navigate to the authentication screen
                  // For example:
                  // Navigator.pushNamed(context, '/login');
                  Navigator.push(context, MaterialPageRoute(
                      builder: (context) => LoginPage()));
                },
                child: const Text('OK'),
              ), TextButton(
                onPressed: () {
                  // Implement the logic to navigate to the authentication screen
                  // For example:
                  // Navigator.pushNamed(context, '/login');
                  Navigator.pop(context); // Close the dialog
                },
                child: const Text('Later'),
              ),
            ],
          );
        },
      );
    } else {
      setState(() {
        isAuthenticated = true;
      });
    }
  }

  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    switch (index) {
    //ProductLIst
      case 0:
      //Navigator.push(context,MaterialPageRoute(builder:(context) => ProductList()));
        break;
      case 1:
      // Navigate to the settings page or perform settings-related actions
      Navigator.push(context,MaterialPageRoute(builder:(context) => StoreList()));
        break;
      case 2:
      // Navigate to the settings page or perform settings-related actions
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => Profile()));
        break;
    // Add more cases for other items if needed
      default:
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    //_changeLanguage(currentLocale);
    // Determine the text direction based on the current locale
    TextDirection textDirection =
    currentLocale.languageCode.toLowerCase() == 'ar'
        ? TextDirection.rtl
        : TextDirection.ltr;


    return Directionality(
      textDirection: textDirection,

      child: Scaffold(

        appBar: AppBar(

          title: Text(widget.store.name),
          actions: [

            CartShopIcon(),
            IconButton(onPressed: () {
              setState(() {
                layoutNumber = (layoutNumber == 2 ? 1 : 2);
              });
            },
                icon: Icon(
                    layoutNumber == 2 ? Icons.view_list : Icons.list_alt)),
            !isAuthenticated ? IconButton(
                onPressed: handleAuthenticationAction,
                icon: const Icon(Icons.error),
                color: Colors.deepOrange
            ) : Container(),
          ],
        ),
        body: isPageLoading
            ? const Center(
          child: CircularProgressIndicator(), // Display a loading indicator
        )
            : Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(

                //width: double.infinity,
                height: 150,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  boxShadow: [

                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: Offset(0, 3), // changes the position of the shadow
                    ),
                  ],
                ),
                child: Stack(
                  fit: StackFit.expand,
                  alignment: Alignment.bottomLeft ,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.network(
                        widget.store.imageURL,
                        fit: BoxFit.fitWidth,
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.cloud_upload_outlined,color: Colors.green),
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return Dialog(
                              child: ImageUploadWidget()
                            );
                          },
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),


            _buildSubGroups(),


            Expanded(
              child: hasError ? ErrorScreen(errorMessage: errorMessage,
                onRetry: () {
                  setState(() {
                    hasError = false;
                    errorMessage = '';
                    products.clear();
                    fetchData();
                  });
                },
              ) : RefreshIndicator(
                onRefresh: () async {
                  await fetchData(); // Example: Fetching data
                  await Future.delayed(const Duration(milliseconds: 500)); // Adjust duration as needed
                },
                child: ListView.builder(
                  shrinkWrap: true,
                  controller: _scrollController,
                  itemCount: products.length + 1,
                  itemBuilder: (context, index) {
                    return _buildListItem(context, index);
                  },
                ),
              ),
            ),
          ],
        ),
        bottomNavigationBar: ProfileBottomNavigationBar(
          currentIndex: _selectedIndex,
          onItemTapped: _onItemTapped,
        ),

        floatingActionButton: Visibility(
          visible: _showScrollButton,
          child: FloatingActionButton(

            onPressed: () {
              // Scroll to the top of the list using the ScrollController
              _scrollController.animateTo(
                0.0,
                duration: const Duration(milliseconds: 500),
                curve: Curves.easeInOut,
              );
            },
            child: const Icon(Icons.arrow_upward),
          ),
        ),

      ),
    );
  }
}
