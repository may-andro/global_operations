import 'package:flutter/services.dart';

/// Service for managing Google Maps custom styles
///
/// Provides light and dark theme styles that automatically
/// match your app's theme mode for a consistent user experience.
class MapStyleService {
  // Private constructor to prevent instantiation
  MapStyleService._();

  // Asset paths for map style JSON files in the design_system package
  static const String _lightStylePath =
      'packages/design_system/assets/map_styles/light_map_style.json';
  static const String _darkStylePath =
      'packages/design_system/assets/map_styles/dark_map_style.json';

  // Cached styles to avoid repeated asset loading
  static String? _lightStyle;
  static String? _darkStyle;

  /// Load and return the light theme map style
  ///
  /// This style features a clean, minimalist design perfect for light mode.
  /// The style is cached after first load for better performance.
  static Future<String> getLightStyle() async {
    try {
      _lightStyle ??= await rootBundle.loadString(_lightStylePath);
      return _lightStyle!;
    } catch (e) {
      // Fallback to no style if loading fails
      return '';
    }
  }

  /// Load and return the dark theme map style
  ///
  /// This style features a sleek dark design perfect for dark mode.
  /// The style is cached after first load for better performance.
  static Future<String> getDarkStyle() async {
    try {
      _darkStyle ??= await rootBundle.loadString(_darkStylePath);
      return _darkStyle!;
    } catch (e) {
      // Fallback to no style if loading fails
      return '';
    }
  }

  /// Get the appropriate map style based on theme mode
  ///
  /// Automatically returns dark style for dark mode and light style for light mode.
  /// This is the recommended method for automatic theme-based styling.
  ///
  /// [isDarkMode] - Whether the app is currently in dark mode
  static Future<String> getStyleForTheme({required bool isDarkMode}) async {
    return isDarkMode ? await getDarkStyle() : await getLightStyle();
  }

  /// Clear cached styles
  ///
  /// Useful during development for hot reload or when you want to force
  /// reloading of map styles (e.g., after updating style files).
  static void clearCache() {
    _lightStyle = null;
    _darkStyle = null;
  }

  /// Check if styles are currently cached
  static bool get hasCachedStyles => _lightStyle != null && _darkStyle != null;
}
