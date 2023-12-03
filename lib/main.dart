import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n_delegate.dart';
import 'package:flutter_i18n/loaders/decoders/json_decode_strategy.dart';
import 'package:flutter_i18n/loaders/file_translation_loader.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'Account/Models/Account.dart';
import 'GlobalTools/LocalizationManager.dart';
import 'Shop/Products/ProductList.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  _MyAppState createState() => _MyAppState();
}

 class _MyAppState extends State<MyApp> {
   static String preferdLanguage = "";


  bool fetchedData = false;

  @override
  void initState() {
    super.initState();
    fetchDataProfile();
  }

  Future<void> fetchDataProfile() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    String? RowKey = prefs.getString('RowKey');
    try {
      var url = 'https://portalapps.azurewebsites.net/api/Accounts/GetByRowKey?RowKey=$RowKey';
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        print(jsonResponse);
        Account _account = Account.fromJson(jsonResponse);
        final LocalizationManager localizationManager = LocalizationManager();

        setState(() {
          preferdLanguage = _account.preferdLanguage;
          localizationManager.setCurrentLocale(Locale(preferdLanguage));
          fetchedData = true;
        });
      }
    } catch (error) {
      print(error);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!fetchedData) {
      return CircularProgressIndicator(); // Show a loading indicator until data is fetched
    } else {
      return MaterialApp(
        theme: ThemeData(
          appBarTheme: AppBarTheme(backgroundColor: Colors.deepPurple),
          primaryColor: Colors.deepPurpleAccent,
          inputDecorationTheme: InputDecorationTheme(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            contentPadding: const EdgeInsets.symmetric(
              vertical: 14.0,
              horizontal: 16.0,
            ),
          ),
          checkboxTheme: CheckboxThemeData(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(4.0),
            ),
          ),
          radioTheme: RadioThemeData(
            fillColor: MaterialStateColor.resolveWith((states) =>
            Colors.deepPurpleAccent),
          ),
          colorScheme: ColorScheme.fromSwatch().copyWith(
            secondary: Colors.deepPurpleAccent,
          ),
        ),
        localizationsDelegates: [
          FlutterI18nDelegate(
            translationLoader: FileTranslationLoader(
              useCountryCode: false,
              fallbackFile: preferdLanguage, // Default language file
              basePath: 'assets/translations',
              decodeStrategies: [JsonDecodeStrategy()],
            ),
          ),
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
        ],
        supportedLocales: const [
          Locale('en'),
          Locale('ar'),
        ],
        home: ProductList()
      );
    }
  }
}


