import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shopping/Account/LoginPage.dart';
import 'package:shopping/Account/SettingsPage.dart';
import 'package:shopping/Shop/Controller/ProductControllar.dart';
import 'package:shopping/Shop/View/Cart/CartList.dart';
import 'package:shopping/Shop/Models/Group.dart';
import 'package:shopping/Shop/Models/Product.dart';
import 'package:shopping/Shop/Models/SubGroup.dart';
import 'package:shopping/Shop/View/Products/Body/_ProductCard.dart';
import 'package:shopping/Shop/View/Products/Body/ProductDetails.dart';
import 'package:shopping/Shop/View/Stores/StoreList.dart';
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
  final ProductController  _prodCont= ProductController();
  final TextEditingController _searchController = TextEditingController();
  ScrollController _scrollController = ScrollController();
  bool _showScrollButton = false;

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
    _prodCont.fetchDataGroups();
    _prodCont.fetchDataSubGroups();
    _prodCont.fetchData(moreData: false).then((_) {
      // Set isPageLoading to false after fetchData completes
      setState(() {
        _prodCont.isPageLoading = false;
      });
    });
  }
  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.removeListener(_scrollListener);
    _scrollController.dispose();
    super.dispose();
  }
  void _scrollListener() {
    if (_scrollController.position.atEdge) {
      final isBottom = _scrollController.position.pixels != 0;
      if (isBottom && !_prodCont.isFetching) {
        _prodCont.fetchData(moreData: true).then((value) =>
            setState(()=> _prodCont.isFetching = false )
        );
      }
    }
    bool shouldShowButton = _scrollController.position.pixels > 150;
    if (_showScrollButton != shouldShowButton) {
      setState(() => _showScrollButton = shouldShowButton);
    }
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
      _prodCont.isAddingToCart = true; // Set the flag to indicate adding to cart
      _prodCont.productRowKey = product.rowKey;
    });

    // Simulate a delay to show the progress indicator
    Future.delayed(const Duration(seconds: 2), () {
      setState(() {
        var cartItem = ShoppingCart.getItems().where((element) =>
        element.rowKey == _prodCont.productRowKey );
        if (cartItem.isEmpty) {
          ShoppingCart.addProduct(product);
          _prodCont.isAddingToCart = false; // Reset the flag after adding to cart
          // Show a snackbar message
          _showMessage(
            "${product.name} added to the cart",
            Colors.lightGreen,
          );
        } else {
          _prodCont.isAddingToCart = false;
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






  // Create a map of icon names to IconData

  Widget _buildGroups() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
      child: Row(
        children: _prodCont.groupOptions.map((Group value) {
          bool isSelected = _prodCont.selectedGroup == value.name;
          return GestureDetector(
            onTap: () {
              setState(() {
                _prodCont.selectedGroup = value.name;
                applyGroupFilter(value.name, value.rowKey);
              });
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              width: 80,
              height: 90,
              margin: const EdgeInsets.symmetric(horizontal: 5),
              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
              decoration: BoxDecoration(
                color: isSelected ? Colors.indigo : Colors.grey[100],
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: isSelected ? Colors.blue : Colors.grey[300]!,
                  width: 2,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: isSelected ? 6 : 3,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    // Assuming Constraint.iconMapping is a Map that maps group keys to Icons.
                    Constraint.iconMapping[value.rowKey] ?? Icons.group, // Fallback icon
                    size: 40,
                    color: isSelected ? Colors.white : Colors.black,
                  ),
                  const SizedBox(height: 5),
                  Text(
                    value.name.split("&")[0],
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: isSelected ? Colors.white : Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
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
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
      child: Row(
        children: _prodCont.filteredSubGroupOptions.map((SubGroup value) {
          bool isSelected = _prodCont.selectedSubGroup == value.name;
          return GestureDetector(
            onTap: () {
              setState(() {
                _prodCont.selectedSubGroup = value.name;
                applySubGroupFilter(value.name);
              });
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              width: 75,
              height: 75,
              margin: const EdgeInsets.symmetric(horizontal: 5),
              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
              decoration: BoxDecoration(
                color: isSelected ? Colors.indigo : Colors.grey[100],
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: isSelected ? Colors.blue : Colors.grey[300]!,
                  width: 2,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: isSelected ? 6 : 3,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Constraint.subIconMapping[value.rowKey] ?? Icons.error, // Provide a default icon
                    size: 20,
                    color: isSelected ? Colors.white : Colors.black,
                  ),
                  const SizedBox(height: 5),
                  Text(
                    value.name.length >= 15 ? value.name.substring(0, 15) : value.name,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: isSelected ? Colors.white : Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 9,
                      overflow: TextOverflow.ellipsis, // Handle long names gracefully
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
            _prodCont.fetchData(moreData: false).then((_) {
              // Set isPageLoading to false after fetchData completes
              setState(() {
                _prodCont.isPageLoading = false;
              });
            });
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
      _prodCont.fetchData(moreData: false).then((_) {
        // Set isPageLoading to false after fetchData completes
        setState(() {
          _prodCont.isPageLoading = false;
        });
      });
    });
  }
  void applySubGroupFilter(String subGroup) {
    setState(() {
      _prodCont.selectedSubGroup = subGroup;
      _prodCont.fetchData(moreData: false).then((_) {
        // Set isPageLoading to false after fetchData completes
        setState(() {
          _prodCont.isPageLoading = false;
        });
      });;
    });
  }

  // Add this method to your _ProductListState class
  Widget _buildProductList() {
    return _prodCont.hasError
        ? SliverFillRemaining(
      child: Center(
        child: Text(_prodCont.errorMessage), // Display error message
      ),
    )
        : SliverList(
      delegate: SliverChildBuilderDelegate(
            (context, index) {
          // Replace the placeholder logic with the actual item building logic
          if (index == _prodCont.products.length) {
            if (!_prodCont.isFetching) {
              // Check if it's the first page and loading is not in progress to show the custom progress indicator
              return  ProgressCustom(); // Show the progress indicator for subsequent pages
            }
            if (_prodCont.searchQuery != "" && _prodCont.products.isEmpty) {
              // Show a 'no results found' widget if the search query is not empty but no products are found
              return ListNoResultFound(onClear: _clearSearch,);
            }
            // Return an empty box if there are no more items to load and it's not an error state
            return const SizedBox();
          } else {
            // Build each product card
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
              showProgressIndicator: _prodCont.isAddingToCart,
              rowKey: _prodCont.productRowKey,
              increaseQuantity: _increaseQuantity,
              decreaseQuantity: _decreaseQuantity,
              layoutNumber: _prodCont.layoutNumber,
            );
          }
        },
        childCount: _prodCont.products.length + 1, // Add one more for the loading or 'no more items' widget
      ),
    );
  }


  void _clearSearch() {
    setState(() {
      _searchController.clear();
      _prodCont.searchQuery = ''; // Clear the searchQuery variable
      // Add other necessary operations related to clearing the search here
      _prodCont.pageSize = 20;
      _prodCont.pageNumber += 1;
      _prodCont.isFetching=true;
      _prodCont.products.clear();
      _prodCont.fetchData(moreData: false).then((_) {
        // Set isPageLoading to false after fetchData completes
        setState(() {
          _prodCont.isPageLoading = false;
        });
      });
    });
  }

  bool isAuthenticated = false; // Assuming this flag manages user authentication status

  // Function to handle the action when the user is not authenticated
  Future<void> handleAuthenticationAction() async {
    _prefs = await SharedPreferences.getInstance();
    _prodCont.rowKey = _prefs.getString('RowKey');
    if ( _prodCont.rowKey == null) {
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

  bool isExpanded = false;  // Tracks whether the expansion tile is expanded
  double appBarHeight = 120;  // Default height of the SliverAppBar
  void _toggleExpansion() {
    setState(() {
      isExpanded = !isExpanded;
      appBarHeight = isExpanded ? 350 : 120;  // Adjust these values as needed
    });
  }
  Widget _buildFlexibleSpaceContent(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        return SingleChildScrollView(
          physics: const NeverScrollableScrollPhysics(),
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: constraints.maxHeight),
            child: Column(
              children: <Widget>[
                _buildSearchBox(),
                ExpansionTile(
                  title: Text(FlutterI18n.translate(context, "Filters"), style: TextStyle(color: Colors.white)),
                  backgroundColor: Colors.white12,
                  initiallyExpanded: isExpanded,
                  onExpansionChanged: (bool expanded) {
                    _toggleExpansion();  // Update the expansion state and the app bar height
                  },
                  children: [
                    _buildGroups(),
                    const SizedBox(height: 1),
                    _buildSubGroups()
                  ],
                )
              ],
            ),
          ),
        );
      },
    );
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
                _prodCont.layoutNumber = (_prodCont.layoutNumber == 2 ? 1 : 2);
              });
            },
                icon: Icon(_prodCont.layoutNumber == 2 ? Icons.view_list : Icons.list_alt)), !isAuthenticated ? IconButton(onPressed: handleAuthenticationAction, icon: const Icon(Icons.error), color: Colors.deepOrange) : Container(),
          ],
        ),
        body: _prodCont.isPageLoading
            ? const Center(child: CircularProgressIndicator())
            : CustomScrollView(
          controller: _scrollController,
          slivers: <Widget>[
            SliverAppBar(
              backgroundColor: Colors.transparent,  // Make the background transparent
              floating: true,
              expandedHeight: appBarHeight,
              flexibleSpace: FlexibleSpaceBar(
                collapseMode: CollapseMode.parallax,
                background: Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [Colors.black38, Colors.transparent],
                    ),
                  ),
                  child: _buildFlexibleSpaceContent(context),
                ),
              ),
            ),


            _buildProductList(),
          ],
        ),

        bottomNavigationBar: ProfileBottomNavigationBar(
          currentIndex: _selectedIndex,
          onItemTapped: _onItemTapped,
        ),

        floatingActionButton: Visibility(
          visible: _prodCont.showScrollButton,
          child: FloatingActionButton(

            onPressed: () {
              // Scroll to the top of the list using the ScrollController
              _scrollController.animateTo(
                0.0,
                duration: const Duration(milliseconds: 1000),
                curve: Curves.easeInOut,
              );
              setState(() {
                //_prodCont.showScrollButton=false;
              });
            },
            child: const Icon(Icons.arrow_upward),
          ),
        ),

      ),
    );
  }
}
