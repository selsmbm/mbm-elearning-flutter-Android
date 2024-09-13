import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mbm_elearning/Presentation/Constants/Colors.dart';
import 'package:mbm_elearning/Presentation/Constants/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeController with ChangeNotifier {
  late ThemeMode themeMode;
  
  Future<void> loadSettings() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.getBool(SP.darkMode) == null ||
        prefs.getBool(SP.darkMode) == false) {
      themeMode = ThemeMode.light;
    } else {
      themeMode = ThemeMode.dark;
    }
    notifyListeners();
  }

  updateThemeMode(ThemeMode theme) async {
    themeMode = theme;
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent, // status bar color
      systemNavigationBarColor: themeMode == ThemeMode.dark
          ? rPrimaryDarkLiteColor
          : rPrimaryLiteColor, // status bar color
      statusBarIconBrightness: Brightness.dark, // status bar icons' color
      systemNavigationBarIconBrightness:
          Brightness.dark, //navigation bar icons' color
    ));
    notifyListeners();
  }
}
