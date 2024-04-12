import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shopping/Shop/Models/Product.dart';
import '../../GlobalTools/AppConfig.dart';
import '../../GlobalTools/LocalizationManager.dart';

import '../../Service/ConnctData.dart';
import '../Models/Group.dart';
import '../Models/SubGroup.dart';

class ProductController extends ChangeNotifier {
  int layoutNumber = 2;
  int pageSize = 20;
  int pageNumber = 1;
  bool isFetching = false;
  bool isPageLoading = false;
  bool isResultFound = false;
  bool hasError = false;
  bool showScrollButton = false;
  bool isAddingToCart = false;
  bool isListViewScrolling = false;

  String searchQuery = '';
  String errorMessage = '';
  late String productRowKey = '';
  String? rowKey = ''; // Ensure variable names follow Dart's naming conventions
  String selectedGroup = '';
  String selectedSubGroup = '';
  List<Product> products = [];
  List<Product> filteredProducts = [];
  Locale currentLocale = LocalizationManager().getCurrentLocale(); // Ensure this method exists and returns the correct Locale
  List<Group> groupOptions = [];
  List<SubGroup> subGroupOptions = [];
  List<SubGroup> filteredSubGroupOptions = [];

  Future<void> fetchData({required bool moreData}) async {
    if (isFetching && !moreData) return; // Prevent new fetches only if not loading more data

    isFetching = true;
    if (!moreData) {
      //isPageLoading = true;
      pageNumber = 1;
      products.clear();
    } else {
      pageNumber++;
    }
    notifyListeners(); // Notify listeners that loading state has begun

    try {
      var groupRowKey = groupOptions.isNotEmpty ? groupOptions.firstWhere((element) => element.name == selectedGroup ).rowKey:'';
      var subGroupRowKey =subGroupOptions.isNotEmpty? subGroupOptions.firstWhere((element) => element.name == selectedSubGroup).rowKey:'';

      var url = '${AppConfig.baseUrl}/api/Products/'
          '${searchQuery.isEmpty ? "LoadPartialData" : "LoadPartialDataWithSearch"}?'
          '${searchQuery.isEmpty ? "" : "searchQuery=$searchQuery&" }'
          'pageSize=$pageSize'
          '&pageNumber=$pageNumber'
          '&Lan=${currentLocale.languageCode.toUpperCase()}'
          '&groupOptions=$groupRowKey'
          '&subGroupOptions=$subGroupRowKey';
        final List<dynamic> jsonList = await CallAPI.getrequest(url) as List<dynamic>;
        final List<Product> newProducts = jsonList.map((json) => Product.fromJson(json)).toList();

        products.addAll(newProducts);
        isResultFound = newProducts.isNotEmpty;
    } catch (error) {
      hasError = true;
      errorMessage = error.toString();
    } finally {
      isFetching = false;
      //isPageLoading = false;
      notifyListeners(); // Notify listeners that loading state has ended
    }
  }

  Future<void> fetchDataGroups() async {
    try {
      var url = '${AppConfig.baseUrl}/api/Groups/LoadAllData?Lan=${currentLocale
          .languageCode.toUpperCase()}';
      final List<dynamic> jsonList = await CallAPI.getrequest(url) as List<dynamic>;
      final List<Group> newGroups =
      jsonList.map((json) => Group.fromJson(json)).toList();

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
    }catch (error) {
      print(error);
    } finally {
      notifyListeners(); // Notify listeners that loading state has ended
    }
  }

  Future<void> fetchDataSubGroups() async {
    try {
      var url = '${AppConfig.baseUrl}/api/SubGroups/LoadAllData?Lan=${currentLocale.languageCode.toUpperCase()}';
        final List<dynamic> jsonList = await CallAPI.getrequest(url) as List<dynamic>;
        final List<SubGroup> newSubGroups = jsonList.map((json) => SubGroup.fromJson(json)).toList();
        newSubGroups.sort((a, b) => a.name.compareTo(b.name));

        subGroupOptions.clear();
        subGroupOptions.add(SubGroup(partitionKey: '',
            rowKey: '',
            seq: 1,
            name: '-',
            languageID: currentLocale.languageCode,
            imageURL: '',
            active: true,
            groupRowKey: ''));
        subGroupOptions.addAll(newSubGroups);

    } catch (error) {
      print(error);
    }finally {
      notifyListeners(); // Notify listeners that loading state has ended
    }
  }

}
