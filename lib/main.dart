import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:flutter_i18n/loaders/file_translation_loader.dart';
import 'package:flutter_i18n/loaders/decoders/json_decode_strategy.dart';
import 'package:shopping/GlobalTools/AppConfig.dart';
import 'Account/Models/Account.dart';
import 'GlobalTools/LocalizationManager.dart';
import 'Shop/Products/ProductList.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Your App Title',
      home: AppBody(),
    );
  }
}

class AppBody extends StatefulWidget {
  @override
  _AppBodyState createState() => _AppBodyState();
}

class _AppBodyState extends State<AppBody> {
  static String preferredLanguage = "EN";
  bool fetchedData = false;
  double _imageWidth = 100;
  double _imageHeight = 100;
  bool _animated = false;

  @override
  void initState() {
    super.initState();
    startAnimation();
    fetchDataProfile();
  }
  void startAnimation() {
    Future.delayed(Duration(seconds: 2), () {
      setState(() {
        _animated = true;
        _imageWidth = 300; // New width after animation ends
        _imageHeight = 300; // New height after animation ends
      });
    });
  }

  Future<void> fetchDataProfile() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    String? rowKey = prefs.getString('RowKey');
    final LocalizationManager localizationManager = LocalizationManager();
    try {
      var url = '${AppConfig.baseUrl}/api/Accounts/GetByRowKey?RowKey=$rowKey';
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        print(jsonResponse);
        Account _account = Account.fromJson(jsonResponse);

        setState(() {
          preferredLanguage = _account.preferdLanguage.isNotEmpty
              ? _account.preferdLanguage
              : "EN";
          localizationManager.setCurrentLocale(Locale(preferredLanguage));
          fetchedData = true;
        });
      } else {
        setState(() {
          preferredLanguage = "EN";
          localizationManager.setCurrentLocale(Locale(preferredLanguage));
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
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                AnimatedContainer(
                  duration: Duration(seconds: 1),
                  width: _animated ? _imageWidth : 100,
                  height: _animated ? _imageHeight : 100,

                  curve: Curves.easeInOut,
                  child: Image.asset(
                    'assets/Logo/logo.png', // Replace with your image path
                    fit: BoxFit.cover,
                  ),
                )
              ],
            ),
          ),
        ),
      );
    } else {
      return MaterialApp(
        theme: ThemeData(
          // Your theme configurations
        ),
        localizationsDelegates: [
          FlutterI18nDelegate(
            translationLoader: FileTranslationLoader(
              useCountryCode: false,
              fallbackFile: preferredLanguage,
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
        home: ProductList(),
      );
    }
  }
}
