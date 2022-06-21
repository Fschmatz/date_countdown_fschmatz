import 'package:flutter/material.dart';

ThemeData light = ThemeData(
    useMaterial3: true,
    textTheme: const TextTheme(
      titleMedium: TextStyle(fontWeight: FontWeight.w400),
    ),
    brightness: Brightness.light,
    primaryColor: Color(0xFFF3F2F2),
    scaffoldBackgroundColor: Color(0xFFF3F2F2),
    colorScheme: ColorScheme.light(
      primary: Colors.red,
      secondary: Colors.red,
      onPrimary: Color(0xFFFFFFFF),
    ),
    appBarTheme: const AppBarTheme(
      surfaceTintColor: Color(0xFFF3F2F2),
      color: Color(0xFFF3F2F2),
    ),
    cardTheme: CardTheme(
      surfaceTintColor: Color(0xFFFFFEFE),
      color: Color(0xFFFFFEFE),
    ),
    dialogTheme: DialogTheme(
      backgroundColor: Color(0xFFFFFEFE),
    ),
    floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: Colors.redAccent.shade200),
    inputDecorationTheme: InputDecorationTheme(
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.red,
          ),
          borderRadius: BorderRadius.circular(8.0),
        ),
        enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Colors.grey,
            ),
            borderRadius: BorderRadius.circular(8.0)),
        border: OutlineInputBorder(
            borderSide: BorderSide(
              color: Colors.grey,
            ),
            borderRadius: BorderRadius.circular(8.0))),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: Color(0xFFF3F2F2),
    ),
    bottomAppBarColor: Color(0xFFF3F2F2),
    bottomSheetTheme:
        BottomSheetThemeData(modalBackgroundColor: Color(0xFFF3F2F2)));

ThemeData dark = ThemeData(
    useMaterial3: true,
    textTheme: const TextTheme(
      titleMedium: TextStyle(fontWeight: FontWeight.w400),
    ),
    brightness: Brightness.dark,
    primaryColor: Color(0xFF1B1B1F),
    scaffoldBackgroundColor: Color(0xFF1B1B1F),
    colorScheme: ColorScheme.dark(
      primary: Color(0xFFD46062),
      onPrimary: Color(0xFF60131A),
      secondary: Color(0xFFff8b87),
    ),
    appBarTheme: const AppBarTheme(
      surfaceTintColor: Color(0xFF1B1B1F),
      color: Color(0xFF1B1B1F),
    ),
    cardTheme: CardTheme(
      surfaceTintColor: Color(0xFF2B2B2F),
      color: Color(0xFF2B2B2F),
    ),
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: Color(0xFFFFB3B3),
    ),
    dialogTheme: DialogTheme(
      backgroundColor: Color(0xFF2B2B2F),
    ),
    inputDecorationTheme: InputDecorationTheme(
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: Color(0xFFD46062),
          ),
          borderRadius: BorderRadius.circular(8.0),
        ),
        enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Color(0xFF938180),
            ),
            borderRadius: BorderRadius.circular(8.0)),
        border: OutlineInputBorder(
            borderSide: BorderSide(
              color: Color(0xFF938180),
            ),
            borderRadius: BorderRadius.circular(8.0))),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: Color(0xFF1B1B1F),
    ),
    bottomAppBarColor: Color(0xFF1B1B1F),
    bottomSheetTheme:
        BottomSheetThemeData(modalBackgroundColor: Color(0xFF1B1B1F)));
