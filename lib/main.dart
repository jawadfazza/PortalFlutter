import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n_delegate.dart';
import 'package:flutter_i18n/loaders/decoders/json_decode_strategy.dart';
import 'package:flutter_i18n/loaders/file_translation_loader.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:shopping/GlobalTools/AppConfig.dart';
import 'package:shopping/GlobalTools/ProgressCustome.dart';
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
   static String preferdLanguage = "EN";
   bool fetchedData = false;

  @override
  void initState() {
    super.initState();
    fetchDataProfile();
  }

  Future<void> fetchDataProfile() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    String? RowKey = prefs.getString('RowKey');
    final LocalizationManager localizationManager = LocalizationManager();
    try {
      var url = '${AppConfig.baseUrl}/api/Accounts/GetByRowKey?RowKey=$RowKey';
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        print(jsonResponse);
        Account _account = Account.fromJson(jsonResponse);


        setState(() {
          preferdLanguage = _account.preferdLanguage!=""?_account.preferdLanguage:"EN";
          localizationManager.setCurrentLocale(Locale(preferdLanguage));
          fetchedData = true;
        });
      }else{
        setState(() {
          preferdLanguage = "EN";
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
      return Center(
        child: Directionality(
          textDirection: TextDirection.ltr,
          child: SingleChildScrollView(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: const [
                  SizedBox(
                    width: 100,
                    height: 100,
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.blueAccent),
                      strokeWidth: 4,
                      semanticsLabel: 'Loading',
                    ),
                  ),
                  //SizedBox(height: 20),
                  //
                ],
              ),
            ),
          ),
        ),
      );
    } else {
      return MaterialApp(
        theme: ThemeData(
          appBarTheme: const AppBarTheme(backgroundColor: Colors.blueGrey),
          primaryColor: Colors.blueAccent,
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






