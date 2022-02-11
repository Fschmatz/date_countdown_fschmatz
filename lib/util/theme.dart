import 'package:flutter/material.dart';

ThemeData light = ThemeData(
    brightness: Brightness.light,
    primaryColor: Color(0xFFF3F2F2),
    accentColor: Colors.red,
    scaffoldBackgroundColor: Color(0xFFF3F2F2),
    colorScheme: ColorScheme.light(
      primary: Colors.red,
      secondary: Colors.red,
    ),
    appBarTheme: const AppBarTheme(
        color: Color(0xFFF3F2F2),
        elevation: 0,
        iconTheme: IconThemeData(
            color: Color(0xFF050505)
        ),
        titleTextStyle: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Color(0xFF000000))),
    cardTheme: CardTheme(
      color: Color(0xFFFFFEFE),//0xFFF3F2F2
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
          borderRadius: BorderRadius.circular(12.0),
        ),
        enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Colors.grey,
            ),
            borderRadius: BorderRadius.circular(12.0)),
        border: OutlineInputBorder(
            borderSide: BorderSide(
              color: Colors.grey,
            ),
            borderRadius: BorderRadius.circular(12.0))
    ),
    accentTextTheme: TextTheme(
      headline1: TextStyle(color: Colors.redAccent),
      headline2: TextStyle(color:  Colors.redAccent),
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: Color(0xFFF3F2F2),
    ),
    bottomAppBarColor: Color(0xFFF3F2F2),
    bottomSheetTheme:
        BottomSheetThemeData(modalBackgroundColor: Color(0xFFF3F2F2)));


ThemeData dark = ThemeData(
    brightness: Brightness.dark,
    primaryColor: Color(0xFF1B1B1F),
    accentColor: Color(0xFFD46062),
    scaffoldBackgroundColor: Color(0xFF1B1B1F),
    colorScheme: ColorScheme.dark(
      primary: Color(0xFFD46062),
      secondary: Color(0xFFD46062),
    ),
    appBarTheme: const AppBarTheme(
        color: Color(0xFF1B1B1F),
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
          borderRadius: BorderRadius.circular(12.0),
        ),
        enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Colors.grey,
            ),
            borderRadius: BorderRadius.circular(12.0)),
        border: OutlineInputBorder(
            borderSide: BorderSide(
              color: Colors.grey,
            ),
            borderRadius: BorderRadius.circular(12.0))
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: Color(0xFF1B1B1F),
    ),
    accentTextTheme: TextTheme(
      headline1: TextStyle(color:  Color(0xFFff8b87)),
      headline2: TextStyle(color:  Color(0xFF2B2B2D)),
    ),
    bottomAppBarColor: Color(0xFF1B1B1F),
    bottomSheetTheme:
        BottomSheetThemeData(modalBackgroundColor: Color(0xFF1B1B1F)));
