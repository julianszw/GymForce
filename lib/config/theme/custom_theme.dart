import 'package:flutter/material.dart';

final ThemeData customTheme = ThemeData(
  // Definir colores principales
  primaryColor: Colors.yellow,
  hintColor: Colors.amberAccent,

  // Definir esquema de colores
  colorScheme: ColorScheme(
    primary: const Color(0xFFFFD202),
    primaryContainer: Colors.yellow[700]!,
    secondary: Colors.amber,
    secondaryContainer: Colors.amber[700]!,
    surface: const Color(0xFF212121), // Equivale al background
    error: Colors.red,
    onPrimary: Colors.black,
    onSecondary: Colors.white,
    onSurface: Colors.white,
    onError: Colors.white,
    brightness: Brightness.dark, // Modo oscuro
  ),

  // Personalizar los botones
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: const Color(0xFFFFD202),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
    ),
  ),

  // Definir estilo del texto
  textTheme: const TextTheme(
    displayLarge: TextStyle(
        fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
    bodyLarge: TextStyle(fontSize: 16, color: Colors.white),
  ),
);
