import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shopping/Account/LoginPage.dart';
import 'package:http/http.dart' as http;
import 'package:shopping/Account/SettingsPage.dart';
import 'package:shopping/Shop/Models/Group.dart';
import 'package:shopping/Shop/Models/Store.dart';
import 'package:shopping/Shop/Models/SubGroup.dart';
import 'package:shopping/GlobalTools/bottomNavigationBar.dart';
import 'package:shopping/Shop/Products/ProductList.dart';
import 'package:shopping/Shop/Stores/StoreProductList.dart';
import 'package:shopping/Shop/Stores/_StoreCard.dart';
import 'package:shopping/Shop/Stores/StoreDetails.dart';
import '../../Account/Profile.dart';
import '../../GlobalTools/AppConfig.dart';
import '../../GlobalTools/ErrorScreen.dart';
import '../../GlobalTools/LocalizationManager.dart';
import '../Groups/FilterOption.dart';
import '../../GlobalTools/ListNoResultFound.dart';
import '../../GlobalTools/ProgressCustome.dart';
import '../Cart/_CartShopIcon.dart';
import '../Models/Constraint.dart';






class StoreList extends StatefulWidget {

  @override
  // ignore: library_private_types_in_public_api
  _StoreListState createState() =>
      _StoreListState();
}

class _StoreListState extends State<StoreList> {

  Locale currentLocale = LocalizationManager().getCurrentLocale();

  int pageSize = 20;
  int pageNumber = 1;
  int layoutNumber=2;


  bool isLoading = false;
  bool isPageLoading = false;
  bool isResultFound = false;
  bool hasError = false;
  bool _showScrollButton = false; // Add this variable
  bool _isAddingToCart = false;

  String searchQuery = '';
  String errorMessage = '';
  late String _storeRowKey = '';
  String? RowKey ='';
  String selectedGroup='-'; // No default selected group // Default selected group filter



  static List<Store> stores = [];
  List<Store> filteredStores = [];
  static List<Group> groupOptions=[] ; // List of grouping options



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
    groupOptions.add(Group(
      partitionKey: '',
      rowKey: '',
      seq: 1,
      name: '-',
      description: '',
      languageID: currentLocale.languageCode,
      imageURL: '',
      active: true,
    ));
    fetchDataGroups();

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
        isLoading= true;

        hasError = false;
        errorMessage = '';
      });
      try {
        stores.clear();
        var groupRowKey = groupOptions.firstWhere((element) => element.name==selectedGroup).rowKey;
        var url =
            '${AppConfig.baseUrl}/api/Stores/LoadPartialData?pageSize=$pageSize&pageNumber=$pageNumber&Lan=${currentLocale.languageCode.toUpperCase()}&groupOptions=$groupRowKey';
        if (searchQuery != "") {
          url =
          '${AppConfig.baseUrl}/api/Stores/LoadPartialDataWithSearch?pageSize=$pageSize&pageNumber=$pageNumber&searchQuery=$searchQuery&Lan=${currentLocale.languageCode.toUpperCase()}&groupOptions=$groupRowKey';
        }
        final response = await http.get(Uri.parse(url));

        if (response.statusCode == 200) {
          final jsonResponse = json.decode(response.body);
          final List<dynamic> jsonList = jsonResponse as List<dynamic>;
          final List<Store> newStores =
          jsonList.map((json) => Store.fromJson(json)).toList();
          setState(() {
            stores.addAll(newStores);
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
        var url =
            '${AppConfig.baseUrl}/api/Stores/LoadPartialData?pageSize=$pageSize&pageNumber=$pageNumber&Lan=${currentLocale.languageCode.toUpperCase()}&groupOptions=$groupRowKey';
        if (searchQuery != "") {
          url =
          '${AppConfig.baseUrl}/api/Stores/LoadPartialDataWithSearch?pageSize=$pageSize&pageNumber=$pageNumber&searchQuery=$searchQuery&Lan=${currentLocale.languageCode.toUpperCase()}&groupOptions=$groupRowKey';
        }
        final response = await http.get(Uri.parse(url));

        if (response.statusCode == 200) {
          final jsonResponse = json.decode(response.body);
          final List<dynamic> jsonList = jsonResponse as List<dynamic>;
          final List<Store> newStores =
          jsonList.map((json) => Store.fromJson(json)).toList();
          setState(() {
            stores.addAll(newStores);
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
      fetchDataGroups();
      fetchData();

    });
  }
  // This function will be called when the store is added to the cart


  void _showMessage(String message, Color messageColor) {
    final snackBar = SnackBar(
      content: Text(message),
      backgroundColor: messageColor,
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }



  Future<void> fetchDataGroups() async {

    try {
      var url = '${AppConfig.baseUrl}/api/Groups/LoadAllData?Lan=${currentLocale.languageCode.toUpperCase()}';
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
  Widget _buildGroups() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(vertical: 1, horizontal: 2),
      child: Row(
        children: groupOptions.map((Group value) {
          return GestureDetector(
            onTap: () {
              setState(() {
                selectedGroup = value.name;
                applyGroupFilter(value.name);
              });
            },
            child: Container(
              width: 80,
              height: 90,

              margin: const EdgeInsets.symmetric(horizontal: 5),
              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
              decoration: BoxDecoration(
                color: selectedGroup == value.name
                    ? Colors.indigo
                    : Colors.grey[100],
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: selectedGroup == value.name
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
                    color: selectedGroup == value.name
                        ? Colors.white
                        : Colors.black,
                  ),
                  SizedBox(height: 5), // Adjust the spacing between icon and text
                  Text(
                    textAlign: TextAlign.center,
                    value.name.split("&")[0],
                    style: TextStyle(
                        color: selectedGroup == value.name
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



  void applyGroupFilter(String group) {
    setState(() {
      selectedGroup=group;
      fetchData();
    });
  }


  // Add this method to your _StoreListState class
  Widget _buildListItem(BuildContext context, int index) {
    if (index == stores.length) {
      if (isLoading) {
        return (pageNumber==1)? ProgressCustom(
          strokeWidth: 4.0, // Custom stroke width
          size: 600.0, // Custom size
        ): ProgressCustom();

      }
      if(searchQuery!=""&&stores.isEmpty){
        return  ListNoResultFound( onClear: _clearSearch,);
      }
      return const SizedBox();
    }
    else {
      final store = stores[index];

      return StoreCard(
        store: store,
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => StoreProductList(store: store),
            ),
          );
        },

        //showProgressIndicator: _isAddingToCart,
        //rowKey: _storeRowKey,

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
      stores.clear();
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
    RowKey = prefs.getString('RowKey');

    if(RowKey==null) {
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
    }else{
      setState(() {
        isAuthenticated=true;
      });
    }
  }
  int _selectedIndex = 1;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    switch (index) {
      //StoreLIst
      case 0:
        Navigator.push(context,MaterialPageRoute(builder:(context) => ProductList()));
        break;
      case 1:
      // Navigate to the settings page or perform settings-related actions
        //Navigator.push(context,MaterialPageRoute(builder:(context) => Profile()));
        break;
      case 2:
      // Navigate to the settings page or perform settings-related actions
        Navigator.push(context,MaterialPageRoute(builder:(context) => SettingsPage()));
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
    currentLocale.languageCode.toLowerCase() == 'ar' ? TextDirection.rtl : TextDirection.ltr;


    return Directionality(
      textDirection: textDirection,

      child: Scaffold(

        appBar: AppBar(

          title:  Text(FlutterI18n.translate(context, "Shops")  ),
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
            ):Container(),
          ],
        ),
        body:  isPageLoading
            ? Center(child: CircularProgressIndicator())
            : Column(
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
                    stores.clear();
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
            _buildGroups(),
            Expanded(
              child: hasError ? ErrorScreen(errorMessage: errorMessage,
                onRetry: () {
                  setState(() {
                    hasError = false;
                    errorMessage = '';
                    stores.clear();
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
                  itemCount: stores.length + 1,
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
