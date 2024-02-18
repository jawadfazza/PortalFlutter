import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shopping/Account/LoginPage.dart';
import 'package:shopping/Account/Profile.dart';
import 'package:shopping/Account/SettingsPage.dart';
import 'package:shopping/Shop/Controllar/ProductControllar.dart';
import 'package:shopping/Shop/View/Cart/CartList.dart';
import 'package:http/http.dart' as http;
import 'package:shopping/Shop/Models/Group.dart';
import 'package:shopping/Shop/Models/Product.dart';
import 'package:shopping/Shop/Models/SubGroup.dart';
import 'package:shopping/Shop/View/Products/Body/_ProductCard.dart';
import 'package:shopping/Shop/View/Products/Body/ProductDetails.dart';
import 'package:shopping/Shop/View/Stores/StoreList.dart';
import '../../../GlobalTools/AppConfig.dart';
import '../../../GlobalTools/ErrorScreen.dart';
import '../../../GlobalTools/LocalizationManager.dart';
import '../../../GlobalTools/ListNoResultFound.dart';
import '../../../GlobalTools/ProgressCustome.dart';

import '../../../GlobalTools/bottomNavigationBar.dart';
import '../../Models/Constraint.dart';
import '../Cart/_CartShopIcon.dart';


class ProductList extends StatefulWidget {

  @override
  // ignore: library_private_types_in_public_api
  _ProductListState createState() =>
      _ProductListState();
}

class _ProductListState extends State<ProductList> {
  late SharedPreferences _prefs;
  ProductControllar  _prodCont= ProductControllar();
  final TextEditingController _searchController = TextEditingController();
  ScrollController _scrollController = ScrollController();
  bool _showScrollButton = false;
  bool _isAddingToCart = false;
  bool _isListViewScrolling = false;

  @override
 void didChangeDependencies() {
   // TODO: implement didChangeDependencies
   super.didChangeDependencies();
   if (_prodCont.currentLocale.languageCode.toLowerCase() == 'ar') {
     _changeLanguage(const Locale('ar'));
   } else {
     _changeLanguage(const Locale('en'));
   }
 }

  @override
  void initState() {
    super.initState();
    setState(() {
      _prodCont.isPageLoading = true;
    });

    handleAuthenticationAction();
    _scrollController = ScrollController();
    _scrollController.addListener(_scrollListener);
    _prodCont.groupOptions.add(Group(
      partitionKey: '',
      rowKey: '',
      seq: 1,
      name: '-',
      description: '',
      languageID: _prodCont.currentLocale.languageCode,
      imageURL: '',
      active: true,
    ));
    fetchDataGroups();
    _prodCont.filteredSubGroupOptions.add(SubGroup(
      partitionKey: '',
      rowKey: '',
      seq: 1,
      name: '-',
      languageID: _prodCont.currentLocale.languageCode,
      imageURL: '',
      active: true,
      groupRowKey: '',
    ));
    _prodCont.subGroupOptions.add(SubGroup(
      partitionKey: '',
      rowKey: '',
      seq: 1,
      name: '-',
      languageID: _prodCont.currentLocale.languageCode,
      imageURL: '',
      active: true,
      groupRowKey: '',
    ));
    fetchDataSubGroups();
    _prodCont.fetchData(moredata: false).then((_) {
      // Set isPageLoading to false after fetchData completes
      setState(() {
        _prodCont.isPageLoading = false;
      });
    });
  }


  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }


  void _scrollListener() {
    if (!_scrollController.position.atEdge && _scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 500) {
      _prodCont.fetchData(moredata:true);
    }
    // Update the visibility of the scroll button
    setState(() {
      _showScrollButton = _scrollController.position.pixels >= 200;
      _isListViewScrolling = _scrollController.position.pixels <= 150;
      _isListViewScrolling = _scrollController.position.pixels > 150;
    });
  }

  void _changeLanguage(Locale newLocale) {
    setState(() {
      FlutterI18n.refresh(context, newLocale);
      LocalizationManager().setCurrentLocale(newLocale);
    });
  }

  // This function will be called when the product is added to the cart
  void addToCart(Product product) {
    setState(() {
      _isAddingToCart = true; // Set the flag to indicate adding to cart
      _prodCont.productRowKey = product.rowKey;
    });

    // Simulate a delay to show the progress indicator
    Future.delayed(const Duration(seconds: 2), () {
      setState(() {
        var cartItem = ShoppingCart.getItems().where((element) =>
        element.rowKey == _prodCont.productRowKey );
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
        proFound = _prodCont.products.firstWhere((element) => element.rowKey == rowKey);
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
        proFound = _prodCont.products.firstWhere((element) => element.rowKey == rowKey);
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
      var url = '${AppConfig.baseUrl}/api/Groups/LoadAllData?Lan=${_prodCont.currentLocale
          .languageCode.toUpperCase()}';
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        final List<dynamic> jsonList = jsonResponse as List<dynamic>;
        final List<Group> newGroups =
        jsonList.map((json) => Group.fromJson(json)).toList();
        //print(newGroups);
        setState(() {
          _prodCont.groupOptions.clear();
          _prodCont.groupOptions.add(Group(partitionKey: '',
              rowKey: '',
              seq: 1,
              name: '-',
              description: '',
              languageID: _prodCont.currentLocale.languageCode,
              imageURL: '',
              active: true));
          _prodCont. groupOptions.addAll(newGroups);

        });
      }
    } catch (error) {
      print(error);
    }
  }

  Future<void> fetchDataSubGroups() async {
    try {
      var url = '${AppConfig.baseUrl}/api/SubGroups/LoadAllData?Lan=${_prodCont.currentLocale
          .languageCode.toUpperCase()}';
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        final List<dynamic> jsonList = jsonResponse as List<dynamic>;
        final List<SubGroup> newSubGroups =
        jsonList.map((json) => SubGroup.fromJson(json)).toList();
        newSubGroups.sort((a, b) => a.name.compareTo(b.name));

        //print(newSubGroups.);
        setState(() {
          _prodCont.subGroupOptions.clear();
          _prodCont.subGroupOptions.add(SubGroup(partitionKey: '',
              rowKey: '',
              seq: 1,
              name: '-',
              languageID: Localizations
                  .localeOf(context)
                  .languageCode,
              imageURL: '',
              active: true,
              groupRowKey: ''));
          _prodCont.subGroupOptions.addAll(newSubGroups);

          _prodCont.filteredSubGroupOptions.clear();
          _prodCont.filteredSubGroupOptions.add(SubGroup(partitionKey: '',
              rowKey: '',
              seq: 1,
              name: '-',
              languageID: Localizations
                  .localeOf(context)
                  .languageCode,
              imageURL: '',
              active: true,
              groupRowKey: ''));
          _prodCont.filteredSubGroupOptions.addAll(newSubGroups);
         //newSubGroups.forEach((element) {
         //  if(element.groupRowKey=='8c4b1276-0799-403b-8cbf-5a8d02d0fda3') {
         //    print(element.rowKey + "," + element.name + "\n");
         //  }
         //});
        });
      }
    } catch (error) {
      print(error);
    }
  }

  // Create a map of icon names to IconData

  Widget _buildGroups() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(vertical: 1, horizontal: 2),
      child: Row(
        children: _prodCont.groupOptions.map((Group value) {
          return GestureDetector(
            onTap: () {
              setState(() {
                _prodCont.selectedGroup = value.name;
                applyGroupFilter(value.name,value.rowKey);
              });
            },
            child: Container(
              width: 80,
              height: 90,

              margin: const EdgeInsets.symmetric(horizontal: 5),
              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
              decoration: BoxDecoration(
                color: _prodCont.selectedGroup == value.name
                    ? Colors.indigo
                    : Colors.grey[100],
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: _prodCont.selectedGroup == value.name
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
              child: Column(
                children: [
                  Icon(
                    size: 40,
                    Constraint.iconMapping[value.rowKey], // Replace this with the desired icon
                    color: _prodCont.selectedGroup == value.name
                        ? Colors.white
                        : Colors.black,
                  ),
                  const SizedBox(height: 5), // Adjust the spacing between icon and text
                  Text(
                    textAlign: TextAlign.center,
                    value.name.split("&")[0],
                    style: TextStyle(
                      color: _prodCont.selectedGroup == value.name
                          ? Colors.white
                          : Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                      overflow: TextOverflow.visible
                    ),
                  ),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildSubGroups() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(vertical: 1, horizontal: 2),
      child: Row(
        children: _prodCont.filteredSubGroupOptions.map((SubGroup value) {
          return GestureDetector(
            onTap: () {
              setState(() {
                _prodCont.selectedSubGroup = value.name;
                applySubGroupFilter(value.name);
              });
            },
            child: Container(
              width: 75,
              height: 75,
              margin: const EdgeInsets.symmetric(horizontal: 2),
              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
              decoration: BoxDecoration(
                color: _prodCont.selectedSubGroup == value.name
                    ? Colors.indigo
                    : Colors.grey[100],
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: _prodCont.selectedSubGroup == value.name
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
              child: Column(
                children: [
                  Icon(
                    Constraint.subIconMapping[value.rowKey] ?? Icons.error,
                    size: 20,
                    color: _prodCont.selectedSubGroup == value.name
                        ? Colors.white
                        : Colors.black,
                  ),
                  const SizedBox(height: 5),
                  Text(
                    value.name.length>=15? value.name.substring(0,15):value.name,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: _prodCont.selectedSubGroup == value.name
                          ? Colors.white
                          : Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 9,
                      overflow: TextOverflow.visible,
                    ),
                  ),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildSearchBox() {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: TextField(
        controller: _searchController,
        onSubmitted: (value) {
          setState(() {
            _prodCont.searchQuery = value.trim();
            _prodCont.pageSize = 20;
            _prodCont.pageNumber += 1;
            _prodCont.products.clear();
            _prodCont.fetchData(moredata: false);
          });
        },
        onChanged: (value) {
          setState(() {
            // Update the search query as the text changes
            _prodCont.searchQuery = value.trim();
          });
        },
        decoration: InputDecoration(
          hintText: FlutterI18n.translate(context, "Search"),
          prefixIcon: const Icon(Icons.search, color: Colors.grey), // Change the prefix icon color if needed
          suffixIcon: _searchController.text.isNotEmpty
              ? IconButton(
            icon: const Icon(Icons.clear),
            onPressed: _clearSearch,
            color: Colors.grey, // Change the clear icon color if needed
          )
              : null,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
            borderSide: const BorderSide(color: Colors.white),
          ),
          filled: true, // Change to true to have a filled background
          fillColor: Colors.grey[200], // Change the background color if needed
          contentPadding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0), // Adjust content padding
        ),
        style: const TextStyle(fontSize: 16.0, color: Colors.black), // Change text color and size if needed
      ),
    );
  }

  void applyGroupFilter(String group, String rowKey) {
    setState(() {
      _prodCont.selectedGroup = group;
      _prodCont.selectedSubGroup = '-';
      _prodCont.filteredSubGroupOptions = group == '-' ? _prodCont.subGroupOptions :
      _prodCont.subGroupOptions.where((element) => element.groupRowKey == rowKey)
          .toList();
      _prodCont.fetchData(moredata: false);
    });
  }

  void applySubGroupFilter(String subGroup) {
    setState(() {
      _prodCont.selectedSubGroup = subGroup;
      _prodCont.fetchData(moredata: false);
    });
  }

  // Add this method to your _ProductListState class
  Widget _buildListItem(BuildContext context, int index) {
    if (index == _prodCont.products.length) {
      if (_prodCont.isLoading) {
        return (_prodCont.pageNumber == 1) ? ProgressCustom(
          strokeWidth: 4.0, // Custom stroke width
          size: 600.0, // Custom size
        ) : ProgressCustom();
      }
      if (_prodCont.searchQuery != "" && _prodCont.products.isEmpty) {
        return ListNoResultFound(onClear: _clearSearch,);
      }
      return const SizedBox();
    }
    else {
      final product = _prodCont.products[index];

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
        rowKey: _prodCont.productRowKey,
        increaseQuantity: _increaseQuantity,
        decreaseQuantity: _decreaseQuantity,
        layoutNumber: _prodCont.layoutNumber,
      );
    }
  }

  void _clearSearch() {
    setState(() {
      _searchController.clear();
      _prodCont.searchQuery = ''; // Clear the searchQuery variable
      // Add other necessary operations related to clearing the search here
      _prodCont.pageSize = 20;
      _prodCont.pageNumber += 1;
      _prodCont.products.clear();
      _prodCont.fetchData(moredata: false);
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

    _prefs = await SharedPreferences.getInstance();
    _prodCont. RowKey = _prefs.getString('RowKey');

    if ( _prodCont.RowKey == null) {
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
            context, MaterialPageRoute(builder: (context) => const SettingsPage()));
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
    _prodCont.currentLocale.languageCode.toLowerCase() == 'ar'
        ? TextDirection.rtl
        : TextDirection.ltr;


    return Directionality(
      textDirection: textDirection,

      child: Scaffold(

        appBar: AppBar(

          title: Text(FlutterI18n.translate(context, "ProductList")),
          actions: [

            CartShopIcon(),
            IconButton(onPressed: () {
              setState(() {
                _prodCont.layoutNumber = ( _prodCont.layoutNumber == 2 ? 1 : 2);
              });
            },
                icon: Icon(
                    _prodCont.layoutNumber == 2 ? Icons.view_list : Icons.list_alt)),
                     !isAuthenticated ?
                     IconButton(
                onPressed: handleAuthenticationAction,
                icon: const Icon(Icons.error),
                color: Colors.deepOrange
            ) : Container(),
          ],
        ),
        body:  _prodCont.isPageLoading
            ? const Center(
          child: CircularProgressIndicator(), // Display a loading indicator
        )
            : Column(
          children: [
            // Conditionally display widgets based on scrolling state
            if (!_isListViewScrolling) _buildSearchBox(),
            if (!_isListViewScrolling) _buildGroups(),
            if (!_isListViewScrolling) const SizedBox(height: 10),
            if (!_isListViewScrolling) _buildSubGroups(),
            Expanded(
              child:  _prodCont.hasError ? ErrorScreen(errorMessage:  _prodCont.errorMessage,
                onRetry: () {
                  setState(() {
                    _prodCont.hasError = false;
                    _prodCont.errorMessage = '';
                    _prodCont.products.clear();
                    _prodCont.fetchData(moredata: false);
                  });
                },
              ) : RefreshIndicator(
                onRefresh: () async {
                  await  _prodCont.fetchData(moredata: false); // Example: Fetching data
                  await Future.delayed(const Duration(milliseconds: 500)); // Adjust duration as needed
                },
                child: ListView.builder(

                  shrinkWrap: true,
                  controller: _scrollController,

                  itemCount:  _prodCont.products.length + 1,
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
