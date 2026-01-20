import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TutorialProvider with ChangeNotifier {
  static const String _tutorialKey = 'tutorial_completed';
  bool _isTutorialCompleted = false;
  bool _isInitialized = false;

  bool get isTutorialCompleted => _isTutorialCompleted;
  bool get isInitialized => _isInitialized;

  TutorialProvider() {
    _loadTutorialStatus();
  }

  Future<void> _loadTutorialStatus() async {
    final prefs = await SharedPreferences.getInstance();
    _isTutorialCompleted = prefs.getBool(_tutorialKey) ?? false;
    _isInitialized = true;
    notifyListeners();
  }

  Future<void> completeTutorial() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_tutorialKey, true);
    _isTutorialCompleted = true;
    notifyListeners();
  }
}
