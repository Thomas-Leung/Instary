import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppStateNotifier extends ChangeNotifier {
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  bool isDarkModeOn = false;

  AppStateNotifier() {
    getSharedPref();
  }

  Future<void> getSharedPref() async {
    final SharedPreferences prefs = await _prefs;
    isDarkModeOn = prefs.getBool('isDarkModeOn') ?? false;
    notifyListeners();
  }

  Future<void> updateTheme(bool isDarkModeOn) async {
    final SharedPreferences prefs = await _prefs;
    this.isDarkModeOn = isDarkModeOn;
    prefs.setBool('isDarkModeOn', isDarkModeOn);
    notifyListeners();
  }
}
