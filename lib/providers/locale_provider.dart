import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocaleProvider with ChangeNotifier {
  static const String _localeKey = 'locale';
  Locale _locale = const Locale('en');

  Locale get locale => _locale;

  LocaleProvider() {
    _loadLocale();
  }

  Future<void> _loadLocale() async {
    final prefs = await SharedPreferences.getInstance();
    final String? savedLocale = prefs.getString(_localeKey);

    if (savedLocale != null) {
      _locale = Locale(savedLocale);
    } else {
      // First run: Check system locale
      final String systemLanguage =
          PlatformDispatcher.instance.locale.languageCode;
      if (systemLanguage == 'tr' || systemLanguage == 'es') {
        _locale = Locale(systemLanguage);
      } else {
        _locale = const Locale('en');
      }
      // Save it as the initial choice if you want to persist the first-time detection immediately
      // For now, we just set the _locale. If the user changes it, it will be saved.
    }
    notifyListeners();
  }

  Future<void> _saveLocale() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_localeKey, _locale.languageCode);
  }

  void setLocale(Locale locale) {
    _locale = locale;
    _saveLocale();
    notifyListeners();
  }
}
