import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'colors.dart';
import 'typography.dart';

bool _isSelected(Set<WidgetState> states) =>
    states.contains(WidgetState.selected);

bool _isDisabled(Set<WidgetState> states) =>
    states.contains(WidgetState.disabled);

DatePickerThemeData ledgrDatePickerTheme(LedgrColors colors) {
  return DatePickerThemeData(
    backgroundColor: colors.surface,
    headerBackgroundColor: colors.primaryContainer,
    headerForegroundColor: colors.onPrimary,
    dividerColor: colors.rule,
    dayStyle: uiStyle(fontSize: 13, height: 1),
    dayForegroundColor: WidgetStateProperty.resolveWith((states) {
      if (_isSelected(states)) return colors.onPrimary;
      if (_isDisabled(states)) return colors.secondary.withValues(alpha: 0.38);
      return colors.onSurface;
    }),
    dayBackgroundColor: WidgetStateProperty.resolveWith((states) {
      if (_isSelected(states)) return colors.primaryContainer;
      return null;
    }),
    todayForegroundColor: WidgetStateProperty.resolveWith((states) {
      if (_isSelected(states)) return colors.onPrimary;
      if (_isDisabled(states)) return colors.secondary.withValues(alpha: 0.38);
      return colors.primary;
    }),
    todayBackgroundColor: WidgetStateProperty.resolveWith((states) {
      if (_isSelected(states)) return colors.primaryContainer;
      return null;
    }),
    todayBorder: BorderSide(color: colors.primary),
  );
}

ThemeData buildLedgrTheme(LedgrColors colors, Brightness brightness) {
  final overlay = brightness == Brightness.dark
      ? SystemUiOverlayStyle.light
      : SystemUiOverlayStyle.dark;
  return ThemeData(
    useMaterial3: true,
    brightness: brightness,
    fontFamily: spaceGrotesk,
    scaffoldBackgroundColor: colors.surface,
    extensions: [colors],
    colorScheme: ColorScheme(
      brightness: brightness,
      primary: colors.primary,
      onPrimary: colors.onPrimary,
      secondary: colors.primaryContainer,
      onSecondary: colors.onPrimary,
      surface: colors.surface,
      onSurface: colors.onSurface,
      error: colors.ledgerRed,
      onError: colors.onPrimary,
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: colors.surface,
      foregroundColor: colors.onSurface,
      elevation: 0,
      scrolledUnderElevation: 0,
      centerTitle: false,
      systemOverlayStyle: overlay,
      titleTextStyle: TextStyle(
        fontFamily: spaceGrotesk,
        fontWeight: FontWeight.w500,
        fontSize: 14,
        color: colors.onSurface,
      ),
    ),
    dividerColor: colors.rule,
    dividerTheme: DividerThemeData(
      color: colors.rule,
      thickness: 1,
      space: 1,
    ),
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: colors.primaryContainer,
      foregroundColor: colors.onPrimary,
      elevation: 4,
      focusElevation: 4,
      hoverElevation: 4,
      highlightElevation: 4,
      shape: const CircleBorder(),
    ),
    datePickerTheme: ledgrDatePickerTheme(colors),
    textTheme: TextTheme(
      displayLarge: amountStyle(fontSize: 40, color: colors.onSurface),
      displayMedium: amountStyle(fontSize: 32, color: colors.onSurface),
      headlineSmall: amountStyle(fontSize: 24, color: colors.onSurface),
      bodyLarge: uiStyle(fontSize: 14, color: colors.onSurface),
      bodyMedium: uiStyle(fontSize: 13, color: colors.secondary),
      labelLarge: uiStyle(
        fontSize: 15,
        fontWeight: FontWeight.w500,
        color: colors.onPrimary,
      ),
      labelSmall: uiStyle(fontSize: 12, color: colors.secondary),
    ),
    snackBarTheme: SnackBarThemeData(
      backgroundColor: colors.onSurface,
      contentTextStyle: TextStyle(
        fontFamily: spaceGrotesk,
        fontSize: 14,
        color: colors.surface,
      ),
      behavior: SnackBarBehavior.floating,
    ),
    dialogTheme: DialogThemeData(
      backgroundColor: colors.paperLight,
      titleTextStyle: uiStyle(
        fontSize: 16,
        fontWeight: FontWeight.w500,
        color: colors.onSurface,
      ),
      contentTextStyle: uiStyle(fontSize: 14, color: colors.secondary),
    ),
    bottomSheetTheme: BottomSheetThemeData(
      backgroundColor: colors.paperLight,
      surfaceTintColor: Colors.transparent,
    ),
  );
}

final ledgrLightTheme = buildLedgrTheme(LedgrColors.light, Brightness.light);
final ledgrDarkTheme = buildLedgrTheme(LedgrColors.dark, Brightness.dark);

@Deprecated('Use ledgrLightTheme')
final ledgrTheme = ledgrLightTheme;
