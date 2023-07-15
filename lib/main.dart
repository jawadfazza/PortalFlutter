

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shopping/Screens/ProductListingScreen.dart';

import 'Screens/Account/LoginPage.dart';

Future<void> main() async {

  // Initialize the database factory
  //sqfliteFfiInit();

  // Set the database factory
  //databaseFactory = databaseFactoryFfi;

  runApp(ShoppingApp());
}

class ShoppingApp extends StatelessWidget{

  @override
  Widget build(BuildContext context) {
    // TODO: implement build

    return MaterialApp(
      title: 'Shopping App',
      theme: ThemeData(
        primaryColor: Colors.blue,
      ),
      home: LoginPage(),
    );
  }

}