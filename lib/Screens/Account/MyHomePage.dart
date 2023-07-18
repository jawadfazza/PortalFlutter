import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:flutter_localizations/flutter_localizations.dart';



class MyHomePage extends StatefulWidget {
  final FlutterI18nDelegate flutterI18nDelegate;

  MyHomePage(this.flutterI18nDelegate);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Locale _currentLocale = Locale('en');

  void _changeLanguage(Locale newLocale) {
    setState(() {
      _currentLocale = newLocale;
      FlutterI18n.refresh(context, newLocale);
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Internationalization Example',
      localizationsDelegates: [
        widget.flutterI18nDelegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: [
        const Locale('en'),
        const Locale('ar'),
      ],
      locale: _currentLocale,
      home: Scaffold(
        appBar: AppBar(
          title: Text(FlutterI18n.translate(context, 'appTitle')),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              DropdownButton<Locale>(
                value: _currentLocale,
                onChanged: (newLocale) => _changeLanguage(newLocale!),
                items: [
                  DropdownMenuItem(
                    value: const Locale('en'),
                    child: Text('English'),
                  ),
                  DropdownMenuItem(
                    value: const Locale('ar'),
                    child: Text('Arabic'),
                  ),
                ],
              ),
              Text(
                FlutterI18n.translate(context, 'hello'),
                style: TextStyle(fontSize: 20),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

