import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TutorialProvider with ChangeNotifier {
  static const String _tutorialKey = 'tutorial_completed';
  bool _isTutorialCompleted = false;

  bool get isTutorialCompleted => _isTutorialCompleted;

  TutorialProvider() {
    _loadTutorialStatus();
  }

  Future<void> _loadTutorialStatus() async {
    final prefs = await SharedPreferences.getInstance();
    _isTutorialCompleted = prefs.getBool(_tutorialKey) ?? false;
    notifyListeners();
  }

  Future<void> completeTutorial() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_tutorialKey, true);
    _isTutorialCompleted = true;
    notifyListeners();
  }
}
