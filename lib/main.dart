import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n_delegate.dart';
import 'package:flutter_i18n/loaders/decoders/json_decode_strategy.dart';
import 'package:flutter_i18n/loaders/file_translation_loader.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:shopping/Shop/Models/Product.dart';
import 'package:shopping/Shop/Products/ProductList.dart';

import 'Account/LoginPage.dart';


void main() async {
  final flutterI18nDelegate = FlutterI18nDelegate(
    translationLoader: FileTranslationLoader(
      useCountryCode: false,
      fallbackFile: 'en',
      basePath: 'assets/translations',
      decodeStrategies: [JsonDecodeStrategy()],
    ),
  );
  await flutterI18nDelegate.load(Locale('en'));
  FlutterError.onError = (FlutterErrorDetails details) {
    // Handle the error here (e.g., log or report to a crash reporting service)
    print('Global Error: ${details.exception}');


  };
  runApp(MyApp(flutterI18nDelegate));
}

class MyApp extends StatelessWidget {
  final FlutterI18nDelegate flutterI18nDelegate;

  MyApp(this.flutterI18nDelegate);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Shopping App',
      theme: ThemeData(
        primaryColor: Colors.deepPurpleAccent, // Set the primary color here
      ),
      localizationsDelegates: [
        flutterI18nDelegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: [
        const Locale('en'),
        const Locale('ar'),
      ],
      home: ProductList(flutterI18nDelegate),
    );
  }
}

