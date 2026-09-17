import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'colors.dart';
import 'typography.dart';

bool _isSelected(Set<WidgetState> states) =>
    states.contains(WidgetState.selected);

bool _isDisabled(Set<WidgetState> states) =>
    states.contains(WidgetState.disabled);

/// Today uses [DatePickerThemeData.todayForegroundColor] for both the digit
/// and the ring. Selected today must be light-on-teal or the number vanishes.
DatePickerThemeData get ledgrDatePickerTheme {
  return DatePickerThemeData(
    backgroundColor: paper,
    headerBackgroundColor: inkNavy,
    headerForegroundColor: paper,
    dividerColor: ruleColor,
    dayStyle: uiStyle(fontSize: 13, height: 1),
    dayForegroundColor: WidgetStateProperty.resolveWith((states) {
      if (_isSelected(states)) return tealOnAccent;
      if (_isDisabled(states)) return mutedInk.withValues(alpha: 0.38);
      return inkNavy;
    }),
    dayBackgroundColor: WidgetStateProperty.resolveWith((states) {
      if (_isSelected(states)) return tealAccent;
      return null;
    }),
    todayForegroundColor: WidgetStateProperty.resolveWith((states) {
      if (_isSelected(states)) return tealOnAccent;
      if (_isDisabled(states)) return mutedInk.withValues(alpha: 0.38);
      return tealAccent;
    }),
    todayBackgroundColor: WidgetStateProperty.resolveWith((states) {
      if (_isSelected(states)) return tealAccent;
      return null;
    }),
    todayBorder: const BorderSide(color: tealAccent),
  );
}

final ledgrTheme = ThemeData(
  useMaterial3: true,
  brightness: Brightness.light,
  fontFamily: spaceGrotesk,
  scaffoldBackgroundColor: paper,
  colorScheme: const ColorScheme.light(
    primary: tealAccent,
    onPrimary: tealOnAccent,
    secondary: tealAccent,
    onSecondary: tealOnAccent,
    surface: paper,
    onSurface: inkNavy,
    error: ledgerRed,
    onError: paper,
  ),
  appBarTheme: const AppBarTheme(
    backgroundColor: inkNavy,
    foregroundColor: paper,
    elevation: 0,
    scrolledUnderElevation: 0,
    centerTitle: true,
    systemOverlayStyle: SystemUiOverlayStyle.light,
    titleTextStyle: TextStyle(
      fontFamily: spaceGrotesk,
      fontWeight: FontWeight.w500,
      fontSize: 14,
      color: paper,
    ),
  ),
  dividerColor: ruleColor,
  dividerTheme: const DividerThemeData(
    color: ruleColor,
    thickness: 1,
    space: 1,
  ),
  floatingActionButtonTheme: const FloatingActionButtonThemeData(
    backgroundColor: tealAccent,
    foregroundColor: tealOnAccent,
    elevation: 0,
    focusElevation: 0,
    hoverElevation: 0,
    highlightElevation: 0,
    shape: CircleBorder(),
  ),
  datePickerTheme: ledgrDatePickerTheme,
  textTheme: TextTheme(
    displayLarge: amountStyle(fontSize: 40),
    displayMedium: amountStyle(fontSize: 30),
    headlineSmall: amountStyle(fontSize: 19, color: paper),
    bodyLarge: uiStyle(fontSize: 14),
    bodyMedium: uiStyle(fontSize: 13, color: mutedInk),
    labelLarge: uiStyle(fontSize: 15, fontWeight: FontWeight.w500, color: tealOnAccent),
    labelSmall: uiStyle(fontSize: 12, color: mutedInk),
  ),
  snackBarTheme: const SnackBarThemeData(
    backgroundColor: inkNavy,
    contentTextStyle: TextStyle(
      fontFamily: spaceGrotesk,
      fontSize: 14,
      color: paper,
    ),
    behavior: SnackBarBehavior.floating,
  ),
  dialogTheme: DialogThemeData(
    backgroundColor: paper,
    titleTextStyle: uiStyle(fontSize: 16, fontWeight: FontWeight.w500),
    contentTextStyle: uiStyle(fontSize: 14, color: mutedInk),
  ),
);
