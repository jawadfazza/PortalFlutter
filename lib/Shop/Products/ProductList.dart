import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shopping/Account/LoginPage.dart';
import 'package:shopping/Account/Profile.dart';
import 'package:shopping/GlobalTools/LanguageButtons.dart';
import 'package:shopping/Shop/Cart/CartList.dart';
import 'package:http/http.dart' as http;
import 'package:shopping/Shop/Models/Group.dart';
import 'package:shopping/Shop/Models/Product.dart';
import 'package:shopping/Shop/Models/SubGroup.dart';
import 'package:shopping/Shop/Products/_ProductCard.dart';
import 'package:shopping/Shop/Products/ProductDetails.dart';
import '../../GlobalTools/ErrorScreen.dart';
import '../../GlobalTools/LocalizationManager.dart';
import '../../main.dart';
import '../Groups/FilterOption.dart';
import '../../GlobalTools/ListNoResultFound.dart';
import '../../GlobalTools/ProgressCustome.dart';
import '../Cart/_CartShopIcon.dart';





class ProductList extends StatefulWidget {

  @override
  // ignore: library_private_types_in_public_api
  _ProductListState createState() =>
      _ProductListState();
}

class _ProductListState extends State<ProductList> {

  Locale currentLocale = LocalizationManager().getCurrentLocale();

  static List<Product> products = [];
  List<Product> filteredProducts = [];
  ScrollController _scrollController = ScrollController();
  int pageSize = 20;
  int pageNumber = 1;

  bool isLoading = false;
  bool isResultFound = false;
  bool hasError = false;
  bool _showScrollButton = false; // Add this variable
  bool _isAddingToCart = false;

  String searchQuery = '';
  String errorMessage = '';
  late String _productRowKey = '';
  String selectedGroup='-'; // No default selected group // Default selected group filter
  String selectedSubGroup='-'; // No default selected group // Default selected group filter

  int layoutNumber=2;

  static List<Group> groupOptions=[] ; // List of grouping options
  static List<SubGroup> subGroupOptions=[] ;
  static List<SubGroup> filteredSubGroupOptions=[] ;

  final TextEditingController _searchController = TextEditingController();





  @override
  void initState() {
    super.initState();
    
    _scrollController = ScrollController();
    _scrollController.addListener(_scrollListener);
    groupOptions.add(Group(partitionKey: '', rowKey: '', seq: 1, name: '-', description: '', languageID: currentLocale.languageCode, imageURL: '', active: true));
    fetchDataGroups();
    filteredSubGroupOptions.add(SubGroup(partitionKey: '', rowKey: '', seq: 1, name: '-', languageID: currentLocale.languageCode, imageURL: '', active: true,groupRowKey: ''));
    subGroupOptions.add(SubGroup(partitionKey: '', rowKey: '', seq: 1, name: '-', languageID: currentLocale.languageCode, imageURL: '', active: true,groupRowKey: ''));
    fetchDataSubGroups();
    fetchData();
  }


  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> fetchData() async {

    products.clear();
    if (!isLoading) {
      setState(() {
        pageSize = 20;
        pageNumber = 1;
        isLoading= true;
        hasError = false;
        errorMessage = '';
      });
      try {
        var groupRowKey = groupOptions.firstWhere((element) => element.name==selectedGroup).rowKey;
        var subGroupRowKey = subGroupOptions.firstWhere((element) => element.name==selectedSubGroup).rowKey;
        var url =
            'https://portalapps.azurewebsites.net/api/Products/LoadPartialData?pageSize=$pageSize&pageNumber=$pageNumber&Lan=${currentLocale.languageCode}&groupOptions=$groupRowKey&subGroupOptions=$subGroupRowKey';
        if (searchQuery != "") {
          url =
          'https://portalapps.azurewebsites.net/api/Products/LoadPartialDataWithSearch?pageSize=$pageSize&pageNumber=$pageNumber&searchQuery=$searchQuery&Lan=${currentLocale.languageCode}&groupOptions=$groupRowKey&subGroupOptions=$subGroupRowKey';
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
        var groupRowKey = groupOptions.firstWhere((element) => element.name==selectedGroup).rowKey;
        var subGroupRowKey = subGroupOptions.firstWhere((element) => element.name==selectedSubGroup).rowKey;
        var url =
            'https://portalapps.azurewebsites.net/api/Products/LoadPartialData?pageSize=$pageSize&pageNumber=$pageNumber&Lan=${currentLocale.languageCode}&groupOptions=$groupRowKey&subGroupOptions=$subGroupRowKey';
        if (searchQuery != "") {
          url =
          'https://portalapps.azurewebsites.net/api/Products/LoadPartialDataWithSearch?pageSize=$pageSize&pageNumber=$pageNumber&searchQuery=$searchQuery&Lan=${currentLocale.languageCode}&groupOptions=$groupRowKey&subGroupOptions=$subGroupRowKey';
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
      //currentLocale.load(newLocale);
      fetchDataGroups();
      fetchDataSubGroups();
      fetchData();

    });
  }
  // This function will be called when the product is added to the cart
  void addToCart(Product product) {
    setState(() {
      _isAddingToCart = true; // Set the flag to indicate adding to cart
      _productRowKey=product.rowKey;
    });

    // Simulate a delay to show the progress indicator
    Future.delayed(const Duration(seconds: 2), () {
      setState(() {
        var cartItem= ShoppingCart.getItems().where((element) => element.rowKey==_productRowKey);
        if(cartItem.isEmpty){
          ShoppingCart.addProduct(product);
          _isAddingToCart = false; // Reset the flag after adding to cart
          // Show a snackbar message
          _showMessage(
            "${product.name} added to the cart",
            Colors.lightGreen,
          );
        }else{
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
    setState((){
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
    setState((){
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


  Future<void> fetchDataGroups() async {

    try {
      var url = 'https://portalapps.azurewebsites.net/api/Groups/LoadAllData?Lan=${currentLocale.languageCode}';
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        final List<dynamic> jsonList = jsonResponse as List<dynamic>;
        final List<Group> newGroups =
        jsonList.map((json) => Group.fromJson(json)).toList();
        //print(newGroups);
        setState(() {

          groupOptions.clear();
          groupOptions.add(Group(partitionKey: '', rowKey: '', seq: 1, name: '-', description: '', languageID: currentLocale.languageCode, imageURL: '', active: true));
          groupOptions.addAll(newGroups);

        });
      }

    } catch (error) {
      print(error);
    }

  }
  Future<void> fetchDataSubGroups() async {

    try {
      var url = 'https://portalapps.azurewebsites.net/api/SubGroups/LoadAllData?Lan=${currentLocale.languageCode}';
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
          subGroupOptions.add(SubGroup(partitionKey: '', rowKey: '', seq: 1, name: '-', languageID: Localizations.localeOf(context).languageCode, imageURL: '', active: true,groupRowKey: ''));
          subGroupOptions.addAll(newSubGroups);

          filteredSubGroupOptions.clear();
          filteredSubGroupOptions.add(SubGroup(partitionKey: '', rowKey: '', seq: 1, name: '-', languageID: Localizations.localeOf(context).languageCode, imageURL: '', active: true,groupRowKey: ''));
          filteredSubGroupOptions.addAll(newSubGroups);
        });
      }

    } catch (error) {
      print(error);
    }

  }
  Widget _buildGroups() {
    return SizedBox(
      height: 30, // Adjust the height as needed
      child: ListView(
        shrinkWrap: true,
        scrollDirection: Axis.horizontal, // Change to horizontal
        children: groupOptions.map((Group value) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0), // Add horizontal padding
            child: FilterOption(
              title: value.name,
              isSelected: selectedGroup == value.name, // Update isSelected
              onTap: () {
                setState(() {
                  selectedGroup = value.name;
                  applyGroupFilter(value.name,value.rowKey);
                });
              },
            ),
          );
        }).toList(),
      ),
    );
  }
  Widget _buildSubGroups() {
    return SizedBox(
      height: 30, // Adjust the height as needed
      child: ListView(
        shrinkWrap: true,
        scrollDirection: Axis.horizontal, // Change to horizontal
        children: filteredSubGroupOptions.map((SubGroup value) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0), // Add horizontal padding
            child: FilterOption(
              title: value.name,
              isSelected: selectedSubGroup == value.name, // Update isSelected
              onTap: () {
                setState(() {
                  selectedSubGroup = value.name;
                  applySubGroupFilter(value.name);
                });
              },
            ),
          );
        }).toList(),
      ),
    );
  }

  void applyGroupFilter(String group,String rowKey) {
    setState(() {

      selectedGroup=group;
      selectedSubGroup='-';
      filteredSubGroupOptions=group=='-'?subGroupOptions:
      subGroupOptions.where((element) => element.groupRowKey==rowKey).toList();
      fetchData();
    });
  }
  void applySubGroupFilter(String subGroup) {
    setState(() {
      selectedSubGroup=subGroup;
      fetchData();
    });
  }

  // Add this method to your _ProductListState class
  Widget _buildListItem(BuildContext context, int index) {
    if (index == products.length) {
      if (isLoading) {
        return (pageNumber==1)? ProgressCustom(
          strokeWidth: 4.0, // Custom stroke width
          size: 600.0, // Custom size
        ): ProgressCustom();

      }
      if(searchQuery!=""&&products.isEmpty){
        return  ListNoResultFound();
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
        addToCart: ()=> addToCart(product),
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
  Future<void> handleAuthenticationAction() async {      // ignore: use_build_context_synchronously

    // Implement the action needed when the user is not authenticated
    // For example, show a login dialog or navigate to the authentication screen
    // You can replace this with your actual authentication logic
    // For demonstration purposes, let's show a simple dialog

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userEmail = prefs.getString('userEmail');
    if(userEmail!=null){
      isAuthenticated=true;
      Navigator.push(context, MaterialPageRoute(
          builder: (context) => Profile()));
    }else {
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
    }
  }

  @override
  Widget build(BuildContext context) {

    //_changeLanguage(currentLocale);
    // Determine the text direction based on the current locale
    TextDirection textDirection =
    currentLocale.languageCode == 'AR' ? TextDirection.rtl : TextDirection.ltr;

    return Directionality(
      textDirection: textDirection,

      child: Scaffold(

        appBar: AppBar(
          title:  Text(FlutterI18n.translate(context, "ProductList")  ),
          actions: [

            CartShopIcon(),
            IconButton(onPressed: () {
              setState(() {
                layoutNumber = (layoutNumber == 2 ? 1 : 2);
              });
            }, icon: Icon(layoutNumber == 2 ? Icons.view_list : Icons.list_alt)),
            !isAuthenticated? IconButton(
                onPressed: handleAuthenticationAction,
                icon: const Icon(Icons.error),
                color: Colors.deepOrange
            ): IconButton(
              onPressed: handleAuthenticationAction,
              icon: const Icon(Icons.account_circle_sharp),
              color: Colors.white,

            ),
          ],
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: _searchController,
                onSubmitted: (value) {
                  setState(() {
                    searchQuery = value.trim();
                    pageSize = 20;
                    pageNumber += 1;
                    products.clear();
                    fetchData();
                  });
                },
                decoration: InputDecoration(
                  hintText: FlutterI18n.translate(context, "Search") ,
                  prefixIcon: const Icon(Icons.search),
                  suffixIcon: _searchController.text.isNotEmpty
                      ? IconButton(
                    icon: const Icon(Icons.clear),
                    onPressed: _clearSearch,
                  )
                      : null,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: const BorderSide(color: Colors.grey),
                  ),
                  filled: true,
                  fillColor: Colors.grey[200],
                  contentPadding: const EdgeInsets.symmetric(
                      vertical: 12.0, horizontal: 16.0),
                ),
                style: const TextStyle(fontSize: 16.0),
              ),
            ),
            const SizedBox(height: 10),
            _buildGroups(),
            const SizedBox(height: 10),
            _buildSubGroups(),
            const SizedBox(height: 10),

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
                  // Set _isRefreshing to true to start the refresh process
                  setState(() {
                    //_isRefreshing = true;
                  });

                  // Your refresh logic here
                  await fetchData(); // Example: Fetching data

                  // Simulate a delay to remove the indicator (optional)
                  await Future.delayed(const Duration(milliseconds: 500)); // Adjust duration as needed

                  // Set _isRefreshing to false to indicate the refresh has completed
                  setState(() {
                    //_isRefreshing = false;
                  });
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
        bottomNavigationBar: LanguageButtons(
          currentLocale: currentLocale,
          changeLanguage: _changeLanguage,
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
