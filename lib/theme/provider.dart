import 'package:flutter/material.dart';

class UiProvider extends ChangeNotifier {

  bool _isDark = false;
  bool get isDark => _isDark;

  // custom dark theme setting
  final darkTheme = ThemeData(
    primaryColor: Colors.black12,
    brightness: Brightness.dark,
    primaryColorDark: Colors.black12,
  );

  // custom light theme setting
  final lightTheme = ThemeData(
    primaryColor: Colors.blue,
    brightness: Brightness.light,
    primaryColorLight: Colors.white,

  );

  void changeTheme(bool value) {
    _isDark = !isDark;
    notifyListeners();
  }

  void init(){
    notifyListeners();
  }
}