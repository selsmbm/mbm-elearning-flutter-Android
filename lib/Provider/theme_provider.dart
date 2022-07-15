import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mbm_elearning/Presentation/Constants/Colors.dart';

class ThemeService {
  Future<ThemeMode> themeMode() async => ThemeMode.system;
  Future<void> updateThemeMode(ThemeMode theme) async {}
}

class ThemeController with ChangeNotifier {
  ThemeController(this.themeService);
  final ThemeService themeService;
  late ThemeMode themeMode;

  ThemeData litethemeData = ThemeData.light().copyWith(
    primaryColor: rPrimaryMaterialColorLite,
    useMaterial3: true,
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
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: rPrimaryColor,
    ),
  );
  ThemeData darkthemeData = ThemeData.dark().copyWith(
    useMaterial3: true,
  );

  Future<void> loadSettings() async {
    themeMode = await themeService.themeMode();
    notifyListeners();
  }
}
