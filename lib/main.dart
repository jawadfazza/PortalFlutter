import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n_delegate.dart';
import 'package:flutter_i18n/loaders/decoders/json_decode_strategy.dart';
import 'package:flutter_i18n/loaders/file_translation_loader.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
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
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Shopping App',
      theme: ThemeData(
        primaryColor: Colors.purpleAccent, // Set the primary color here
      ),
      locale: Locale('en'), // Set the default locale to 'en'
      localizationsDelegates: [
        FlutterI18nDelegate(
          translationLoader: FileTranslationLoader(
            useCountryCode: false,
            fallbackFile: 'en', // Default language fallback to 'en'
            basePath: 'assets/i18n',
          ),
        ),
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: [
        const Locale('en'),
        const Locale('ar'),
      ],
      localeResolutionCallback: (locale, supportedLocales) {
        // Check if the provided locale is supported
        for (var supportedLocale in supportedLocales) {
          if (supportedLocale.languageCode == locale?.languageCode) {
            return supportedLocale;
          }
        }
        // If not supported, return the default locale
        return supportedLocales.first;
      },
      home: ProductList(FlutterI18nDelegate()),
    );
  }
}
