import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/category.dart';

class CategoryProvider with ChangeNotifier {
  List<Category> _categories = [];
  static const String _categoriesKey = 'categories';

  List<Category> get categories => _categories;

  CategoryProvider() {
    _loadCategories();
  }

  Future<void> _loadCategories() async {
    final prefs = await SharedPreferences.getInstance();
    final categoriesJson = prefs.getStringList(_categoriesKey) ?? [];
    _categories = categoriesJson.map((json) => Category.fromJson(jsonDecode(json))).toList();
    notifyListeners();
  }

  Future<void> _saveCategories() async {
    final prefs = await SharedPreferences.getInstance();
    final categoriesJson = _categories.map((cat) => jsonEncode(cat.toJson())).toList();
    await prefs.setStringList(_categoriesKey, categoriesJson);
  }

  void addCategory(Category category) {
    _categories.add(category);
    _saveCategories();
    notifyListeners();
  }

  void updateCategory(Category updatedCategory) {
    final index = _categories.indexWhere((cat) => cat.id == updatedCategory.id);
    if (index != -1) {
      _categories[index] = updatedCategory;
      _saveCategories();
      notifyListeners();
    }
  }

  void deleteCategory(String id) {
    _categories.removeWhere((cat) => cat.id == id);
    _saveCategories();
    notifyListeners();
  }
}