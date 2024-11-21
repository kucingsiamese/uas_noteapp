import 'package:flutter/material.dart';

class ThemeProvider extends ChangeNotifier {
  bool _isDarkMode = false;
  bool get isDarkMode => _isDarkMode;

  ThemeData get themeData => _isDarkMode
      ? ThemeData.dark().copyWith(primaryColor: Colors.blue)
      : ThemeData.light().copyWith(primaryColor: Colors.blue);

  void toggleTheme() {
    _isDarkMode = !_isDarkMode;
    notifyListeners();
  }
}
