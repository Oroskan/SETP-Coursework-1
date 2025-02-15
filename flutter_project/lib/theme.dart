import 'package:flutter/material.dart';

ThemeData getTheme(bool darkMode) {
  final baseTheme = darkMode ? ThemeData.dark() : ThemeData.light();
  final primaryColor = darkMode ? Colors.purple[200] : Colors.purple[300];
  final backgroundColor = darkMode ? Colors.purple[800] : Colors.purple[50];

  return baseTheme.copyWith(
    primaryColor: primaryColor,
    colorScheme:
        (darkMode ? const ColorScheme.dark() : const ColorScheme.light())
            .copyWith(
      primary: primaryColor,
      secondary: Colors.purple[200],
    ),
    appBarTheme: AppBarTheme(
        backgroundColor: darkMode ? backgroundColor : primaryColor),
    navigationBarTheme: NavigationBarThemeData(
      backgroundColor: backgroundColor,
      indicatorColor: darkMode ? primaryColor : Colors.purple[100],
    ),
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: primaryColor,
      foregroundColor: Colors.white,
    ),
    cardTheme: CardTheme(color: backgroundColor),
  );
}