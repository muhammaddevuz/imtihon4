import 'package:flutter/material.dart';

class ThemeModeController extends ChangeNotifier {
  static bool checkNightMode = false;

  bool get nightMode {
    return checkNightMode;
  }

  void editMode() {
    checkNightMode = !checkNightMode;
    notifyListeners();
  }
}
