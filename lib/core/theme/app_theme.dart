import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData get dark => ThemeData(
    brightness: Brightness.dark,
    colorScheme: ColorScheme.fromSeed(
      seedColor: const Color(0xFFD4A853),
      brightness: Brightness.dark,
    ),
    useMaterial3: true,
  );

  static ThemeData get light => ThemeData(
    brightness: Brightness.light,
    colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFFD4A853)),
    useMaterial3: true,
  );
}
