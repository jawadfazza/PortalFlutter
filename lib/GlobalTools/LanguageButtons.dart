import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';

class LanguageButtons extends StatelessWidget {
  // ... rest of the code ...
  final Locale currentLocale;
  final Function(Locale) changeLanguage;

  LanguageButtons({
    required this.currentLocale,
    required this.changeLanguage,
  });

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      child: Container(
        height: 60.0,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextButton(
              onPressed: () => changeLanguage(const Locale('en')),
              child: const Text('English'),
            ),
            const SizedBox(width: 16.0),
            TextButton(
              onPressed: () => changeLanguage(const Locale('ar')),
              child: const Text('العربية'),
            ),
          ],
        ),
      ),
    );
  }
}
