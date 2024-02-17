import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:flutter_i18n/loaders/file_translation_loader.dart';
import 'package:flutter_i18n/loaders/decoders/json_decode_strategy.dart';
import 'package:shopping/GlobalTools/AppConfig.dart';
import 'Account/Models/Account.dart';
import 'GlobalTools/LocalizationManager.dart';
import 'Shop/View/Products/ProductList.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  // Initialize GoogleSignIn
 // GoogleSignIn().onCurrentUserChanged.listen((GoogleSignInAccount? account) {
    // Handle user changes
  //  print('GoogleSignInAccount changed: $account');
 // });
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
   bool? _isDark = false;

  @override
  void initState() {
    super.initState();
    startAnimation();
    fetchDataProfile();
  }
  void startAnimation() {
    Future.delayed(const Duration(seconds: 2), () {
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
                  duration: const Duration(seconds: 1),
                  width: _animated ? _imageWidth : 250,
                  height: _animated ? _imageHeight : 250,

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
        appBarTheme: const AppBarTheme(

          color: Colors.deepPurple, // App bar background color
          elevation: 0, // No shadow
          centerTitle: true, // Center align title

          textTheme: TextTheme(
            titleLarge: TextStyle(
              color: Colors.white, // Text color of the app bar title
              fontSize: 24.0, // Font size of the app bar title
              fontWeight: FontWeight.bold, // Font weight of the app bar title
            ),
          ),
        ),
        // Define the text theme
        textTheme: const TextTheme(
          bodySmall:  TextStyle(
            fontSize: 16.0, // Default font size for body text
            color: Colors.black87, // Default color for body text
            letterSpacing: 0.5, // Add slight letter spacing for body text
          ),
          headlineSmall:  TextStyle(
            fontSize: 28.0, // Larger font size for headlines
            color: Colors.black, // Color for headlines
            fontWeight: FontWeight.bold, // Bold font weight for headlines
          ),
          // Add more text styles for different purposes as needed

        ),
        // Define the card theme
        cardTheme: CardTheme(
          elevation: 4, // Elevation of cards
          margin: const EdgeInsets.all(8.0), // Margin around cards
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0), // Rounded corners for cards
          ),
        ),
        // Define button theme
        buttonTheme: ButtonThemeData(
          buttonColor: Colors.deepPurple, // Button background color
          textTheme: ButtonTextTheme.primary, // Text color is set to primary
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0), // Rounded corners for buttons
          ),
        ),
        // Define other theme properties as necessary
        scaffoldBackgroundColor: Colors.grey[200], // Background color for scaffold
        dividerColor: Colors.grey[300], // Color for dividers
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 24.0),
            textStyle: const TextStyle(
              fontSize: 18.0,
              fontWeight: FontWeight.bold,
            ),
          ),
        ), colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.deepPurple).copyWith(secondary: Colors.pinkAccent),
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
