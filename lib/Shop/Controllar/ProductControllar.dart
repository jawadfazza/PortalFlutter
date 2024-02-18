import 'dart:ui';
import 'package:flutter/foundation.dart';
import 'package:shopping/Shop/Models/Product.dart';
import '../../GlobalTools/AppConfig.dart';
import '../../GlobalTools/LocalizationManager.dart';
import '../../Service/ConnctData.dart';
import '../Models/Group.dart';
import '../Models/SubGroup.dart';

class ProductControllar extends ChangeNotifier {

   int layoutNumber = 2;
   int  pageSize=20;
   int  pageNumber=1;
   bool isLoading = false;
   bool isPageLoading = false;
   bool isResultFound = false;
   bool hasError = false;
   bool showScrollButton = false;
   bool isAddingToCart = false;
   bool isListViewScrolling = false;

   String searchQuery = '';
   String errorMessage = '';
   late String productRowKey = '';
   String? RowKey = '';
   String selectedGroup = '-';
   String selectedSubGroup = '-';
   List<Product> products = [];
   List<Product> filteredProducts = [];
   Locale currentLocale = LocalizationManager().getCurrentLocale();
   List<Group> groupOptions = []; // List of grouping options
   List<SubGroup> subGroupOptions = [];

   List<SubGroup> filteredSubGroupOptions = [];
   fetchData({required bool moredata}) async {
    try {
      if (!isLoading) {
        if(moredata){
          pageSize = 20;
          pageNumber += 1;
        }else{
          pageSize = 20;
          pageNumber = 1;
          products.clear();
        }
          isLoading = true;
          hasError = false;
          errorMessage = '';
          notifyListeners();

          var groupRowKey = groupOptions.firstWhere((element) => element.name == selectedGroup).rowKey;
          var subGroupRowKey = subGroupOptions.firstWhere((element) => element.name == selectedSubGroup).rowKey;
          var url = '${AppConfig.baseUrl}/api/Products/${searchQuery==""?'LoadPartialData':'LoadPartialDataWithSearch'}?pageSize=$pageSize&pageNumber=$pageNumber&Lan=${currentLocale.languageCode.toUpperCase()}&groupOptions=$groupRowKey&subGroupOptions=$subGroupRowKey';
          final List<dynamic> jsonList = await CallAPI.getrequest(url) as List<dynamic>;
          final List<Product> newProducts = jsonList.map((json) => Product.fromJson(json)).toList();
          products.addAll(newProducts);

          isLoading = false;

          notifyListeners();
      }
    } catch (error) {
        hasError = true;
        errorMessage = 'Error: $error';
        isLoading = false;
        notifyListeners();
    }

  }


}

