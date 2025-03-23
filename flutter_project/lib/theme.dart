import 'package:flutter/material.dart';
import 'package:flutter_settings_screens/flutter_settings_screens.dart';

// Settings key for dark mode
const String keyDarkMode = 'key-dark-mode';

// Global theme state manager
final ValueNotifier<bool> darkModeNotifier = ValueNotifier<bool>(false);

ThemeData getTheme(bool darkMode) {
  final baseTheme = darkMode ? ThemeData.dark() : ThemeData.light();
  final primaryColor =
      darkMode ? const Color(0xFF0A84FF) : const Color(0xFF007AFF);
  final backgroundColor =
      darkMode ? const Color(0xFF1C1C1E) : const Color(0xFFF2F2F7);
  final surfaceColor = darkMode ? const Color(0xFF2C2C2E) : Colors.white;
  final textColor = darkMode ? Colors.white : const Color(0xFF000000);
  final secondaryColor =
      darkMode ? const Color(0xFF64D2FF) : const Color(0xFF5AC8FA);

  return baseTheme.copyWith(
    primaryColor: primaryColor,
    scaffoldBackgroundColor: backgroundColor,
    colorScheme:
        (darkMode ? const ColorScheme.dark() : const ColorScheme.light())
            .copyWith(
      primary: primaryColor,
      secondary: secondaryColor,
      surface: surfaceColor,
      onSurface: textColor,
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: surfaceColor,
      foregroundColor: textColor,
      elevation: 0,
      centerTitle: true,
    ),
    navigationBarTheme: NavigationBarThemeData(
      backgroundColor: surfaceColor,
      indicatorColor: primaryColor.withOpacity(0.2),
      labelTextStyle: WidgetStateProperty.all(
        TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: textColor),
      ),
    ),
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: primaryColor,
      foregroundColor: Colors.white,
      shape: const StadiumBorder(),
    ),
    cardTheme: CardTheme(
      color: surfaceColor,
      elevation: 1.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
    ),
    dividerTheme: DividerThemeData(
      color: darkMode ? const Color(0xFF38383A) : const Color(0xFFC6C6C8),
      thickness: 0.5,
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(foregroundColor: primaryColor),
    ),
  );
}

// Helper class to access theme state from anywhere
class ThemeHelper {
  static bool isDarkMode() => darkModeNotifier.value;

  static void setDarkMode(bool value) {
    darkModeNotifier.value = value;
    // Save to persistent storage
    Settings.setValue<bool>(keyDarkMode, value);
  }

  static void toggleDarkMode() {
    setDarkMode(!darkModeNotifier.value);
  }
}
