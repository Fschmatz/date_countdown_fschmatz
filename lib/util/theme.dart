import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

//CLARO
ThemeData light = ThemeData(
    brightness: Brightness.light,
    primaryColor: Color(0xFFFFFFFF),
    accentColor: Colors.red[700],
    scaffoldBackgroundColor: Color(0xFFFFFFFF),
    cardTheme: CardTheme(
      color: Color(0xFFF5F5F5),
    ),
    dialogTheme: DialogTheme(
      backgroundColor: Color(0xFFF9F9F9),
    ),
    inputDecorationTheme: InputDecorationTheme(
        contentPadding: EdgeInsets.symmetric(
            vertical: 15.0, horizontal: 10.0),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.red,
          ),
          borderRadius: BorderRadius.circular(15.0),
        ),
        enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Colors.grey,
            ),
            borderRadius: BorderRadius.circular(15.0)),
        border: OutlineInputBorder(
            borderSide: BorderSide(
              color: Colors.grey,
            ),
            borderRadius: BorderRadius.circular(15.0))
    ),
    accentTextTheme: TextTheme(
      headline1: TextStyle(color: Colors.red),
    ),
    bottomAppBarColor: Color(0xFFE2E2E2),
    bottomSheetTheme:
        BottomSheetThemeData(modalBackgroundColor: Color(0xFFFFFFFF)));

//ESCURO
ThemeData dark = ThemeData(
    brightness: Brightness.dark,
    primaryColor: Color(0xFF202022),
    accentColor: Color(0xFFD46062),
    scaffoldBackgroundColor: Color(0xFF202022),
    cardTheme: CardTheme(
      color: Color(0xFF29292B),
    ),
    dialogTheme: DialogTheme(
      backgroundColor: Color(0xFF29292B),
    ),
    inputDecorationTheme: InputDecorationTheme(
        contentPadding: EdgeInsets.symmetric(
            vertical: 15.0, horizontal: 10.0),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: Color(0xFFD46062),
          ),
          borderRadius: BorderRadius.circular(15.0),
        ),
        enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Colors.grey,
            ),
            borderRadius: BorderRadius.circular(15.0)),
        border: OutlineInputBorder(
            borderSide: BorderSide(
              color: Colors.grey,
            ),
            borderRadius: BorderRadius.circular(15.0))
    ),
    accentTextTheme: TextTheme(
      headline1: TextStyle(color:  Color(0xFFff8b87)),
    ),
    bottomAppBarColor: Color(0xFF151517),
    bottomSheetTheme:
        BottomSheetThemeData(modalBackgroundColor: Color(0xFF202022)));

class ThemeNotifier extends ChangeNotifier {
  final String key = 'valorTema';
  late SharedPreferences prefs;
  late bool _darkTheme;

  bool get darkTheme => _darkTheme;

  ThemeNotifier() {
     _darkTheme = true;
    _loadFromPrefs();
  }

  toggleTheme() {
    _darkTheme = !_darkTheme;
    _saveToPrefs();
    notifyListeners();
  }

  _initPrefs() async {
      prefs = await SharedPreferences.getInstance();
  }

  _loadFromPrefs() async {
    await _initPrefs();
    _darkTheme = prefs.getBool(key) ?? true;
    notifyListeners();
  }

  _saveToPrefs() async {
    await _initPrefs();
    prefs.setBool(key, _darkTheme);
  }
}
