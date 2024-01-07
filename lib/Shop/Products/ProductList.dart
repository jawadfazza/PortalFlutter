import 'dart:convert';
import 'dart:ffi';
import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shopping/Account/LoginPage.dart';
import 'package:shopping/Account/Profile.dart';
import 'package:shopping/Account/SettingsPage.dart';
import 'package:shopping/Shop/Cart/CartList.dart';
import 'package:http/http.dart' as http;
import 'package:shopping/Shop/Models/Group.dart';
import 'package:shopping/Shop/Models/Product.dart';
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





class ProductList extends StatefulWidget {

  @override
  // ignore: library_private_types_in_public_api
  _ProductListState createState() =>
      _ProductListState();
}

class _ProductListState extends State<ProductList> {
  late SharedPreferences _prefs;
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
  bool _isListViewScrolling = false; // Flag to track ListView scrolling state


  String searchQuery = '';
  String errorMessage = '';
  late String _productRowKey = '';
  String? RowKey = '';
  String selectedGroup = '-'; // No default selected group // Default selected group filter
  String selectedSubGroup = '-'; // No default selected group // Default selected group filter


  static List<Product> products = [];
  List<Product> filteredProducts = [];
  static List<Group> groupOptions = []; // List of grouping options
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
      DateTime startTime = DateTime.now(); // Record the start time
      try {

        products.clear();
        var groupRowKey = groupOptions
            .firstWhere((element) => element.name == selectedGroup)
            .rowKey;
        var subGroupRowKey = subGroupOptions
            .firstWhere((element) => element.name == selectedSubGroup)
            .rowKey;
        var url =
            '${AppConfig.baseUrl}/api/Products/LoadPartialData?pageSize=$pageSize&pageNumber=$pageNumber&Lan=${currentLocale
            .languageCode.toUpperCase()}&groupOptions=$groupRowKey&subGroupOptions=$subGroupRowKey';
        if (searchQuery != "") {
          url =
          '${AppConfig.baseUrl}/api/Products/LoadPartialDataWithSearch?pageSize=$pageSize&pageNumber=$pageNumber&searchQuery=$searchQuery&Lan=${currentLocale
              .languageCode.toUpperCase()}&groupOptions=$groupRowKey&subGroupOptions=$subGroupRowKey';
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
        // Calculate the duration (response time) in milliseconds
        DateTime endTime = DateTime.now(); // Record the end time
        int responseTimeInMillis = endTime.difference(startTime).inMilliseconds;
        print('Response time: $responseTimeInMillis ms');
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

      //await Future.delayed(const Duration(seconds: 2));
      DateTime startTime = DateTime.now(); // Record the start time

      try {
        var groupRowKey = groupOptions
            .firstWhere((element) => element.name == selectedGroup)
            .rowKey;
        var subGroupRowKey = subGroupOptions
            .firstWhere((element) => element.name == selectedSubGroup)
            .rowKey;
        var url =
            '${AppConfig.baseUrl}/api/Products/LoadPartialData?pageSize=$pageSize&pageNumber=$pageNumber&Lan=${currentLocale
            .languageCode.toUpperCase()}&groupOptions=$groupRowKey&subGroupOptions=$subGroupRowKey';
        if (searchQuery != "") {
          url =
          '${AppConfig.baseUrl}/api/Products/LoadPartialDataWithSearch?pageSize=$pageSize&pageNumber=$pageNumber&searchQuery=$searchQuery&Lan=${currentLocale
              .languageCode.toUpperCase()}&groupOptions=$groupRowKey&subGroupOptions=$subGroupRowKey';
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
        // Calculate the duration (response time) in milliseconds
        DateTime endTime = DateTime.now(); // Record the end time
        int responseTimeInMillis = endTime.difference(startTime).inMilliseconds;
        print('Response time: $responseTimeInMillis ms');
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
      _isListViewScrolling = _scrollController.position.pixels <= 150;
      _isListViewScrolling = _scrollController.position.pixels > 150;
    });
  }

  void _changeLanguage(Locale newLocale) {
    setState(() {
      FlutterI18n.refresh(context, newLocale);
      LocalizationManager().setCurrentLocale(newLocale);
      fetchDataGroups();
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



  Future<void> fetchDataGroups() async {
    try {
      var url = '${AppConfig.baseUrl}/api/Groups/LoadAllData?Lan=${currentLocale
          .languageCode.toUpperCase()}';
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        final List<dynamic> jsonList = jsonResponse as List<dynamic>;
        final List<Group> newGroups =
        jsonList.map((json) => Group.fromJson(json)).toList();
        //print(newGroups);
        setState(() {
          groupOptions.clear();
          groupOptions.add(Group(partitionKey: '',
              rowKey: '',
              seq: 1,
              name: '-',
              description: '',
              languageID: currentLocale.languageCode,
              imageURL: '',
              active: true));
          groupOptions.addAll(newGroups);

        });
      }
    } catch (error) {
      print(error);
    }
  }

  Future<void> fetchDataSubGroups() async {
    try {
      var url = '${AppConfig.baseUrl}/api/SubGroups/LoadAllData?Lan=${currentLocale
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
          subGroupOptions.addAll(newSubGroups);

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
          filteredSubGroupOptions.addAll(newSubGroups);

          newSubGroups.forEach((element) {
            print(element.name +"\n");
          });
        });
      }
    } catch (error) {
      print(error);
    }
  }

  // Create a map of icon names to IconData
  final Map<String, IconData> iconMapping = {
    'Electronics': Icons.phone_android,
    'Clothing': Icons.accessibility,
    'Books': Icons.menu_book,
    'Appliances': Icons.kitchen,
    'Sports & Outdoors': Icons.sports_soccer,
    'Beauty & Personal Care': Icons.face,
    'Furniture': Icons.weekend,
    'Toys & Games': Icons.toys,
    'Food & Beverages': Icons.fastfood,
    'Health & Wellness': Icons.favorite,
    'Automotive': Icons.directions_car,
    'Office': Icons.work,
    'Home Decor': Icons.home,
    'Garden & Outdoor': Icons.eco,
    'Jewelry & Accessories': Icons.shopping_bag,
    'Baby & Kids': Icons.child_friendly,
    'Travel & Luggage': Icons.card_travel,
    'Fitness & Exercise': Icons.fitness_center,
  };

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
                applyGroupFilter(value.name,value.rowKey);
              });
            },
            child: Container(
              width: 100,
              height: 120,

              margin: const EdgeInsets.symmetric(horizontal: 5),
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 25),
              decoration: BoxDecoration(
                color: selectedGroup == value.name
                    ? Colors.indigo
                    : Colors.grey[200],
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: selectedGroup == value.name
                      ? Colors.deepPurpleAccent
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
                    iconMapping[value.name], // Replace this with the desired icon
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


  Map<String, IconData> subIconMapping = {
    'ATV Accessories': Icons.directions_bike,
    'ATV Parts': Icons.directions_bike,
    'Accent Furniture': Icons.weekend,
    'Accessories': Icons.shopping_bag,
    'Action Figures': Icons.extension,
    'Activewear': Icons.directions_run,
    'Adult Clothing': Icons.accessibility,
    'Air Conditioners': Icons.ac_unit,
    'Anklets': Icons.accessibility_new,
    'Art Supplies': Icons.palette,
    'Arts and Crafts': Icons.color_lens,
    'Athletic Accessories': Icons.fitness_center,
    'Audio Devices': Icons.audiotrack,
    'Automotive Exterior': Icons.directions_car,
    'Automotive Interior': Icons.directions_car_filled,
    'Baby Bath and Skincare': Icons.bathtub,
    'Baby Bedding': Icons.child_friendly,
    'Baby Books and Gifts': Icons.book,
    'Baby Clothing': Icons.child_care,
    'Baby Feeding': Icons.free_breakfast,
    'Baby Food': Icons.fastfood,
    'Baby Gear': Icons.stroller,
    'Baby Health and Safety': Icons.medical_services,
    'Baby Room Decor': Icons.weekend,
    'Baby Toys': Icons.toys,
    'Baby Travel Gear': Icons.airplanemode_active,
    'Backpacks': Icons.backpack,
    'Baking Ingredients': Icons.food_bank,
    'Bath and Body': Icons.bathtub,
    'Bathroom Furniture': Icons.bathtub,
    'Beauty Accessories': Icons.favorite,
    'Bedroom Furniture': Icons.king_bed,
    'Belts': Icons.accessibility,
    'Beverages': Icons.local_drink,
    'Bicycles': Icons.directions_bike,
    'Binders and Notebooks': Icons.bookmark,
    'Blenders': Icons.kitchen,
    'Board Games': Icons.games,
    'Boat Accessories': Icons.directions_boat,
    'Boat Parts': Icons.directions_boat_filled,
    'Bohemian Style': Icons.filter_vintage,
    'Bottoms': Icons.accessibility,
    'Bracelets': Icons.watch,
    'Brooches': Icons.category,
    'Building Blocks': Icons.extension,
    'Calculators': Icons.calculate,
    'Calendars and Planners': Icons.today,
    'Cameras': Icons.photo_camera,
    'Camping Gear': Icons.campaign,
    'Camping Gear': Icons.campaign,
    'Candles and Candle Holders': Icons.lightbulb_outline,
    'Canned Foods': Icons.food_bank,
    'Car Accessories': Icons.directions_car,
    'Car Care Products': Icons.car_repair,
    'Car Parts': Icons.car_repair,
    'Cardio Equipment': Icons.directions_run,
    'Casual Wear': Icons.accessibility,
    'Chef\'s Uniforms': Icons.restaurant,
    'Children\'s Clothing': Icons.child_friendly,
    'Classic Style': Icons.style,
    'Clocks': Icons.access_time,
    'Coffee Makers': Icons.local_cafe,
    'Computers': Icons.computer,
    'Construction Workwear': Icons.build,
    'Cooking Oils': Icons.local_dining,
    'Cotton Clothing': Icons.wb_sunny,
    'Curtains and Window Treatments': Icons.window,
    'Dairy Products': Icons.local_dining,
    'Decorative Accents': Icons.home,
    'Denim Clothing': Icons.shopping_basket,
    'Desk Accessories': Icons.desktop_windows,
    'Desktops': Icons.desktop_windows,
    'Diapers and Wipes': Icons.child_care,
    'Dining Room Furniture': Icons.dining,
    'Dishwashers': Icons.dining_sharp,
    'Dolls': Icons.toys,
    'Dresses': Icons.question_mark,
    'Earrings': Icons.adb,
    'Educational Toys': Icons.school,
    'Electronic Toys': Icons.gamepad,
    'Entryway Furniture': Icons.door_back_door,
    'Envelopes and Mailers': Icons.mail,
    'Exercise Accessories': Icons.directions_run,
    'Exercise Clothing': Icons.directions_run,
    'Exercise Mats and Flooring': Icons.fitness_center,
    'Fall/Winter Clothing': Icons.sports_outlined,
    'Fencing and Edging': Icons.fence,
    'Filing and Organization': Icons.folder,
    'First Aid': Icons.medical_services,
    'Fitness Accessories': Icons.fitness_center,
    'Fitness Books and Guides': Icons.menu_book,
    'Fitness Equipment': Icons.fitness_center,
    'Fitness Recovery': Icons.local_hospital,
    'Fitness Supplements': Icons.healing,
    'Fitness Technology': Icons.fitness_center,
    'Fitness Trackers': Icons.fitness_center,
    'Food Processors': Icons.food_bank,
    'Formal Wear': Icons.accessibility,
    'Formalwear': Icons.accessibility,
    'Fragrances': Icons.local_florist,
    'Frozen Foods': Icons.icecream,
    'Furniture Accessories': Icons.weekend,
    'Gaming Consoles': Icons.games,
    'Garden Accessories': Icons.nature_people,
    'Gardening Tools': Icons.agriculture,
    'Gloves and Mittens': Icons.handyman,
    'Golf Equipment': Icons.sports_golf,
    'Grains and Pasta': Icons.food_bank,
    'Grills and Outdoor Cooking': Icons.local_dining,
    'Hair Accessories': Icons.content_cut,
    'Hair Care': Icons.content_cut,
    'Hats and Caps': Icons.accessibility,
    'Health Books': Icons.book,
    'Health Foods': Icons.local_dining,
    'Health Monitors': Icons.favorite_border,
    'Hiking Equipment': Icons.explore,
    'Holiday Decor': Icons.card_giftcard,
    'Home Appliances': Icons.home,
    'Home Entertainment Furniture': Icons.tv,
    'Home Fragrances': Icons.home,
    'Home Gym Equipment': Icons.fitness_center,
    'Home Theater Systems': Icons.home,
    'Hunting and Fishing Gear': Icons.outdoor_grill,
    'Hygiene Products': Icons.sanitizer,
    'Indoor Plants and Planters': Icons.eco,
    'Ironing Appliances': Icons.iron,
    'Juicers': Icons.kitchen,
    'Kids\' Accessories': Icons.child_friendly,
    'Kids\' Bedding': Icons.child_friendly,
    'Kids\' Clothing': Icons.child_friendly,
    'Kids\' Furniture': Icons.child_friendly,
    'Kids\' Shoes': Icons.child_friendly,
    'Kids\' Toys': Icons.child_friendly,
    'Kitchen Furniture': Icons.kitchen,
    'Labels and Labeling': Icons.label,
    'Landscaping Supplies': Icons.landscape,
    'Laptops': Icons.laptop,
    'Laptops': Icons.laptop,
    'Lawn Care': Icons.landscape,
    'Leather Clothing': Icons.shopping_bag,
    'Living Room Furniture': Icons.weekend,
    'Loungewear': Icons.nightlife,
    'Luggage': Icons.luggage,
    'Luggage Tags': Icons.luggage,
    'Makeup': Icons.face,
    'Marine Electronics': Icons.laptop,
    'Maternity Clothing': Icons.pregnant_woman,
    'Maternity Clothing': Icons.pregnant_woman,
    'Medical Scrubs': Icons.medical_services,
    'Medical Supplies': Icons.medical_services,
    'Men\'s Clothing': Icons.male,
    'Men\'s Grooming': Icons.male,
    'Mental Health': Icons.psychology,
    'Microwaves': Icons.kitchen,
    'Military Uniforms': Icons.military_tech,
    'Minimalist Style': Icons.accessibility,
    'Mirrors': Icons.fullscreen,
    'Motorcycle Accessories': Icons.motorcycle,
    'Motorcycle Parts': Icons.motorcycle,
    'Natural and Herbal Remedies': Icons.healing,
    'Necklaces': Icons.accessibility,
    'Networking Devices': Icons.router,
    'Networking Devices': Icons.router,
    'Nursery Furniture': Icons.child_friendly,
    'Nutrition': Icons.dining,
    'Office Electronics': Icons.print,
    'Office Furniture': Icons.work,
    'Office Furniture': Icons.work,
    'Oral Care': Icons.local_hospital,
    'Oral Care': Icons.local_hospital,
    'Outdoor Clothing': Icons.directions_walk,
    'Outdoor Decor': Icons.eco,
    'Outdoor Furniture': Icons.deck,
    'Outdoor Furniture': Icons.deck,
    'Outdoor Lighting': Icons.lightbulb_outline,
    'Outdoor Play Equipment': Icons.sports_soccer,
    'Outdoor Power Equipment': Icons.build,
    'Outdoor Recreation': Icons.directions_bike,
    'Outerwear': Icons.question_mark,
    'Ovens': Icons.settings_applications,
    'Paper Products': Icons.local_printshop,
    'Party Supplies': Icons.cake,
    'Passport Holders': Icons.flight,
    'Patio and Decking': Icons.deck,
    'Personal Care': Icons.self_improvement,
    'Personal Care Appliances': Icons.self_improvement,
    'Pest Control': Icons.bug_report,
    'Photo Frames': Icons.photo,
    'Pillows and Cushions': Icons.airline_seat_legroom_extra,
    'Plants and Seeds': Icons.eco,
    'Pools and Spas': Icons.pool,
    'Presentation Supplies': Icons.slideshow,
    'Printers and Scanners': Icons.print,
    'Puzzles': Icons.extension,
    'RV and Camper Accessories': Icons.directions_car,
    'RV and Camper Parts': Icons.directions_car,
    'Refrigerators': Icons.kitchen,
    'Religious Clothing': Icons.hdr_strong,
    'Remote Control Toys': Icons.gamepad,
    'Resistance Bands': Icons.fitness_center,
    'Rice Cookers': Icons.kitchen,
    'Ride-On Toys': Icons.directions_bike,
    'Rings': Icons.wifi_tethering_error_rounded_sharp,
    'Rugs and Carpets': Icons.home,
    'Sauces and Condiments': Icons.restaurant,
    'Scarves and Shawls': Icons.accessibility_new,
    'Scarves and Shawls': Icons.accessibility_new,
    'Sculptures and Figurines': Icons.sentiment_satisfied_alt,
    'Senior Clothing': Icons.accessibility,
    'Sheds and Storage': Icons.store,
    'Shipping and Packaging': Icons.local_shipping,
    'Skateboarding and Scooters': Icons.directions_bike,
    'Skin Care': Icons.face,
    'Skin Care': Icons.face,
    'Sleepwear': Icons.nightlight_round,
    'Smart Home Devices': Icons.smart_display,
    'Smart Home Devices': Icons.smart_display,
    'Smartphones': Icons.smartphone,
    'Smartphones': Icons.smartphone,
    'Snacks': Icons.fastfood,
    'Special Occasion Clothing': Icons.star,
    'Spices and Seasonings': Icons.local_dining,
    'Sports Nutrition': Icons.fitness_center,
    'Sports Shoes': Icons.directions_run,
    'Sports and Athletic Wear': Icons.sports_basketball,
    'Spring/Summer Clothing': Icons.wb_sunny,
    'Stamps and Stamp Supplies': Icons.markunread_mailbox,
    'Staplers and Punches': Icons.attach_file,
    'Storage Furniture': Icons.storage,
    'Streetwear': Icons.streetview,
    'Strength Training': Icons.fitness_center,
    'Stuffed Animals': Icons.toys,
    'Sunglasses': Icons.wb_sunny_outlined,
    'Sweets and Desserts': Icons.cake,
    'Swimwear': Icons.pool,
    'Synthetic Fabric Clothing': Icons.shopping_bag,
    'Tablets': Icons.tablet,
    'Tablets': Icons.tablet,
    'Tea and Coffee': Icons.local_cafe,
    'Team Sports Gear': Icons.sports_soccer,
    'Teen Clothing': Icons.person,
    'Televisions': Icons.tv,
    'Televisions': Icons.tv,
    'Throws and Blankets': Icons.bed,
    'Ties and Bowties': Icons.label,
    'Ties and Bowties': Icons.label,
    'Tires and Wheels': Icons.directions_car,
    'Toasters': Icons.kitchen,
    'Tools and Equipment': Icons.build,
    'Tops': Icons.style,
    'Traditional Clothing': Icons.theaters,
    'Travel Accessories': Icons.card_travel,
    'Travel Adapters': Icons.power,
    'Travel Bags': Icons.card_travel,
    'Travel Clothing': Icons.card_travel,
    'Travel Electronics': Icons.devices,
    'Travel Guides': Icons.book,
    'Travel Locks': Icons.lock,
    'Travel Maps': Icons.map,
    'Travel Organizers': Icons.card_travel,
    'Travel Pillows and Blankets': Icons.airline_seat_individual_suite,
    'Travel Toiletries': Icons.bathroom,
    'Trendy/Fashion-forward Style': Icons.star,
    'Truck Accessories': Icons.local_shipping,
    'Truck Parts': Icons.local_shipping,
    'Underwear': Icons.shopping_basket,
    'Unisex Clothing': Icons.accessibility,
    'Vacuum Cleaners': Icons.cleaning_services,
    'Vases and Centerpieces': Icons.sentiment_satisfied,
    'Video Games': Icons.videogame_asset,
    'Vintage Clothing': Icons.shopping_bag_outlined,
    'Vitamins and Supplements': Icons.health_and_safety,
    'Wall Art': Icons.wallpaper,
    'Wallets and Purses': Icons.account_balance_wallet,
    'Washing Machines': Icons.wash,
    'Watches': Icons.watch,
    'Water Heaters': Icons.thermostat,
    'Water Sports Equipment': Icons.kayaking,
    'Wearable Devices': Icons.watch,
    'Weight Management': Icons.fitness_center,
    'Wellness Accessories': Icons.spa,
    'Whiteboards and Bulletin Boards': Icons.border_color,
    'Winter Sports Gear': Icons.snowboarding,
    'Women\'s Clothing': Icons.accessibility,
    'Woolen Clothing': Icons.shopping_bag,
    'Workout DVDs': Icons.video_library,
    'Workwear': Icons.work,
    'Writing Instruments': Icons.create,
    'Yoga and Pilates': Icons.self_improvement,
    'Yoga and Pilates Equipment': Icons.self_improvement,
    'ATV Accessories': Icons.directions_bike,
    'ATV Parts': Icons.directions_bike,
    'Accent Furniture': Icons.weekend,
    'Accessories': Icons.accessibility,
    'Action Figures': Icons.face,
    'Activewear': Icons.directions_run,
    'Adult Clothing': Icons.accessibility,
    'Air Conditioners': Icons.ac_unit,
    'Anklets': Icons.accessibility,
    'Art Supplies': Icons.palette,
    'Arts and Crafts': Icons.palette,
    'Athletic Accessories': Icons.directions_run,
    'Audio Devices': Icons.audiotrack,
    'Automotive Exterior': Icons.directions_car,
    'Automotive Interior': Icons.directions_car,
    'Baby Bath and Skincare': Icons.child_friendly,
    'Baby Bedding': Icons.child_friendly,
    'Baby Books and Gifts': Icons.child_friendly,
    'Baby Clothing': Icons.child_friendly,
    'Baby Feeding': Icons.child_friendly,
    'Baby Food': Icons.child_friendly,
    'Baby Gear': Icons.child_friendly,
    'Baby Health and Safety': Icons.child_friendly,
    'Baby Room Decor': Icons.child_friendly,
    'Baby Toys': Icons.child_friendly,
    'Baby Travel Gear': Icons.child_friendly,
    'Backpacks': Icons.backpack,
    'Baking Ingredients': Icons.restaurant,
    'Bath and Body': Icons.bathtub,
    'Bathroom Furniture': Icons.bathtub,
    'Beauty Accessories': Icons.beach_access,
    'Bedroom Furniture': Icons.king_bed,
    'Belts': Icons.accessibility,
    'Beverages': Icons.local_drink,
    'Bicycles': Icons.directions_bike,
    'Binders and Notebooks': Icons.book,
    'Blenders': Icons.kitchen,
    'Board Games': Icons.gamepad,
    'Boat Accessories': Icons.directions_boat,
    'Boat Parts': Icons.directions_boat,
    'Bohemian Style': Icons.weekend,
    'Bottoms': Icons.accessibility,
    'Bracelets': Icons.accessibility,
    'Brooches': Icons.accessibility,
    'Building Blocks': Icons.extension,
    'Calculators': Icons.calculate,
    'Calendars and Planners': Icons.calendar_today,
    'Cameras': Icons.photo_camera,
    'Camping Gear': Icons.campaign,
    'Candles and Candle Holders': Icons.light_mode,
    'Canned Foods': Icons.food_bank,
    'Car Accessories': Icons.directions_car,
    'Car Care Products': Icons.directions_car,
    'Car Parts': Icons.directions_car,
    'Cardio Equipment': Icons.directions_run,
    'Casual Wear': Icons.accessibility,
    'Chef\'s Uniforms': Icons.restaurant_menu,
    'Children\'s Clothing': Icons.child_friendly,
    'Classic Style': Icons.accessibility,
    'Clocks': Icons.access_time,
    'Coffee Makers': Icons.local_cafe,
    'Computers': Icons.computer,
    'Construction Workwear': Icons.construction,
    'Cooking Oils': Icons.restaurant,
    'Cotton Clothing': Icons.accessibility,
    'Curtains and Window Treatments': Icons.stay_current_portrait,
    'Dairy Products': Icons.food_bank,
    'Decorative Accents': Icons.home,
    'Denim Clothing': Icons.accessibility,
    'Desk Accessories': Icons.work,
    'Desktops': Icons.computer,
    'Diapers and Wipes': Icons.child_friendly,
    'Dining Room Furniture': Icons.restaurant,
    'Dishwashers': Icons.local_dining,
    'Dolls': Icons.sentiment_satisfied_alt,
    'Dresses': Icons.accessibility,
    'Earrings': Icons.accessibility,
    'Educational Toys': Icons.book,
    'Electronic Toys': Icons.videogame_asset,
    'Entryway Furniture': Icons.weekend,
    'Envelopes and Mailers': Icons.mail,
    'Exercise Accessories': Icons.fitness_center,
    'Exercise Clothing': Icons.fitness_center,
    'Exercise Mats and Flooring': Icons.fitness_center,
    'Fall/Winter Clothing': Icons.accessibility,
    'Fencing and Edging': Icons.fence,
    'Filing and Organization': Icons.folder,
    'First Aid': Icons.local_hospital,
    'Fitness Accessories': Icons.fitness_center,
    'Fitness Books and Guides': Icons.fitness_center,
    'Fitness Equipment': Icons.fitness_center,
    'Fitness Recovery': Icons.fitness_center,
    'Fitness Supplements': Icons.fitness_center,
    'Fitness Technology': Icons.fitness_center,
    'Fitness Trackers': Icons.fitness_center,
    'Food Processors': Icons.kitchen,
    'Formal Wear': Icons.accessibility,
    'Formalwear': Icons.accessibility,
    'Fragrances': Icons.spa,
    'Frozen Foods': Icons.food_bank,
    'Furniture Accessories': Icons.weekend,
    'Gaming Consoles': Icons.videogame_asset,
    'Garden Accessories': Icons.eco,
    'Gardening Tools': Icons.eco,
    'Gloves and Mittens': Icons.gesture,
    'Golf Equipment': Icons.golf_course,
    'Grains and Pasta': Icons.food_bank,
    'Grills and Outdoor Cooking': Icons.local_dining,
    'Hair Accessories': Icons.style,
    'Hair Care': Icons.style,
    'Hats and Caps': Icons.style,
    'Health Books': Icons.book,
    'Health Foods': Icons.food_bank,
    'Health Monitors': Icons.healing,
    'Hiking Equipment': Icons.directions_walk,
    'Holiday Decor': Icons.card_giftcard,
    'Home Appliances': Icons.home,
    'Home Entertainment Furniture': Icons.home,
    'Home Fragrances': Icons.home,
    'Home Gym Equipment': Icons.home,
    'Home Theater Systems': Icons.home,
    'Hunting and Fishing Gear': Icons.outdoor_grill,
    'Hygiene Products': Icons.cleaning_services,
    'Indoor Plants and Planters': Icons.eco,
    'Ironing Appliances': Icons.local_laundry_service,
    'Juicers': Icons.kitchen,
    'Kids\' Accessories': Icons.child_friendly,
    'Kids\' Bedding': Icons.child_friendly,
    'Kids\' Clothing': Icons.child_friendly,
    'Kids\' Furniture': Icons.child_friendly,
    'Kids\' Shoes': Icons.child_friendly,
    'Kids\' Toys': Icons.child_friendly,
    'Kitchen Furniture': Icons.kitchen,
    'Labels and Labeling': Icons.label,
    'Landscaping Supplies': Icons.landscape,
    'Laptops': Icons.computer,
    'Lawn Care': Icons.landscape,
    'Leather Clothing': Icons.accessibility,
    'Living Room Furniture': Icons.home,
    'Loungewear': Icons.weekend,
    'Luggage': Icons.luggage,
    'Luggage Tags': Icons.luggage,
    'Makeup': Icons.face,
    'Marine Electronics': Icons.sailing,
    'Maternity Clothing': Icons.pregnant_woman,
    'Medical Scrubs': Icons.local_hospital,
    'Medical Supplies': Icons.local_hospital,
    'Men\'s Clothing': Icons.accessibility,
    'Men\'s Grooming': Icons.accessibility,
    'Mental Health': Icons.self_improvement,
    'Microwaves': Icons.kitchen,
    'Military Uniforms': Icons.military_tech,
    'Minimalist Style': Icons.accessibility,
    'Mirrors': Icons.visibility,
    'Motorcycle Accessories': Icons.directions_bike,
    'Motorcycle Parts': Icons.directions_bike,
    'Natural and Herbal Remedies': Icons.healing,
    'Necklaces': Icons.accessibility,
    'Networking Devices': Icons.network_check,
    'Nursery Furniture': Icons.child_friendly,
    'Nutrition': Icons.local_dining,
    'Office Electronics': Icons.desktop_windows,
    'Office Furniture': Icons.work,
    'Oral Care': Icons.local_hospital,
    'Outdoor Clothing': Icons.wb_sunny,
    'Outdoor Decor': Icons.wb_sunny,
    'Outdoor Furniture': Icons.wb_sunny,
    'Outdoor Lighting': Icons.wb_sunny,
    'Outdoor Play Equipment': Icons.wb_sunny,
    'Outdoor Power Equipment': Icons.wb_sunny,
    'Outdoor Recreation': Icons.wb_sunny,
    'Outerwear': Icons.accessibility,
    'Ovens': Icons.kitchen,
    'Paper Products': Icons.book,
    'Party Supplies': Icons.party_mode,
    'Passport Holders': Icons.card_membership,
    'Patio and Decking': Icons.deck,
    'Personal Care': Icons.self_improvement,
    'Personal Care Appliances': Icons.self_improvement,
    'Pest Control': Icons.house,
    'Photo Frames': Icons.photo,
    'Pillows and Cushions': Icons.bed,
    'Plants and Seeds': Icons.eco,
    'Pools and Spas': Icons.pool,
    'Presentation Supplies': Icons.slideshow,
    'Printers and Scanners': Icons.print,
    'Puzzles': Icons.extension,
    'RV and Camper Accessories': Icons.directions_boat,
    'RV and Camper Parts': Icons.directions_boat,
    'Refrigerators': Icons.kitchen,
    'Religious Clothing': Icons.accessibility,
    'Remote Control Toys': Icons.toys,
    'Resistance Bands': Icons.fitness_center,
    'Rice Cookers': Icons.kitchen,
    'Ride-On Toys': Icons.toys,
    'Rings': Icons.accessibility,
    'Rugs and Carpets': Icons.landscape,
    'Sauces and Condiments': Icons.local_dining,
    'Scarves and Shawls': Icons.accessibility,
    'Sculptures and Figurines': Icons.sentiment_satisfied_alt,
    'Senior Clothing': Icons.accessibility,
    'Sheds and Storage': Icons.house,
    'Shipping and Packaging': Icons.local_shipping,
    'Skateboarding and Scooters': Icons.directions_bike,
    'Skin Care': Icons.self_improvement,
    'Sleepwear': Icons.self_improvement,
    'Smart Home Devices': Icons.home,
    'Smartphones': Icons.phone_android,
    'Snacks': Icons.fastfood,
    'Special Occasion Clothing': Icons.accessibility,
    'Spices and Seasonings': Icons.food_bank,
    'Sports Nutrition': Icons.fitness_center,
    'Sports Shoes': Icons.sports_soccer,
    'Sports and Athletic Wear': Icons.fitness_center,
    'Spring/Summer Clothing': Icons.accessibility,
    'Stamps and Stamp Supplies': Icons.markunread_mailbox,
    'Staplers and Punches': Icons.bookmark_border,
    'Storage Furniture': Icons.home,
    'Streetwear': Icons.accessibility,
    'Strength Training': Icons.fitness_center,
    'Stuffed Animals': Icons.toys,
    'Sunglasses': Icons.visibility,
    'Sweets and Desserts': Icons.cake,
    'Swimwear': Icons.pool,
    'Synthetic Fabric Clothing': Icons.accessibility,
    'Tablets': Icons.tablet,
    'Tea and Coffee': Icons.local_cafe,
    'Team Sports Gear': Icons.sports_soccer,
    'Teen Clothing': Icons.accessibility,
    'Televisions': Icons.tv,
    'Throws and Blankets': Icons.bed,
    'Ties and Bowties': Icons.accessibility,
    'Tires and Wheels': Icons.directions_car,
    'Toasters': Icons.kitchen,
    'Tools and Equipment': Icons.build,
    'Tops': Icons.accessibility,
    'Traditional Clothing': Icons.accessibility,
    'Travel Accessories': Icons.flight,
    'Travel Adapters': Icons.flight,
    'Travel Bags': Icons.flight,
    'Travel Clothing': Icons.flight,
    'Travel Electronics': Icons.flight,
    'Travel Guides': Icons.flight,
    'Travel Locks': Icons.flight,
    'Travel Maps': Icons.flight,
    'Travel Organizers': Icons.flight,
    'Travel Pillows and Blankets': Icons.flight,
    'Travel Toiletries': Icons.flight,
    'Trendy/Fashion-forward Style': Icons.accessibility,
    'Truck Accessories': Icons.local_shipping,
    'Truck Parts': Icons.local_shipping,
    'Yoga and Pilates': Icons.self_improvement,
    'Yoga and Pilates Equipment': Icons.self_improvement,
    // Add more mappings here
  };


  Widget _buildSubGroups() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(vertical: 1, horizontal: 2),
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
              width: 75,
              height: 100,
              margin: const EdgeInsets.symmetric(horizontal: 5),
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 25),
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
              child: Column(
                children: [
                  Icon(
                    subIconMapping[value.name] ?? Icons.error,
                    size: 20,
                    color: selectedSubGroup == value.name
                        ? Colors.white
                        : Colors.black,
                  ),
                  SizedBox(height: 5),
                  Text(
                    value.name.length>=15? value.name.substring(0,15):value.name,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: selectedSubGroup == value.name
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

    _prefs = await SharedPreferences.getInstance();
    RowKey = _prefs.getString('RowKey');

    if (RowKey == null) {
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
            context, MaterialPageRoute(builder: (context) => SettingsPage()));
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

          title: Text(FlutterI18n.translate(context, "ProductList")),
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
                  hintText: FlutterI18n.translate(context, "Search"),
                  prefixIcon: const Icon(Icons.search),
                  suffixIcon: _searchController.text.isNotEmpty ? IconButton(icon: const Icon(Icons.clear), onPressed: _clearSearch,) : null,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: const BorderSide(color: Colors.grey),
                  ),
                  filled: false,
                  fillColor: Colors.grey[200],
                  //contentPadding: const EdgeInsets.symmetric(vertical: 6.0, horizontal: 8.0),
                ),
                style: const TextStyle(fontSize: 16.0),
              ),
            ),
            // Conditionally display widgets based on scrolling state
            if (!_isListViewScrolling) _buildGroups(),
            SizedBox(height: 10),
            if (!_isListViewScrolling) _buildSubGroups(),
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
