import 'package:flutter/material.dart';

enum AppThemeMode {
  system,
  light,
  dark,
}

extension AppThemeModeX on AppThemeMode {
  ThemeMode get material {
    switch (this) {
      case AppThemeMode.system:
        return ThemeMode.system;
      case AppThemeMode.light:
        return ThemeMode.light;
      case AppThemeMode.dark:
        return ThemeMode.dark;
    }
  }

}
