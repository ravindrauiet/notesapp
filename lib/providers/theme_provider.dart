import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../constants/app_constants.dart';

class ThemeProvider with ChangeNotifier {
  static const String _themeKey = 'theme_mode';
  
  ThemeMode _themeMode = ThemeMode.light;
  bool _isDark = false;

  // Getters
  ThemeMode get themeMode => _themeMode;
  bool get isDark => _isDark;
  bool get isLight => !_isDark;

  // Initialize theme from shared preferences
  Future<void> initializeTheme() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final savedTheme = prefs.getString(_themeKey);
      
      if (savedTheme != null) {
        switch (savedTheme) {
          case 'light':
            _themeMode = ThemeMode.light;
            _isDark = false;
            break;
          case 'dark':
            _themeMode = ThemeMode.dark;
            _isDark = true;
            break;
          case 'system':
            _themeMode = ThemeMode.system;
            _isDark = false; // Will be determined by system
            break;
        }
        notifyListeners();
      }
    } catch (e) {
      print('Error initializing theme: $e');
    }
  }

  // Toggle between light and dark theme
  Future<void> toggleTheme() async {
    try {
      _isDark = !_isDark;
      _themeMode = _isDark ? ThemeMode.dark : ThemeMode.light;
      
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_themeKey, _isDark ? 'dark' : 'light');
      
      notifyListeners();
    } catch (e) {
      print('Error toggling theme: $e');
    }
  }

  // Set specific theme mode
  Future<void> setThemeMode(ThemeMode mode) async {
    try {
      _themeMode = mode;
      _isDark = mode == ThemeMode.dark;
      
      final prefs = await SharedPreferences.getInstance();
      String themeString;
      switch (mode) {
        case ThemeMode.light:
          themeString = 'light';
          break;
        case ThemeMode.dark:
          themeString = 'dark';
          break;
        case ThemeMode.system:
          themeString = 'system';
          break;
      }
      await prefs.setString(_themeKey, themeString);
      
      notifyListeners();
    } catch (e) {
      print('Error setting theme mode: $e');
    }
  }

  // Get light theme
  ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: const ColorScheme.light(
        primary: Color(0xFF1A73E8),
        secondary: Color(0xFF34A853),
        surface: AppConstants.lightSecondary,
        background: AppConstants.lightPrimary,
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        onSurface: AppConstants.lightTextPrimary,
        onBackground: AppConstants.lightTextPrimary,
      ),
      scaffoldBackgroundColor: AppConstants.lightPrimary,
      appBarTheme: const AppBarTheme(
        backgroundColor: AppConstants.lightSecondary,
        foregroundColor: AppConstants.lightTextPrimary,
        elevation: 0,
        centerTitle: false,
      ),
      cardTheme: CardThemeData(
        color: AppConstants.lightSecondary,
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppConstants.radiusMedium),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppConstants.lightSecondary,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppConstants.radiusSmall),
          borderSide: const BorderSide(color: AppConstants.lightBorder),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppConstants.radiusSmall),
          borderSide: const BorderSide(color: AppConstants.lightBorder),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppConstants.radiusSmall),
          borderSide: const BorderSide(color: AppConstants.lightPrimary, width: 2),
        ),
        hintStyle: const TextStyle(color: AppConstants.lightTextTertiary),
      ),
      textTheme: const TextTheme(
        headlineLarge: TextStyle(
          color: AppConstants.lightTextPrimary,
          fontSize: 32,
          fontWeight: FontWeight.bold,
        ),
        headlineMedium: TextStyle(
          color: AppConstants.lightTextPrimary,
          fontSize: 28,
          fontWeight: FontWeight.bold,
        ),
        headlineSmall: TextStyle(
          color: AppConstants.lightTextPrimary,
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
        titleLarge: TextStyle(
          color: AppConstants.lightTextPrimary,
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
        titleMedium: TextStyle(
          color: AppConstants.lightTextPrimary,
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
        titleSmall: TextStyle(
          color: AppConstants.lightTextPrimary,
          fontSize: 14,
          fontWeight: FontWeight.w600,
        ),
        bodyLarge: TextStyle(
          color: AppConstants.lightTextPrimary,
          fontSize: 16,
        ),
        bodyMedium: TextStyle(
          color: AppConstants.lightTextPrimary,
          fontSize: 14,
        ),
        bodySmall: TextStyle(
          color: AppConstants.lightTextSecondary,
          fontSize: 12,
        ),
      ),
    );
  }

  // Get dark theme
  ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: const ColorScheme.dark(
        primary: Color(0xFF8AB4F8),
        secondary: Color(0xFF81C995),
        surface: AppConstants.darkSecondary,
        background: AppConstants.darkPrimary,
        onPrimary: Colors.black,
        onSecondary: Colors.black,
        onSurface: AppConstants.darkTextPrimary,
        onBackground: AppConstants.darkTextPrimary,
      ),
      scaffoldBackgroundColor: AppConstants.darkPrimary,
      appBarTheme: const AppBarTheme(
        backgroundColor: AppConstants.darkSecondary,
        foregroundColor: AppConstants.darkTextPrimary,
        elevation: 0,
        centerTitle: false,
      ),
      cardTheme: CardThemeData(
        color: AppConstants.darkSecondary,
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppConstants.radiusMedium),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppConstants.darkSecondary,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppConstants.radiusSmall),
          borderSide: const BorderSide(color: AppConstants.darkBorder),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppConstants.radiusSmall),
          borderSide: const BorderSide(color: AppConstants.darkBorder),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppConstants.radiusSmall),
          borderSide: const BorderSide(color: AppConstants.darkPrimary, width: 2),
        ),
        hintStyle: const TextStyle(color: AppConstants.darkTextTertiary),
      ),
      textTheme: const TextTheme(
        headlineLarge: TextStyle(
          color: AppConstants.darkTextPrimary,
          fontSize: 32,
          fontWeight: FontWeight.bold,
        ),
        headlineMedium: TextStyle(
          color: AppConstants.darkTextPrimary,
          fontSize: 28,
          fontWeight: FontWeight.bold,
        ),
        headlineSmall: TextStyle(
          color: AppConstants.darkTextPrimary,
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
        titleLarge: TextStyle(
          color: AppConstants.darkTextPrimary,
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
        titleMedium: TextStyle(
          color: AppConstants.darkTextPrimary,
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
        titleSmall: TextStyle(
          color: AppConstants.darkTextPrimary,
          fontSize: 14,
          fontWeight: FontWeight.w600,
        ),
        bodyLarge: TextStyle(
          color: AppConstants.darkTextPrimary,
          fontSize: 16,
        ),
        bodyMedium: TextStyle(
          color: AppConstants.darkTextPrimary,
          fontSize: 14,
        ),
        bodySmall: TextStyle(
          color: AppConstants.darkTextSecondary,
          fontSize: 12,
        ),
      ),
    );
  }
}
