import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

//CLARO
ThemeData light = ThemeData(
    brightness: Brightness.light,
    primaryColorBrightness: Brightness.dark,
    primaryColor: Color(0xFFF1F0F0),
    accentColor: Colors.red,
    scaffoldBackgroundColor: Color(0xFFF1F0F0),
    appBarTheme: const AppBarTheme(
        color: Color(0xFFF1F0F0),
        elevation: 0,
        iconTheme: IconThemeData(
            color: Color(0xFF151515)
        ),
        titleTextStyle: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Color(0xFF000000))),
    cardTheme: CardTheme(
      color: Color(0xFFFFFEFE),//0xFFF1F0F0
    ),
    dialogTheme: DialogTheme(
      backgroundColor: Color(0xFFFFFEFE),
    ),
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: Colors.redAccent.shade200
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
      headline1: TextStyle(color: Colors.redAccent),
      headline2: TextStyle(color:  Colors.redAccent),
    ),
    bottomAppBarColor: Color(0xFFF1F0F0),
    bottomSheetTheme:
        BottomSheetThemeData(modalBackgroundColor: Color(0xFFFFFEFE)));

//ESCURO
ThemeData dark = ThemeData(
    brightness: Brightness.dark,
    primaryColorBrightness: Brightness.light,
    primaryColor: Color(0xFF1B1B1D),
    accentColor: Color(0xFFD46062),
    scaffoldBackgroundColor: Color(0xFF1B1B1D),
    appBarTheme: const AppBarTheme(
        color: Color(0xFF1B1B1D),
        elevation: 0,
        iconTheme: IconThemeData(
            color: Color(0xFFF5F5F5)
        ),
        titleTextStyle: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Color(0xFFFFFFFF))),
    cardTheme: CardTheme(
      elevation: 0,
      color: Color(0xFF2B2B2F),
    ),
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: Color(0xFFe3787a),
    ),
    dialogTheme: DialogTheme(
      backgroundColor: Color(0xFF2B2B2F),
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
      headline2: TextStyle(color:  Color(0xFF2B2B2D)),
    ),
    bottomAppBarColor: Color(0xFF1B1B1D),
    bottomSheetTheme:
        BottomSheetThemeData(modalBackgroundColor: Color(0xFF1B1B1D)));

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
