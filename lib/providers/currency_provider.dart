import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CurrencyProvider with ChangeNotifier {
  static const String _currencyKey = 'currency';
  String _currency = '\$';

  String get currency => _currency;

  CurrencyProvider() {
    _loadCurrency();
  }

  Future<void> _loadCurrency() async {
    final prefs = await SharedPreferences.getInstance();
    String? savedCurrency = prefs.getString(_currencyKey);

    if (savedCurrency == null) {
      // First run: Check system locale
      final String systemLanguage =
          PlatformDispatcher.instance.locale.languageCode;
      if (systemLanguage == 'tr') {
        savedCurrency = '₺';
      } else {
        savedCurrency = '\$';
      }
    }

    _currency = savedCurrency;
    notifyListeners();
  }

  Future<void> _saveCurrency() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_currencyKey, _currency);
  }

  void setCurrency(String currency) {
    _currency = currency;
    _saveCurrency();
    notifyListeners();
  }

  // Common currency options
  static const Map<String, String> currencyOptions = {
    '\$': 'USD',
    '€': 'EUR',
    '£': 'GBP',
    '₺': 'TL',
    '¥': 'JPY',
    '₹': 'INR',
  };
}
