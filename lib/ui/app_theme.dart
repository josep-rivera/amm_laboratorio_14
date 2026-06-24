import 'package:flutter/material.dart';

abstract final class AppTheme {
  static const _seed = Color(0xFF6750A4);

  static ThemeData get light => ThemeData(
        useMaterial3: true,
        colorSchemeSeed: _seed,
        brightness: Brightness.light,
        cardTheme: const CardThemeData(elevation: 0),
        inputDecorationTheme: const InputDecorationTheme(
          border: OutlineInputBorder(),
          filled: true,
        ),
      );
}
