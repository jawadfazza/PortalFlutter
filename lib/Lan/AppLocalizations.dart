import 'package:flutter/material.dart';

class AppLocalizations {
  final Locale locale;

  AppLocalizations(this.locale);



  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  static const Map<String, Map<String, String>> _localizedValues = {
    'en': {
      'appTitle': 'Language Switching Example',
      'hello': 'Hello!',
      'registrationForm': 'Registration Form',
      'fullName': 'Full Name',
      'email': 'Email',
      'password': 'Password',
      'confirmPassword': 'Confirm Password',
      'register': 'Register New Account',

    },
    'ar': {
      'registrationForm': 'نموذج التسجيل',
      'fullName': 'الاسم الكامل',
      'email': 'البريد الإلكتروني',
      'password': 'كلمة المرور',
      'confirmPassword': 'تأكيد كلمة المرور',
      'register': 'تسجيل حساب جديد',
    },
  };

  String get appTitle {
    return _localizedValues[locale.languageCode]!['appTitle']!;
  }

  String get hello {
    return _localizedValues[locale.languageCode]!['hello']!;
  }

  String get registrationForm {
    return _localizedValues[locale.languageCode]!['registrationForm']!;
  }

  String get fullName {
    return _localizedValues[locale.languageCode]!['fullName']!;
  }

  String get email {
    return _localizedValues[locale.languageCode]!['email']!;
  }

  String get password {
    return _localizedValues[locale.languageCode]!['password']!;
  }

  String get confirmPassword {
    return _localizedValues[locale.languageCode]!['confirmPassword']!;
  }

  String get register {
    return _localizedValues[locale.languageCode]!['register']!;
  }

}




class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) {
    return ['en', 'fr'].contains(locale.languageCode);
  }

  @override
  Future<AppLocalizations> load(Locale locale) async {
    return AppLocalizations(locale);
  }

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}
