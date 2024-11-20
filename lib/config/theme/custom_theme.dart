import 'package:flutter/material.dart';

final ThemeData customTheme = ThemeData(
  primaryColor: Colors.yellow,
  hintColor: Colors.amberAccent,
  colorScheme: ColorScheme(
    primary: const Color(0xFFFFD202),
    primaryContainer: Colors.yellow[700]!,
    secondary: Colors.amber,
    secondaryContainer: Colors.amber[700]!,
    surface: const Color(0xFF212121),
    error: Colors.red,
    onPrimary: Colors.black,
    onSecondary: Colors.white,
    onSurface: Colors.white,
    onError: Colors.white,
    brightness: Brightness.dark,
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: const Color(0xFFFFD202),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
    ),
  ),
  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: Colors.white,
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: BorderSide.none,
    ),
    hintStyle: const TextStyle(color: Colors.grey),
    errorStyle: const TextStyle(color: Colors.red),
  ),
  textTheme: const TextTheme(
    displayLarge: TextStyle(
        fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
    bodyLarge: TextStyle(fontSize: 16, color: Colors.white),
  ),
);
