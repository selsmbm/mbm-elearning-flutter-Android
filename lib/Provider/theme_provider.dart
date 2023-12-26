import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mbm_elearning/Presentation/Constants/Colors.dart';
import 'package:mbm_elearning/Presentation/Constants/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeController with ChangeNotifier {
  late ThemeMode themeMode;

  ThemeData litethemeData = ThemeData.light().copyWith(
    primaryColor: rPrimaryMaterialColorLite,
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: ButtonStyle(
        shape: MaterialStateProperty.all(RoundedRectangleBorder(
          side: const BorderSide(color: rPrimaryMaterialColor, width: 1),
          borderRadius: BorderRadius.circular(30),
        )),
        textStyle: MaterialStateProperty.all(
          const TextStyle(color: rPrimaryColor),
        ),
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all(rPrimaryMaterialColor),
        textStyle: MaterialStateProperty.all(
          const TextStyle(color: Colors.white),
        ),
      ),
    ),
    bottomAppBarTheme: const BottomAppBarTheme(
      color: rPrimaryLiteColor,
    ),
    textButtonTheme: TextButtonThemeData(
      style: ButtonStyle(
        textStyle: MaterialStateProperty.all(
          const TextStyle(color: rPrimaryMaterialColor),
        ),
      ),
    ),
    appBarTheme: const AppBarTheme(
      elevation: 0.0,
      backgroundColor: rPrimaryLiteColor,
      titleTextStyle: TextStyle(
        fontSize: 23,
        color: rTextColor,
        fontWeight: FontWeight.bold,
        fontFamily: 'Righteous',
      ),
      iconTheme: IconThemeData(
        color: rTextColor,
      ),
    ),
    navigationBarTheme: const NavigationBarThemeData(
      backgroundColor: rPrimaryLiteColor,
      indicatorColor: rPrimaryMaterialColor,
    ),
    navigationRailTheme: const NavigationRailThemeData(
      backgroundColor: rPrimaryLiteColor,
      indicatorColor: rPrimaryMaterialColor,
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: rPrimaryColor,
    ),
  );
  ThemeData darkthemeData = ThemeData.dark().copyWith(
    primaryColor: rPrimaryDarkLiteColor,
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all(rPrimaryDarkLiteColor),
        shape: MaterialStateProperty.all(RoundedRectangleBorder(
          side: const BorderSide(color: Colors.tealAccent, width: 1),
          borderRadius: BorderRadius.circular(30),
        )),
        textStyle: MaterialStateProperty.all(
          const TextStyle(color: Colors.white),
        ),
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all(Colors.tealAccent),
        textStyle: MaterialStateProperty.all(
          const TextStyle(color: rPrimaryDarkLiteColor),
        ),
      ),
    ),
    bottomAppBarTheme: const BottomAppBarTheme(
      color: rPrimaryDarkLiteColor,
    ),
    textButtonTheme: TextButtonThemeData(
      style: ButtonStyle(
        textStyle: MaterialStateProperty.all(
          const TextStyle(color: rPrimaryMaterialColor),
        ),
      ),
    ),
    appBarTheme: const AppBarTheme(
      elevation: 0.0,
      backgroundColor: rPrimaryDarkLiteColor,
      titleTextStyle: TextStyle(
        fontSize: 23,
        color: Colors.white,
        fontWeight: FontWeight.bold,
        fontFamily: 'Righteous',
      ),
      iconTheme: IconThemeData(
        color: Colors.white,
      ),
    ),
    navigationBarTheme: const NavigationBarThemeData(
      backgroundColor: rPrimaryDarkLiteColor,
      indicatorColor: Colors.tealAccent,
    ),
    navigationRailTheme: const NavigationRailThemeData(
      backgroundColor: rPrimaryDarkLiteColor,
      indicatorColor: Colors.tealAccent,
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: Colors.teal,
    ),
  );

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
