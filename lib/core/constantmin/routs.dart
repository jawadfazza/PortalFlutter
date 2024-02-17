import 'package:get/get.dart';
import 'package:shopping/Shop/View/Products/ProductList.dart';
import '../../main.dart';



List<GetPage<dynamic>>? getPage = [
  GetPage(name: '/', page: () => MyApp()),
  GetPage(name: '/ProductList', page: () => ProductList()),
];
