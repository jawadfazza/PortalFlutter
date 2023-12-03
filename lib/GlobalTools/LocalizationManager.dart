import 'package:flutter/material.dart';

class LocalizationManager {
  static final LocalizationManager _instance = LocalizationManager._internal();

  factory LocalizationManager() {
    return _instance;
  }

  LocalizationManager._internal();

  Locale? currentLocale;

  void setCurrentLocale(Locale locale) {
    currentLocale = locale;
  }

  Locale getCurrentLocale() {
    return currentLocale ?? Locale('en'); // Default locale if not set
  }
}
